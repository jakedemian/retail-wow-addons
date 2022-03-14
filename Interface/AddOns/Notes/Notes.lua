-- TODO chat print -> post text in any channel, define a delay

local waitTable = {};
local waitFrame = nil;

local NOTE_TEMPLATE = {title=NOTES_TEMPLATE_TITLE, category=nil, text="", type=1, received=nil};

local lastCursorPos = nil;

local NOTE_TYPE = {
    NOTES_TYPE_NOTODO,
    NOTES_TYPE_TODODONE,
    NOTES_TYPE_TODONOTDONE,
}

local NOTE_QUEST_INFO = {
    NOTES_CATEGORY_QUESTLINK,
    NOTES_CATEGORY_QUESTNAME,
    QUEST_OBJECTIVES,
    QUEST_REWARDS,
    PET.." ".. INFO,
    ACHIEVEMENT,
}

local selectedIndex = nil;
local selectedAddIndex = 1;

-- saved variables
NotesData = {};
NotesData.notes = {};
NotesData.collapsed = {};

NotesData.minimappos = 65;
NotesData.minimapbutton = true;

NotesData.selectedMiniNote = nil;

local history = {};
local historyIndex = 1;

local ldb = LibStub:GetLibrary("LibDataBroker-1.1");

local dataobj = ldb:NewDataObject("Notes", {
    type = "launcher",
    icon = "Interface\\Addons\\Notes\\images\\frame-icon-dataobject",
    OnClick = function(self, button)
        if button == "LeftButton" then
            NotesFrame_Toggle();
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine(BINDING_NAME_NOTESTOGGLE);
    end
});

