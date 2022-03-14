-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.DROPPED_PET_IDS = {
	[7383] = 8491;
	[7387] = 8492;
	[7391] = 8494;
	[7543] = 10822;
	[7544] = 8499;
	[7545] = 8498;
	[7546] = 118675;
	[7547] = 34535;
	[9662] = 11474;
	[10259] = 12264;
	[10598] = 12529;
	[15429] = 20769;
	[16445] = 22780;
	[21076] = 29960;
	[24480] = 33993;
	[26119] = 35504;
	[28513] = 38658;
	[32589] = 39896;
	[32590] = 39899;
	[32591] = 39898;
	[32592] = 44721;
	[35387] = 48118;
	[35394] = 48126;
	[35395] = 48114;
	[35396] = 48112;
	[35397] = 48122;
	[35398] = 48124;
	[35400] = 48116;
	[48641] = 64403;
	[48641] = 90897;
	[48641] = 90898;
	[48982] = 64494;
	[50586] = 66076;
	[50722] = 67282;
	[59358] = 80008;
	[61086] = 89587;
	[61087] = 142223;
	[63365] = 85220;
	[64633] = 86563;
	[64634] = 86564;
	[65313] = 85513;
	[67332] = 91040;
	[68654] = 93029;
	[68656] = 93030;
	[68657] = 93032;
	[68658] = 93041;
	[68659] = 93040;
	[68660] = 93039;
	[68661] = 93036;
	[68662] = 93038;
	[68663] = 93037;
	[68664] = 93034;
	[68665] = 93033;
	[68666] = 93035;
	[69748] = 94125;
	[69778] = 94124;
	[69796] = 94126;
	[69820] = 94152;
	[70083] = 94574;
	[70098] = 94595;
	[70144] = 94835;
	[70154] = 94573;
	[70451] = 95422;
	[70452] = 95423;
	[70453] = 95424;
	[71014] = 97548;
	[71015] = 97549;
	[71016] = 97550;
	[71017] = 97552;
	[71018] = 97553;
	[71019] = 97554;
	[71020] = 97555;
	[71021] = 97556;
	[71022] = 97557;
	[71033] = 97551;
	[71199] = 97959;
	[71200] = 97960;
	[71201] = 97961;
	[72160] = 101570;
	[73011] = 103670;
	[73350] = 104162;
	[73351] = 104163;
	[73352] = 104158;
	[73354] = 104165;
	[73355] = 104164;
	[73356] = 104159;
	[73357] = 104166;
	[73359] = 104169;
	[73364] = 104161;
	[73366] = 104168;
	[73367] = 104167;
	[73532] = 104160;
	[73533] = 104156;
	[73534] = 104157;
	[73668] = 104202;
	[73730] = 104291;
	[73738] = 104307;
	[81431] = 112699;
	[83562] = 113554;
	[85231] = 116402;
	[85284] = 115483;
	[85387] = 117564;
	[85527] = 116064;
	[86081] = 116815;
	[86532] = 117528;
	[86715] = 118101;
	[86716] = 118106;
	[86717] = 118104;
	[86718] = 118105;
	[86719] = 118107;
	[86879] = 118207;
	[87257] = 120309;
	[87669] = 118574;
	[88103] = 118709;
	[88490] = 119170;
	[88692] = 119431;
	[88814] = 0;
	[90200] = 122105;
	[90201] = 122104;
	[90202] = 122106;
	[90203] = 122107;
	[90204] = 122108;
	[90205] = 122109;
	[90206] = 122110;
	[90207] = 122111;
	[90208] = 122112;
	[90212] = 122113;
	[90213] = 122114;
	[90214] = 122115;
	[93143] = 127748;
	[93352] = 127754;
	[94623] = 127749;
	[94867] = 127856;
	[95572] = 128309;
	[97179] = 136901;
	[97205] = 129208;
	[98077] = 129175;
	[98116] = 129188;
	[98236] = 129216;
	[98237] = 129217;
	[98238] = 129218;
	[98463] = 129362;
	[99389] = 130167;
	[99394] = 130168;
	[99403] = 130166;
	[99505] = 136911;
	[108568] = 130154;
	[111984] = 140261;
	[112015] = 136903;
	[113136] = 140934;
	[115135] = 142083;
	[115136] = 142084;
	[115137] = 142085;
	[115138] = 142086;
	[115139] = 142087;
	[115140] = 142088;
	[115141] = 142089;
	[115142] = 142090;
	[115143] = 142091;
	[115144] = 142092;
	[115145] = 142093;
	[115146] = 142094;
	[115147] = 142095;
	[115148] = 142096;
	[115149] = 142097;
	[115150] = 142098;
	[115152] = 142099;
	[115784] = 0;
	[115785] = 0;
	[115786] = 0;
	[115787] = 0;
	[116080] = 142448;
	[117180] = 143756;
	[117182] = 143754;
	[117184] = 143755;
	[117340] = 151645;
	[120397] = 146953;
	[121715] = 147841;
	[124389] = 151569;
	[124594] = 151633;
	[124944] = 151828;
	[125494] = 0;
	[127850] = 152966;
	[127852] = 152967;
	[127853] = 152968;
	[127857] = 152969;
	[127858] = 152970;
	[127859] = 152972;
	[127862] = 152973;
	[127863] = 152974;
	[127947] = 152975;
	[127948] = 152976;
	[127950] = 152977;
	[127951] = 152978;
	[127952] = 152979;
	[127953] = 152980;
	[127954] = 152981;
	[128157] = 153054;
	[128158] = 153055;
	[128159] = 153056;
	[128388] = 153252;
	[128396] = 153195;
	[133064] = 156851;
	[134406] = 158077;
	[138964] = 160702;
	[139049] = 160704;
	[143189] = 163497;
	[143499] = 163648;
	[143503] = 163650;
	[143507] = 163652;
	[143515] = 163677;
	[143533] = 163684;
	[143563] = 163689;
	[143564] = 163690;
	[143627] = 163711;
	[143628] = 163712;
	[143794] = 163797;
	[143795] = 163798;
	[143796] = 163799;
	[143797] = 163800;
	[143798] = 163801;
	[143799] = 163802;
	[143801] = 163803;
	[143802] = 163804;
	[143803] = 163805;
	[143804] = 163806;
	[143805] = 163807;
	[143806] = 163808;
	[143807] = 163809;
	[143808] = 163810;
	[143809] = 163811;
	[143810] = 163812;
	[143811] = 163813;
	[143812] = 163814;
	[143813] = 163815;
	[143814] = 163816;
	[143815] = 163817;
	[143816] = 163818;
	[143817] = 163819;
	[143818] = 163820;
	[143819] = 163821;
	[143820] = 163822;
	[143821] = 163823;
	[143822] = 163824;
	[147221] = 165722;
	[147585] = 165848;
	[147586] = 165846;
	[147587] = 165847;
	[148520] = 166345;
	[148781] = 166449;
	[148784] = 166448;
	[148825] = 166451;
	[148841] = 166452;
	[148843] = 166453;
	[148844] = 166454;
	[148846] = 166455;
	[148976] = 166486;
	[148981] = 166488;
	[148982] = 166489;
	[148984] = 166492;
	[148988] = 166493;
	[148989] = 166494;
	[148990] = 166495;
	[148991] = 166498;
	[148995] = 166499;
	[149348] = 166715;
	[149361] = 166723;
	[149363] = 166714;
	[149372] = 166716;
	[149375] = 166718;
	[149376] = 166719;
	[150354] = 167047;
	[150356] = 167048;
	[150357] = 167049;
	[150360] = 167050;
	[150365] = 167051;
	[150372] = 167052;
	[150374] = 167058;
	[150375] = 167053;
	[150377] = 167054;
	[150380] = 167055;
	[150381] = 167056;
	[151631] = 167804;
	[151632] = 167810;
	[151651] = 167809;
	[151673] = 167806;
	[151696] = 167807;
	[151697] = 167808;
	[151700] = 167805;
	[154165] = 169205;
	[154693] = 169322;
	[154819] = 169348;
	[154820] = 169371;
	[154821] = 169372;
	[154823] = 169350;
	[154828] = 169355;
	[154829] = 169356;
	[154831] = 169358;
	[154832] = 169359;
	[154833] = 169360;
	[154834] = 169361;
	[154835] = 169362;
	[154836] = 169363;
	[154839] = 169366;
	[154840] = 169367;
	[154841] = 169368;
	[154842] = 169369;
	[154843] = 169370;
	[154845] = 169373;
	[154846] = 169374;
	[154847] = 169375;
	[154848] = 169376;
	[154850] = 169378;
	[154851] = 169379;
	[154853] = 169381;
	[154854] = 169382;
	[154857] = 169385;
	[154893] = 169392;
	[154894] = 169393;
	[155579] = 169879;
	[155600] = 169886;
	[155829] = 170072;
	[158681] = 172491;
	[158683] = 172492;
	[158685] = 172493;
	[159783] = 0;
	[161919] = 174446;
	[161921] = 174447;
	[161923] = 174448;
	[161924] = 174449;
	[161946] = 174452;
	[161951] = 174456;
	[161954] = 174473;
	[161959] = 174457;
	[161961] = 174458;
	[161962] = 174459;
	[161963] = 174460;
	[161964] = 174461;
	[161966] = 174462;
	[161992] = 174474;
	[161997] = 174475;
	[162004] = 174476;
	[162007] = 174481;
	[162012] = 174478;
	[162013] = 174479;
	[171117] = 180584;
	[171118] = 180585;
	[171119] = 180586;
	[171120] = 180587;
	[171121] = 180588;
	[171122] = 180589;
	[171124] = 180591;
	[171125] = 180592;
	[171150] = 180602;
	[171230] = 180630;
	[171231] = 180631;
	[171234] = 180640;
	[171238] = 180642;
	[171239] = 180643;
	[171240] = 180629;
	[171242] = 180635;
	[171246] = 180644;
	[171247] = 180645;
	[171565] = 180812;
	[171693] = 180856;
	[171697] = 180859;
	[171710] = 180866;
	[171714] = 180869;
	[171719] = 180872;
	[171954] = 181164;
	[171984] = 181170;
	[171985] = 181171;
	[171986] = 181172;
	[171987] = 181173;
	[172132] = 181262;
	[172134] = 181263;
	[172136] = 181265;
	[172137] = 181266;
	[172139] = 181267;
	[172148] = 181269;
	[172149] = 181270;
	[172150] = 181271;
	[172155] = 181283;
	[173502] = 180601;
	[173508] = 182613;
	[173531] = 182612;
	[173533] = 186544;
	[173534] = 182606;
	[173536] = 183855;
	[173589] = 182671;
	[173591] = 182673;
	[173842] = 183107;
	[173847] = 183114;
	[173849] = 183115;
	[173850] = 183116;
	[173851] = 183117;
	[173988] = 183191;
	[173989] = 183193;
	[173990] = 183192;
	[173991] = 183194;
	[173992] = 183195;
	[173993] = 183196;
	[173994] = 183395;
	[174081] = 183407;
	[174082] = 183408;
	[174083] = 183409;
	[174084] = 183410;
	[174089] = 183623;
	[174125] = 183515;
	[174677] = 0;
	[175560] = 184397;
	[175562] = 184401;
	[175563] = 184400;
	[175564] = 184399;
	[175715] = 184507;
	[176662] = 184867;
	[179008] = 186188;
	[179025] = 186191;
	[179132] = 186546;
	[179166] = 186534;
	[179169] = 186540;
	[179171] = 186557;
	[179180] = 186547;
	[179181] = 186449;
	[179220] = 186559;
	[179222] = 186558;
	[179228] = 186564;
	[179230] = 186548;
	[179232] = 186554;
	[179233] = 186555;
	[179239] = 186549;
	[179240] = 186550;
	[179242] = 186552;
	[179251] = 186542;
	[179252] = 186541;
	[179255] = 186538;
	[181337] = 187735;
	[182140] = 0;
	[185475] = 0;
}