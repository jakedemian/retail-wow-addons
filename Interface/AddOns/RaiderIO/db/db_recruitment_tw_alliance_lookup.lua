--
-- Copyright (c) 2022 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",faction=1,date="2022-03-13T18:43:25Z",numCharacters=21924,lookup1={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 6
F = function() provider.lookup1[1] = "\4\4;\4\4\8" end F()

F = nil
RaiderIO.AddProvider(provider)