StaticPopupDialogs["NOTES_EDIT_TITLE_POPUP"] = {
    text = NOTES_CHANGETITLE,
    button1 = NOTES_OK,
    button2 = NOTES_CANCEL,
    OnShow = function (self, data)
        self.editBox:SetText(data or "nil")
    end,
    OnAccept = function (self, data, data2)
        local text = self.editBox:GetText()
        Notes_ChangeTitle(text)
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

StaticPopupDialogs["NOTES_EDIT_CATEGORY_POPUP"] = {
    text = NOTES_CHANGECATEGORY,
    button1 = NOTES_OK,
    button2 = NOTES_CANCEL,
    OnShow = function (self, data)
        self.editBox:SetText(data or "nil")
    end,
    OnAccept = function (self, data, data2)
        local text = self.editBox:GetText()
        Notes_ChangeCategory(text)
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

StaticPopupDialogs["NOTES_SEND_NOTE"] = {
    text = MAIL_TO_LABEL,
    button1 = NOTES_OK,
    button2 = NOTES_CANCEL,
    OnShow = function (self, data)
        self.editBox:SetText(data or "nil")
    end,
    OnAccept = function (self, data, data2)
        local name = self.editBox:GetText()
        Notes_SendNoteToPlayer("WHISPER", name)
    end,
    hasEditBox = true,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

-- functions
function Notes_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("ADDON_LOADED");

    self:RegisterEvent("CHAT_MSG_ADDON");

    TextBodyEditBox:RegisterForDrag("LeftButton");

    -- register for addon messages
    C_ChatInfo.RegisterAddonMessagePrefix("NI_SendNote");
    C_ChatInfo.RegisterAddonMessagePrefix("NI_SendNote+");

    tinsert(UISpecialFrames, self:GetName());

    Notes_InitSlashCommandHandler();
end

function Notes_InitSlashCommandHandler()

    SLASH_NOTES1 = "/note";
    SLASH_NOTES2 = "/notes";
    SlashCmdList["NOTES"] = function(msg)
        Notes_SlashCommandHandler(msg);
    end
end

local debug = false;
function notes_debug(...)
    if (not debug) then
        return;
    end

    local message = "";

    for i = 1, select("#", ...) do
		message = message .. " " .. (select(i, ...) or "nil");
	end

    DEFAULT_CHAT_FRAME:AddMessage("DEBUG:"..(message or "nil"), 1.0, 1.0, 1.0, 1, 10);
end

function Notes_SlashCommandHandler(msg)
    if (msg == "reload") then
        ReloadUI();
    elseif (msg == "togglebutton") then
        Notes_ToggleButton();
    elseif (msg == "run") then
        Notes_RunNoteAsScript();
    else
        NotesFrame_Toggle();
    end
end

function Notes_StartDelay(delay, func, ...)
    if(type(delay)~="number" or type(func)~="function") then
        return false;
    end

    if(waitFrame == nil) then
        waitFrame = CreateFrame("Frame","Notes_WaitFrame", UIParent);
        waitFrame:SetScript("onUpdate",function (self,elapse)
            local count = #waitTable;
            local i = 1;

            while(i<=count) do
                local waitRecord = tremove(waitTable,i);
                local d = tremove(waitRecord,1);
                local f = tremove(waitRecord,1);
                local p = tremove(waitRecord,1);

                if(d>elapse) then
                    tinsert(waitTable,i,{d-elapse,f,p});
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end

    tinsert(waitTable,{delay,func,{...}});

    return true;
end

function Notes_OnEvent(self, event, ...)
    if (event == "ADDON_LOADED") then
        local addonName = ...;
        if (addonName == "Notes") then
            Notes_StartDelay(1, NotesFrame_Init);
        end
    end
    if (event == "CHAT_MSG_ADDON") then
        local prefix, message, type, sender = ...;
        Notes_ReceiveNote(prefix, message, type, sender);
    end
end

function Notes_OnUpdate()
end

local saveHistory = true;

function Notes_UpdateHistory()
    if (saveHistory == false) then
        saveHistory = true;
        return;
    end
    
    local text = TextBodyEditBox:GetText();
    
    if (text == history[1]) then
        return;
    end
    
    if (historyIndex > 1) then
        for i=1, historyIndex - 1 do
            tremove(history, 1);
        end
        
        historyIndex = 1;
    end
    
    tinsert(history, 1, text);
    
    while (#history > 50) do
        tremove(history, 50);
    end
end

function NotesFrame_Undo()
    historyIndex = historyIndex + 1;
    if (historyIndex > #history) then
        historyIndex = #history;
    end
    
    saveHistory = false;
    TextBodyEditBox:SetText(history[historyIndex]);
end

function NotesFrame_Redo()
    historyIndex = historyIndex - 1;
    if (historyIndex < 1) then
        historyIndex = 1;
    end
    
    saveHistory = false;
    TextBodyEditBox:SetText(history[historyIndex]);
end

function NotesFrame_Init()
    NotesData.notes = NotesData.notes or {};
    NotesData.collapsed = NotesData.collapsed or {};
    NotesData.minimappos = NotesData.minimappos or 65;
    
    Notes_MinimapButton_Reposition();
    Notes_CheckButtonVisibility();

    UIDropDownMenu_Initialize(Notes_AddInfoDropDown, Note_AddInfoDropDown_Initialize);
    UIDropDownMenu_SetSelectedValue(Notes_AddInfoDropDown, selectedAddIndex);

    -- save mail button
    local saveMailButton = _G["Notes_SaveMailButton"];

    if (not saveMailButton) then
        saveMailButton = CreateFrame("Button", "Notes_SaveMailButton", OpenMailFrame, "UIPanelButtonTemplate");

        saveMailButton:SetText("Notes+");

        saveMailButton:RegisterForClicks("AnyUp");

        saveMailButton:SetSize(78, 22);
        saveMailButton:ClearAllPoints();
        saveMailButton:SetPoint("RIGHT", OpenMailReplyButton, "LEFT", -4, 0);

        saveMailButton:HookScript("OnClick", Notes_SaveMail);
        saveMailButton:HookScript("OnEnter", Notes_SaveMailButtonShowTooltip);
        saveMailButton:HookScript("OnLeave", Notes_SaveMailButtonHideTooltip);
    end
    
    UIPanelWindows["NotesFrame"] = { area = "left", pushable = 3, whileDead = 1};
    
    Notes_TitlesOnUpdate();
end

function Notes_MinimapButton_DraggingFrame_OnUpdate()

    local xpos,ypos = GetCursorPosition();
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();

    xpos = xmin-xpos/UIParent:GetScale()+70;
    ypos = ypos/UIParent:GetScale()-ymin-70;

    NotesData.minimappos = math.deg(math.atan2(ypos,xpos));
    Notes_MinimapButton_Reposition();
end

function Notes_MinimapButton_Reposition()
    Notes_MinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT",
        52-(80*cos(NotesData.minimappos)), (80*sin(NotesData.minimappos))-52);
end

function Notes_CheckButtonVisibility()
    if (NotesData.minimapbutton) then
        Notes_MinimapButton:Hide();
    else
        Notes_MinimapButton:Show();
    end
end

function Notes_ToggleButton()
    NotesData.minimapbutton = not NotesData.minimapbutton;

    Notes_CheckButtonVisibility();
end

function Notes_MouseOver(button)
    Notes_ShowTooltip(button);
end

function Notes_MouseOut(button)
    GameTooltip:FadeOut();
end

function Notes_ShowTooltip(button)
    GameTooltip_SetDefaultAnchor(GameTooltip, button);
    Notes_CreateTooltip(GameTooltip);
end

function Notes_CreateTooltip(tooltip)
    tooltip:SetText("|cffffffffNotes|r");
    
    GameTooltip:AddDoubleLine("/notes", NOTES_HELP_OPEN_CLOSE);
    GameTooltip:AddDoubleLine("/notes togglebutton", NOTES_HELP_SHOW_HIDE);
    
    tooltip:Show();
end

function Notes_SaveMail()
    local data = {};

    local bodyText, texture, isTakeable, isInvoice = GetInboxText(InboxFrame.openMailID);
    local packageIcon, stationeryIcon, sender, subject, money, _, _, itemCount = GetInboxHeaderInfo(InboxFrame.openMailID);
    
    -- create NoteText
    bodyText = bodyText or ""
    
    if (money > 0) then
        local moneyString = "|cff000000"..GetCoinTextureString(money).."|r";
        bodyText = bodyText.."\n\n"..moneyString
    end
    
    local item, itemID, texture, count, quality, canUse, itemLink;
    for index = 1, itemCount do
        item, itemID, texture, count, quality, canUse = GetInboxItem(InboxFrame.openMailID, index);
        
        if (item == nil) then
            break;
        end
        
        itemLink = GetInboxItemLink(InboxFrame.openMailID, index);
        
        bodyText = bodyText.."\n"..itemLink
    end
    
    -- Create note
    local newNote = CopyTable(NOTE_TEMPLATE);
    newNote.title = subject.." ("..FROM.." "..sender..")";
    newNote.text = bodyText;
    newNote.type = tonumber(NOTE_TYPE[0]);
    newNote.received = 1;
    newNote.category = MAIL_LABEL;
    
    tinsert(NotesData.notes, newNote);
end

function Notes_SaveMailButtonShowTooltip()
    GameTooltip_SetDefaultAnchor(GameTooltip, _G["Notes_SaveMailButton"]);
    GameTooltip:SetOwner(_G["Notes_SaveMailButton"], "ANCHOR_RIGHT");

    GameTooltip:SetText(NOTES_SAVE_MAIL_TOOLTIP);

    GameTooltip:Show();
end

function Notes_SaveMailButtonHideTooltip()
    GameTooltip:FadeOut();
end

function NotesFrame_RemoveTextures(frame)
    for i, child in ipairs({frame:GetRegions()}) do

        if (child and child:IsObjectType("texture")) then
            child:SetTexture(nil);
        end
    end
end

function NotesFrame_Toggle()
    if (NotesFrame:IsVisible()) then
        HideUIPanel(NotesFrame);
    else
        ShowUIPanel(NotesFrame);
    end
end

local function pairsByKeysAsc(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, function(a,b) return a<b end)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

local function compareNotes(note1, note2)
    return note1.title < note2.title;
end

local function sortNotesByCategory()
    local note, header;

    local help = {};
    local actCategory;

    -- sort
    for i=1, #NotesData.notes do
        note = {};

        note.title = NotesData.notes[i].title;
        note.category = NotesData.notes[i].category;
        note.text = NotesData.notes[i].text;
        note.type = NotesData.notes[i].type;
        note.received = NotesData.notes[i].received;
        note.index = i;
        note.isHeader = nil;

        actCategory = NotesData.notes[i].category or "";
        help[actCategory] = help[actCategory] or {};

        tinsert(help[actCategory], note);
    end


    local entries = {};

    for category, notes in pairsByKeysAsc(help) do
        if (category ~= "") then
            header = {};

            header.title = category;
            header.isHeader = 1;

            tinsert(entries, header);
        end

        if (not tContains(NotesData.collapsed, category)) then
            table.sort(notes, compareNotes);
        
            for i=1, #notes do
                tinsert(entries, notes[i]);
            end
        end
    end

    return entries;
end

function Notes_TitlesOnUpdate()
    if ( not NotesFrame:IsShown() ) then
        return;
    end

    local entries = sortNotesByCategory();

    local numEntries = #entries;

    if ( numEntries == 0 ) then
        EmptyNotesFrame:Show();
    else
        EmptyNotesFrame:Hide();
    end

    if ( selectedIndex ) then
        ConfigNotesFrame:Show();
        EditNotesFrame:Show();
    else
        ConfigNotesFrame:Hide();
        EditNotesFrame:Hide();
    end

    -- hide the highlight frame initially, it may be shown when we loop through the quest listing if a quest is selected
    NotesFrameHighlightFrame:Hide();

    -- Update the quest listing
    local buttons = NotesFrameScrollFrame.buttons;
    local numButtons = #buttons;
    local scrollOffset = HybridScrollFrame_GetOffset(NotesFrameScrollFrame);
    local buttonHeight = buttons[1]:GetHeight();
    local displayedHeight = 0;

    local title, category, text, type, received;
    for i=1, numButtons do

        local noteIndex = i + scrollOffset;
        local notesTitle = buttons[i];
        
        notesTitle.expandText:SetText("");

        if ( noteIndex <= numEntries ) then
                
            if (entries[noteIndex].isHeader) then
                notesTitle.isHeader = true;
                notesTitle.normalText:SetPoint("LEFT", notesTitle, "LEFT", 20, 0);

                title = entries[noteIndex].title;
                
                notesTitle.category = title;
                
                notesTitle.expandText:SetText("-");
                
                if (tContains(NotesData.collapsed, title)) then
                    notesTitle.expandText:SetText("+");
                end
                
                notesTitle:Show();
                notesTitle:SetText(GRAY_FONT_COLOR_CODE..title..FONT_COLOR_CODE_CLOSE);
                
                notesTitle.normalText:SetFontObject("GameFontHighlight");
                
                notesTitle.index = nil;

                notesTitle.ready:Hide();
                notesTitle.notready:Hide();
            else
                notesTitle.isHeader = false;
                notesTitle.normalText:SetPoint("LEFT", notesTitle, "LEFT", 35, 0);

                title = entries[noteIndex].title;
                text = entries[noteIndex].text;
                type = entries[noteIndex].type;
                received = entries[noteIndex].received;

                notesTitle:Show();

                if (not received) then
                    notesTitle:SetText(title);
                else
                    notesTitle:SetText(ORANGE_FONT_COLOR_CODE..title..FONT_COLOR_CODE_CLOSE);
                end
                
                notesTitle.normalText:SetFontObject("GameFontNormal");

                notesTitle.index = entries[noteIndex].index;

                notesTitle.ready:Hide();
                notesTitle.notready:Hide();

                if (type == 2) then
                    notesTitle.ready:Show();
                elseif (type == 3) then
                    notesTitle.notready:Show();
                end

                -- this isn't a header, hide the header textures
                notesTitle:SetNormalTexture("");
                notesTitle:SetHighlightTexture("");

                if (entries[noteIndex].index == selectedIndex) then
                    -- reposition highlight frames
                    NotesFrameHighlightFrame:SetParent(notesTitle);
                    NotesFrameHighlightFrame:SetPoint("TOPLEFT", notesTitle, "TOPLEFT", 0, 0);
                    NotesFrameHighlightFrame:SetPoint("BOTTOMRIGHT", notesTitle, "BOTTOMRIGHT", 0, 0);
                    NotesFrameHighlightFrame:Show();
                end
            end
        else
            notesTitle:Hide();
        end

        displayedHeight = displayedHeight + buttonHeight;
    end

    HybridScrollFrame_Update(NotesFrameScrollFrame, numEntries * buttonHeight, displayedHeight);
end

function Notes_OnMouseDown(frame, button)
    if (button == "LeftButton") then
        NotesFrame:StartMoving();
    end
end

function Notes_OnMouseUp(frame, button)
    NotesFrame:StopMovingOrSizing();
end

function Notes_MiniFrame_OnMouseDown(frame, button)
    if (button == "LeftButton") then
        NotesMiniFrame:StartMoving();
    end
end

function Notes_MiniFrame_OnMouseUp(frame, button)
    NotesMiniFrame:StopMovingOrSizing();
end

function Notes_RunNoteAsScript()
    local text = TextBodyEditBox:GetText();
    RunScript(text);
end

function Notes_OnReceiveDrag()
    local infoType, info1, info2 = GetCursorInfo();

    if (infoType == "item") then
        TextBodyEditBox:Insert(info2);
    end

    if (infoType == "spell") then
        local skillType, spellId = GetSpellBookItemInfo(info1, "player");
        local link = GetSpellLink(spellId);
        TextBodyEditBox:Insert(link);
    end

    if (infoType == "merchant") then
        local link = GetMerchantItemLink(info1);
        TextBodyEditBox:Insert(link);
    end

    ClearCursor();
end

function Notes_DetectLink()
    local actCursorPosition = TextBodyEditBox:GetCursorPosition();
    if (actCursorPosition == lastCursorPos) then
        return;
    end
    lastCursorPos = actCursorPosition;

    local text = TextBodyEditBox:GetText();
    local start, ende = Notes_DetectLinkPosition(text, actCursorPosition);

    if (start and ende) then
        local link = strsub(text, start, ende);
        GameTooltip:SetOwner(NotesFrame, "ANCHOR_RIGHT");

        if (string.find(link, "[", 1, true)) then
            GameTooltip:SetHyperlink(link);
        end
    end
end

function Notes_DetectLinkPosition(text, cursorPos)

    local pos = 1;

    local start = 0;
    local ende = 0;

    while (pos and pos < strlen(text)) do
        start = string.find(text, "|c........|", pos, false);

        if (not start) then
            return nil, nil;
        end

        ende = string.find(text, "|r", start, true);

        if (start and start < cursorPos and ende and ende > cursorPos) then
            return start, ende+1;
        end

        pos = ende;
    end

    return nil, nil;
end

function NotesFrame_CreateNote()
    local newNote = CopyTable(NOTE_TEMPLATE);
    tinsert(NotesData.notes, newNote);

    Notes_TitlesOnUpdate();
end

function NotesFrame_CopyNote()
    if (selectedIndex) then
        local copyNote = CopyTable(NotesData.notes[selectedIndex]);
        selectedIndex = selectedIndex + 1;
        tinsert(NotesData.notes, selectedIndex, copyNote);

        Notes_TitlesOnUpdate();
    end
end

function NotesFrame_DeleteNote()
    if (selectedIndex) then
        tremove(NotesData.notes, selectedIndex);
        selectedIndex = nil;

        Notes_TitlesOnUpdate();
    end
end

function NotesFrame_SendNote()
    if (selectedIndex) then
        NotesFrameSendToMenu:Show();
    end
end

function NotesFrameSendToMenu_OnLoad(self)

    UIMenu_Initialize(self);
    UIMenu_AddButton(self, CHAT_MSG_PARTY, nil, function(frame) Notes_SendNoteTo(1) end);
    UIMenu_AddButton(self, CHAT_MSG_RAID, nil, function(frame) Notes_SendNoteTo(2) end);
    UIMenu_AddButton(self, CHAT_MSG_GUILD, nil, function(frame) Notes_SendNoteTo(3) end);
    UIMenu_AddButton(self, CHAT_MSG_BATTLEGROUND, nil, function(frame) Notes_SendNoteTo(4) end);
    UIMenu_AddButton(self, CHAT_MSG_WHISPER_INFORM, nil, function(frame) Notes_SendNoteTo(5) end);
    UIMenu_AutoSize(self);
end

function Notes_SendNoteTo(sendto)
    NotesFrameSendToMenu:Hide();

    if (sendto == 1) then       -- group
        Notes_SendNoteToPlayer("PARTY");
    elseif (sendto == 2) then   -- raid
        Notes_SendNoteToPlayer("RAID");
    elseif (sendto == 3) then   -- guild
        Notes_SendNoteToPlayer("GUILD");
    elseif (sendto == 4) then   -- battleground
        Notes_SendNoteToPlayer("BATTLEGROUND");
    elseif (sendto == 5) then   -- whisper
        local dialog = StaticPopup_Show("NOTES_SEND_NOTE");
        local editbox = _G[dialog:GetName().."EditBox"];
        editbox:SetText("");
    end
end

function Notes_SendNoteToPlayer(channel, name)

    local title = NotesData.notes[selectedIndex].title;
    local text = NotesData.notes[selectedIndex].text;
    local type = NotesData.notes[selectedIndex].type;

    if (strlen(text) > 200) then
        local first = true;

        while (strlen(text) > 200) do
            local part = string.sub(text, 1, 200);
            text = string.sub(text, 201);

            if (first) then
                local message = title..";"..part..";"..type;
                Notes_SendNote("NI_SendNote", message, channel, name);
                first = false;
            else
                local message = title..";"..part..";"..type;
                Notes_SendNote("NI_SendNote+", message, channel, name);
            end
        end

        local message = title..";"..text..";"..type;
        Notes_SendNote("NI_SendNote+", message, channel, name);
    else
        local message = title..";"..text..";"..type;
        Notes_SendNote("NI_SendNote", message, channel, name);
    end
end

function Notes_SendNote(prefix, message, channel, name)
    if (channel ~= "WHISPER") then
        C_ChatInfo.SendAddonMessage(prefix, message, channel);
    else
        C_ChatInfo.SendAddonMessage(prefix, message, channel, name);
    end
end

function Notes_ReceiveNote(prefix, message, channel, sender)

    if (prefix == nil) then
        return;
    end

    local playername, _ = UnitName("player");

    if (sender == playername) then
        return;
    end

    if (prefix == "NI_SendNote") then
        local title, text, type = strsplit(";", message, 3);

        title = title.." ("..sender..")";

        local newNote = CopyTable(NOTE_TEMPLATE);
        newNote.title = title;
        newNote.text = text;
        newNote.type = tonumber(type);
        newNote.received = 1;
        tinsert(NotesData.notes, newNote);
    end

    if (prefix == "NI_SendNote+") then
        local title, text, type = strsplit(";", message, 3);

        title = title.." ("..sender..")";

        local note = Notes_FindNote(title);
        note.title = title;
        note.text = note.text..text;
        note.type = tonumber(type);
        note.received = 1;
    end
end

function Notes_FindNote(title)
    for i=1, #NotesData.notes do
        local foundtitle = NotesData.notes[i].title;

        if (foundtitle == title) then
            return NotesData.notes[i];
        end
    end

    return CopyTable(NOTE_TEMPLATE);
end

function NotesFrameScrollFrame_OnLoad(self)
    HybridScrollFrame_OnLoad(self);
    self.update = Notes_TitlesOnUpdate;
    HybridScrollFrame_CreateButtons(self, "NotesFrameTitleButtonTemplate");
end

function NotesFrameTitleButton_OnLoad(self)
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    self:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    self:RegisterEvent("PARTY_MEMBER_ENABLE");
    self:RegisterEvent("PARTY_MEMBER_DISABLE");
end

function NotesFrameTitleButton_OnClick(self, button)
    selectedIndex = self.index;
    lastCursorPos = nil;
    
    if (self.isHeader) then
        Notes_ToggleCategory(self.category);
        return;
    end

    local title = NotesData.notes[selectedIndex].title or "";
    local text = NotesData.notes[selectedIndex].text or "";
    local type = NotesData.notes[selectedIndex].type;
    local category = NotesData.notes[selectedIndex].category;

    if (button == "LeftButton") then

        if (not type) then
            type = 1;
            NotesData.notes[selectedIndex].type = 1;
        end

        TextBodyEditBox:SetText(text);
        UIDropDownMenu_Initialize(Notes_TypeDropDown, Note_TypeDropDown_Initialize);
        UIDropDownMenu_SetSelectedValue(Notes_TypeDropDown, type);
    elseif (button == "RightButton" and IsControlKeyDown()) then
        -- edit note title
        local dialog = StaticPopup_Show("NOTES_EDIT_CATEGORY_POPUP");
        local editbox = _G[dialog:GetName().."EditBox"];
        editbox:SetText(category or "");
    elseif (button == "RightButton") then
        -- edit note title
        local dialog = StaticPopup_Show("NOTES_EDIT_TITLE_POPUP");
        local editbox = _G[dialog:GetName().."EditBox"];
        editbox:SetText(title or "");
    end
    
    Notes_TitlesOnUpdate();
end

function Notes_ToggleCategory(category)
    if (tContains(NotesData.collapsed, category)) then
        Notes_ExpandCategory(category);
    else
        Notes_CollapseCategory(category);
    end
    
    Notes_TitlesOnUpdate();
end

function Notes_ExpandCategory(category)
    for index, foundCategory in ipairs(NotesData.collapsed) do
        if (foundCategory == category) then
            tremove(NotesData.collapsed, index);
        end
    end
end

function Notes_CollapseCategory(category)
    tinsert(NotesData.collapsed, category);
end

function Notes_OnTextChanged()
    local text = TextBodyEditBox:GetText();

    local num = TextBodyEditBox:GetNumLetters();
    local max = TextBodyEditBox:GetMaxLetters();

    EditNotesFrame_max:SetText(string.format("(%d/%d)", num, max));

    Notes_ChangeText(text);
    
    TextBodyEditBox:HighlightText(TextBodyEditBox:GetCursorPosition(), TextBodyEditBox:GetCursorPosition());
    
    Notes_UpdateHistory();
    
    GameTooltip:Hide();
end

function Notes_ChangeTitle(newTitle)
    NotesData.notes[selectedIndex].title = newTitle;
    NotesData.notes[selectedIndex].received = nil;
    Notes_TitlesOnUpdate();
end

function Notes_ChangeCategory(newCategory)
    NotesData.notes[selectedIndex].category = newCategory;
    NotesData.notes[selectedIndex].received = nil;
    
    Notes_ExpandCategory(newCategory);
    Notes_TitlesOnUpdate();
end

function Notes_ChangeText(newText)
    NotesData.notes[selectedIndex].text = newText;
    NotesData.notes[selectedIndex].received = nil;
    Notes_TitlesOnUpdate();
end

function NotesFrameTitleButton_OnEnter(self)
end

function NotesFrameTitleButton_OnLeave(self)
    if ( self:GetID() ~= selectedIndex ) then
    end
    GameTooltip:FadeOut();
end

--
-- add quest
--

function NotesFrame_AddInfo()
    if (selectedAddIndex >= 1 and selectedAddIndex <= 4) then
        NotesFrame_AddQuestInfo();
    end

    if (selectedAddIndex == 5) then
        NotesFrame_AddPetInfo();
    end

    if (selectedAddIndex == 6) then
        NotesFrame_AddAchievementInfo();
    end
end

function NotesFrame_AddQuestInfo()
    local index = C_QuestLog.GetLogIndexForQuestID(C_QuestLog.GetSelectedQuest());

    if (not index) then
        return;
    end

    local questInfo = C_QuestLog.GetInfo(index);

    if (not questInfo.title or questInfo.isHeader) then
        return;
    end

    local questDescription, questObjectives = GetQuestLogQuestText();

    if (selectedAddIndex == 1) then
        local questLink = GetQuestLink(questInfo.questID);
        TextBodyEditBox:Insert(questLink.."\n");
    elseif (selectedAddIndex == 2) then
        TextBodyEditBox:Insert(questInfo.title.."\n");
    elseif (selectedAddIndex == 3) then
        TextBodyEditBox:Insert(questObjectives.."\n");
    elseif (selectedAddIndex == 4) then

        -- divided into blocks based on the type of reward. Added spells, currencies and XP

        --spells rewards. Includes buffs and others as professions techniques or raid skips (i.e. Walking Dream on Emerald Nightmare)
        local numspells = GetNumQuestLogRewardSpells(questInfo.questID);
        if (numspells and numspells > 0) then

            for i = 1, numspells do
                local spellLink = GetQuestLogSpellLink(i);
                TextBodyEditBox:Insert(spellLink);
            end

            TextBodyEditBox:Insert("\n");
        end

        --quest rewards. Fixed rewards
        
        local numrewards = GetNumQuestLogRewards();
        if (numrewards and numrewards > 0) then

            for i = 1, numrewards do
                local itemLink = GetQuestLogItemLink("reward", i);
                -- get number of items in case is greater than 1 to show how many on note on format [item]x2
                local itemName, itemTexture, numItems, quality, isUsable, itemID, itemLevel = GetQuestLogRewardInfo(i)
                if (numItems > 1) then
                    TextBodyEditBox:Insert(itemLink.."x"..numItems);
                else
                    TextBodyEditBox:Insert(itemLink);
                end
            end

            TextBodyEditBox:Insert("\n");
        end

        --choices rewards
        
        local numchoices = GetNumQuestLogChoices(questInfo.questID);
        if (numchoices and numchoices > 0) then

            for i = 1, numchoices do
                local itemLink = GetQuestLogItemLink("choice", i);
                -- get number of items in case is greater than 1 to show how many on note on format [item]x2
                local itemName, itemTexture, numItems, quality, isUsable, itemID = GetQuestLogChoiceInfo(i)
                if (numItems > 1) then
                    TextBodyEditBox:Insert(itemLink.."x"..numItems);
                else
                    TextBodyEditBox:Insert(itemLink);
                end
            end

            TextBodyEditBox:Insert("\n");
        end

        --currencies rewards
        
        local numcurrencies = GetNumQuestLogRewardCurrencies();
        if (numcurrencies and numcurrencies > 0) then

            for i = 1, numcurrencies do
                local name, texture, numItems, currencyId, quality = GetQuestLogRewardCurrencyInfo(i,questInfo.questID);
                currencyLink = C_CurrencyInfo.GetCurrencyLink(currencyId, numItems);
                TextBodyEditBox:Insert(currencyLink.."x"..numItems);
            end

            TextBodyEditBox:Insert("\n");
        end

        --gold reward

        local money = GetQuestLogRewardMoney();
        if (money and money > 0) then

            TextBodyEditBox:Insert(GetCoinText(money,", ").."\n");
        end

        -- XP reward

        local XP_reward = GetQuestLogRewardXP();
        if (XP_reward and XP_reward > 0) then

            TextBodyEditBox:Insert(XP_reward.." XP\n");
        end

    end
    
    Notes_UpdateHistory();
end

function NotesFrame_AddPetInfo()
    if (not PetJournalPetCard) then
        return;
    end

    local selected = PetJournalPetCard.petIndex;

    if (not selected) then
        return;
    end

    local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(selected);
    local speciesName, speciesIcon, petType, companionID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoBySpeciesID(speciesID)

    TextBodyEditBox:Insert(HIGHLIGHT_FONT_COLOR_CODE..speciesName..FONT_COLOR_CODE_CLOSE.."\n    - "..tooltipSource.."\n    - "..tooltipDescription.."\n\n");
    
    Notes_UpdateHistory();
end

function NotesFrame_AddAchievementInfo()
    local achievements = AchievementFrameAchievements;
    
    if (not achievements) then
        return;
    end
    
    local id = achievements.selection;
    
    if (not id) then
        return;
    end
    
    local link = GetAchievementLink(id)
    local id, name, points, completed, month, day, year, description, flags, image, rewardText, isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(id);
    
    TextBodyEditBox:Insert(HIGHLIGHT_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE.."\n\n");
    
    if (not completed) then
        TextBodyEditBox:Insert(RED_FONT_COLOR_CODE..SUMMARY_ACHIEVEMENT_INCOMPLETE..FONT_COLOR_CODE_CLOSE.."\n\n");
    end
    
    TextBodyEditBox:Insert(link.."\n\n");
    
    if (completed) then
        if (wasEarnedByMe) then
            TextBodyEditBox:Insert(format(ACHIEVEMENT_COMPLETED_BY, UnitName("player")).."\n\n");
        else
            TextBodyEditBox:Insert(format(ACHIEVEMENT_COMPLETED_BY, earnedBy).."\n\n");
        end
    end
    
    TextBodyEditBox:Insert(description.."\n\n");
    
    if (strlen(rewardText) > 0) then
        TextBodyEditBox:Insert(rewardText.."\n\n");
    end
    
    if (completed) then
        TextBodyEditBox:Insert(HIGHLIGHT_FONT_COLOR_CODE.." - "..NOTES_DATE..": "..FONT_COLOR_CODE_CLOSE..string.format(SHORTDATE, day, month, year).."\n");
    end
    
    TextBodyEditBox:Insert(HIGHLIGHT_FONT_COLOR_CODE.." - "..NOTES_POINTS..": "..FONT_COLOR_CODE_CLOSE..points.."\n");
    
end

--
-- Add info dropdown
--

function Note_AddInfoDropDown_Initialize(self)
    for i = 1, #NOTE_QUEST_INFO do
        local info = UIDropDownMenu_CreateInfo();
        info.text = NOTE_QUEST_INFO[i];
        info.value = i;
        info.func = function()
            Note_ToggleAddQuestInfo(i);
        end
        UIDropDownMenu_AddButton(info);
    end
end

function Note_ToggleAddQuestInfo(index)
    selectedAddIndex = index;
    UIDropDownMenu_SetSelectedValue(Notes_AddInfoDropDown, index);
end

--
-- Notes settings
--

function Note_TypeDropDown_Initialize(self)
    for i = 1, #NOTE_TYPE do
        local info = UIDropDownMenu_CreateInfo();
        info.text = NOTE_TYPE[i];
        info.value = i;
        info.func = function()
            Note_ToggleNoteType(i);
        end
        UIDropDownMenu_AddButton(info);
    end
end

function Note_ToggleNoteType(type)
    NotesData.notes[selectedIndex].type = type;
    UIDropDownMenu_SetSelectedValue(Notes_TypeDropDown, type);

    Notes_TitlesOnUpdate();
end

function NotesMiniFrame_Init() 
    NotesMiniFrame_ToggleButton:SetAlpha(0.0);
    NotesMiniFrame_PrevButton:SetAlpha(0.0);
    NotesMiniFrame_NextButton:SetAlpha(0.0);
    
    NotesFrame_RemoveTextures(MiniTextScrollFrame);
    NotesFrame_RemoveTextures(MiniTextScrollFrameScrollBar);
    NotesFrame_RemoveTextures(MiniTextScrollFrameScrollBar.ScrollUpButton);
    NotesFrame_RemoveTextures(MiniTextScrollFrameScrollBar.ScrollDownButton);
end

function NotesMiniFrame_Toggle() 
    if (NotesMiniFrame:IsVisible()) then
        HideUIPanel(NotesMiniFrame);
    else
        ShowUIPanel(NotesMiniFrame);
        NotesMiniFrame_LoadNote();
    end
end

function NotesMiniFrame_Prev()
    if (not NotesData.selectedMiniNote) then
        NotesData.selectedMiniNote = selectedIndex or 1;
    end

    if (NotesData.selectedMiniNote > 1) then
        NotesData.selectedMiniNote = NotesData.selectedMiniNote - 1;
    end
    
    NotesMiniFrame_LoadNote();
end

function NotesMiniFrame_Next()
    if (not NotesData.selectedMiniNote) then
        NotesData.selectedMiniNote = selectedIndex or 1;
    end

    if (NotesData.selectedMiniNote < #NotesData.notes) then
        NotesData.selectedMiniNote = NotesData.selectedMiniNote + 1;
    end
    
    NotesMiniFrame_LoadNote();
end

function NotesMiniFrame_LoadNote()
    if (not NotesData.selectedMiniNote) then
        NotesData.selectedMiniNote = 1;
    end
    
    if (NotesData.selectedMiniNote and NotesData.notes[NotesData.selectedMiniNote]) then
        local title = NotesData.notes[NotesData.selectedMiniNote].title;
        local text = NotesData.notes[NotesData.selectedMiniNote].text;
        local type = NotesData.notes[NotesData.selectedMiniNote].type;
        
        MiniNotesFrameTitleText:SetText(title);
        MiniTextBodyEditBox:SetText(text);
    else
        MiniNotesFrameTitleText:SetText("");
        MiniTextBodyEditBox:SetText(NOTES_NO_NOTES_TEXT);
    end
end
