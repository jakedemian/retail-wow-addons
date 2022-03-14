local MDT = MDT
local L = MDT.L
local dungeonIndex = 8
MDT.dungeonList[dungeonIndex] = L["Neltharion's Lair"]
local nerfMultiplier = 1
local pi = math.pi

MDT.dungeonMaps[dungeonIndex] = {
    [0] = "NeltharionsLair",
    [1] = "NeltharionsLair",
}
MDT.dungeonSubLevels[dungeonIndex] = {
   [1] = L["Neltharion's Lair Sublevel"],
}

MDT.dungeonTotalCount[dungeonIndex] = {normal=220,teeming=264,teemingEnabled=true}

MDT.dungeonEnemies[dungeonIndex] = {
    [1] = {
       ["clones"] = {
          [1] = {
             ["y"] = -261.84308854674;
             ["x"] = 717.09134241334;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -263.12628555504;
             ["x"] = 710.27318313106;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -259.53370560421;
             ["x"] = 695.72766909221;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -242.17813735154;
             ["x"] = 688.45486759323;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [16] = {
             ["y"] = -224.70315727401;
             ["x"] = 643.04552187209;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [17] = {
             ["y"] = -216.06678301811;
             ["x"] = 642.59098866413;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -239.90543835985;
             ["x"] = 680.2730966036;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [18] = {
             ["y"] = -235.57927008685;
             ["x"] = 628.93235170054;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -238.17005808326;
             ["x"] = 708.00044261849;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [10] = {
             ["y"] = -238.05076527685;
             ["x"] = 650.27362509952;
             ["g"] = 3;
             ["sublevel"] = 1;
          };
          [20] = {
             ["y"] = -212.90501621673;
             ["x"] = 631.63744692257;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [21] = {
             ["y"] = -218.35951720516;
             ["x"] = 627.09197091129;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [11] = {
             ["y"] = -244.15578861909;
             ["x"] = 646.63739532187;
             ["g"] = 3;
             ["sublevel"] = 1;
          };
          [22] = {
             ["y"] = -229.24742404506;
             ["x"] = 640.65302038514;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -266.07396660688;
             ["x"] = 702.54592379259;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [6] = {
             ["y"] = -239.45084784337;
             ["x"] = 702.54580811566;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [12] = {
             ["y"] = -236.42850977365;
             ["x"] = 644.81915010078;
             ["g"] = 3;
             ["sublevel"] = 1;
          };
          [13] = {
             ["y"] = -244.3960464938;
             ["x"] = 639.364618273;
             ["g"] = 3;
             ["sublevel"] = 1;
          };
          [7] = {
             ["y"] = -244.07914958816;
             ["x"] = 695.72766909221;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [14] = {
             ["y"] = -242.57787949765;
             ["x"] = 633.00097526557;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [19] = {
             ["y"] = -228.7610755769;
             ["x"] = 625.75053019682;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
          [15] = {
             ["y"] = -231.06676126749;
             ["x"] = 635.31822435709;
             ["g"] = 33;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 96247;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 0.6;
       ["name"] = "Vileshard Crawler";
       ["displayId"] = 34068;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 1;
       ["health"] = 5129757;
    };
    [2] = {
       ["clones"] = {
          [1] = {
             ["y"] = -251.41509295382;
             ["x"] = 705.72782541555;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -255.72748015891;
             ["x"] = 701.63511264472;
             ["teeming"] = true;
             ["g"] = 1;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 98406;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Embershard Scorpion";
       ["displayId"] = 65795;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [4] = {
       ["clones"] = {
          [1] = {
             ["y"] = -235.13010545316;
             ["x"] = 662.09150365745;
             ["g"] = 2;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -237.8574144683;
             ["x"] = 657.09147614364;
             ["g"] = 2;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -199.31768429844;
             ["x"] = 302.64755243752;
             ["g"] = 26;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -177.63103417372;
             ["x"] = 348.58303783833;
             ["g"] = 23;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91001;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Tarspitter Lurker";
       ["displayId"] = 37550;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [8] = {
       ["clones"] = {
          [1] = {
             ["y"] = -490.22693494842;
             ["x"] = 484.12022857153;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -429.15818419859;
             ["x"] = 427.01118589475;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 92610;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Understone Drummer";
       ["displayId"] = 64336;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 8891579;
    };
    [16] = {
       ["clones"] = {
          [13] = {
             ["y"] = -59.772263981088;
             ["x"] = 354.32645544818;
             ["g"] = 22;
             ["sublevel"] = 1;
          };
          [7] = {
             ["y"] = -72.04496728714;
             ["x"] = 365.2420029946;
             ["g"] = 20;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -85.86036694425;
             ["x"] = 394.32498947052;
             ["g"] = 32;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -72.045006494332;
             ["x"] = 396.70949182901;
             ["g"] = 32;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -67.499529797204;
             ["x"] = 382.0601763269;
             ["g"] = 19;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -75.681371499663;
             ["x"] = 357.06013230253;
             ["g"] = 21;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -68.86317698971;
             ["x"] = 358.4237868101;
             ["g"] = 21;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -73.408660956443;
             ["x"] = 367.96927329135;
             ["g"] = 20;
             ["sublevel"] = 1;
          };
          [10] = {
             ["y"] = -76.135883988238;
             ["x"] = 352.51473431915;
             ["g"] = 21;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -73.408660956443;
             ["x"] = 379.33290603015;
             ["g"] = 19;
             ["sublevel"] = 1;
          };
          [6] = {
             ["y"] = -67.045017259372;
             ["x"] = 367.51468272562;
             ["g"] = 20;
             ["sublevel"] = 1;
          };
          [12] = {
             ["y"] = -52.954069471136;
             ["x"] = 360.23554695309;
             ["g"] = 22;
             ["sublevel"] = 1;
          };
          [11] = {
             ["y"] = -57.044954965949;
             ["x"] = 365.69008695547;
             ["g"] = 22;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 103459;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Rockback Snapper";
       ["displayId"] = 66336;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 0;
       ["health"] = 2963859;
    };
    [17] = {
       ["clones"] = {
          [1] = {
             ["y"] = -167.63108084475;
             ["x"] = 346.47770129056;
             ["g"] = 23;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -172.41169610153;
             ["x"] = 325.78314849181;
             ["g"] = 24;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -177.63476347591;
             ["x"] = 333.71374331304;
             ["teeming"] = true;
             ["g"] = 24;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -187.4995207956;
             ["x"] = 306.73843793233;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 102404;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Stoneclaw Grubmaster";
       ["displayId"] = 64667;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [9] = {
       ["clones"] = {
          [13] = {
             ["y"] = -279.08664343165;
             ["x"] = 126.81947689285;
             ["g"] = 29;
             ["sublevel"] = 1;
          };
          [7] = {
             ["y"] = -291.18353656776;
             ["x"] = 354.30245556786;
             ["g"] = 15;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -442.31291693633;
             ["x"] = 466.03916099185;
             ["patrol"] = {
                [1] = {
                   ["y"] = -442.31291693633;
                   ["x"] = 466.03916099185;
                };
                [2] = {
                   ["y"] = -437.04517233223;
                   ["x"] = 469.14433780031;
                };
                [4] = {
                   ["y"] = -449.93748223296;
                   ["x"] = 460.76089047659;
                };
                [3] = {
                   ["y"] = -442.31291693633;
                   ["x"] = 466.03916099185;
                };
             };
             ["sublevel"] = 1;
             ["patrolFacing"] = 2.5525440310417;
             ["patrolFacing2"] = 5.7923114550562;
          };
          [2] = {
             ["y"] = -463.2916094887;
             ["x"] = 482.11939438997;
             ["g"] = 6;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -456.13602685634;
             ["x"] = 423.08504471294;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -317.81929454721;
             ["x"] = 363.11518814494;
             ["g"] = 16;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -215.96706608781;
             ["x"] = 406.56199629958;
             ["g"] = 17;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -383.46283847897;
             ["x"] = 416.56300162943;
             ["g"] = 10;
             ["sublevel"] = 1;
          };
          [10] = {
             ["y"] = -269.69920918865;
             ["x"] = 226.36472518561;
             ["g"] = 27;
             ["sublevel"] = 1;
          };
          [14] = {
             ["y"] = -298.58259078741;
             ["x"] = 361.19229743848;
             ["teeming"] = true;
             ["g"] = 15;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -471.59064526168;
             ["x"] = 436.43343925247;
             ["patrol"] = {
                [1] = {
                   ["y"] = -471.59064526168;
                   ["x"] = 436.43343925247;
                };
                [2] = {
                   ["y"] = -466.13608575233;
                   ["x"] = 442.34260878527;
                };
                [4] = {
                   ["y"] = -476.59063376154;
                   ["x"] = 429.61524474251;
                };
                [3] = {
                   ["y"] = -471.59064526168;
                   ["x"] = 436.43343925247;
                };
             };
             ["sublevel"] = 1;
             ["patrolFacing"] = 2.0616701789183;
             ["patrolFacing2"] = 5.5959619142068;
          };
          [6] = {
             ["y"] = -360.07543088457;
             ["x"] = 428.99096818218;
             ["g"] = 11;
             ["sublevel"] = 1;
          };
          [12] = {
             ["y"] = -276.01036364328;
             ["x"] = 131.47982173261;
             ["g"] = 29;
             ["sublevel"] = 1;
          };
          [11] = {
             ["y"] = -274.08665009315;
             ["x"] = 190.91025507391;
             ["g"] = 28;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 90997;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Mightstone Breaker";
       ["displayId"] = 64679;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [18] = {
       ["clones"] = {
          [7] = {
             ["y"] = -202.43206636219;
             ["x"] = 297.27832265848;
             ["g"] = 26;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -179.77753412275;
             ["x"] = 304.58895084208;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -181.97752184628;
             ["x"] = 300.91469566472;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -191.52298635742;
             ["x"] = 311.82381468344;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -196.06844286174;
             ["x"] = 297.73287416101;
             ["g"] = 26;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -196.52295535031;
             ["x"] = 307.27833867215;
             ["g"] = 26;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -180.15935485013;
             ["x"] = 310.00560867334;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -186.52297835059;
             ["x"] = 301.36924716724;
             ["g"] = 25;
             ["sublevel"] = 1;
          };
          [6] = {
             ["y"] = -204.70476535389;
             ["x"] = 303.64196566591;
             ["g"] = 26;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 102430;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 0.6;
       ["name"] = "Tarspitter Slug";
       ["displayId"] = 66603;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 1;
       ["health"] = 2279892;
    };
    [5] = {
       ["clones"] = {
          [1] = {
             ["y"] = -234.31126503658;
             ["x"] = 601.4470220737;
             ["g"] = 4;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -250.22037255515;
             ["x"] = 612.35614109241;
             ["g"] = 4;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -252.94768157029;
             ["x"] = 602.81067658127;
             ["g"] = 4;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 105636;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Understone Drudge";
       ["displayId"] = 64776;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [10] = {
       ["clones"] = {
          [7] = {
             ["y"] = -293.0017035639;
             ["x"] = 361.12065007781;
             ["g"] = 15;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -471.4733999853;
             ["x"] = 477.11936687616;
             ["g"] = 6;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -512.65511748269;
             ["x"] = 473.77091833008;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -389.92187539948;
             ["x"] = 408.8922157213;
             ["g"] = 10;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -301.18355258142;
             ["x"] = 354.75696805643;
             ["g"] = 15;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -221.8761582331;
             ["x"] = 401.10753373398;
             ["g"] = 17;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -368.25724177483;
             ["x"] = 429.44555874791;
             ["g"] = 11;
             ["sublevel"] = 1;
          };
          [10] = {
             ["y"] = -378.5110802941;
             ["x"] = 422.88744304888;
             ["teeming"] = true;
             ["g"] = 10;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -391.58045682626;
             ["x"] = 422.23643578427;
             ["g"] = 10;
             ["sublevel"] = 1;
          };
          [6] = {
             ["y"] = -312.08828891653;
             ["x"] = 402.69520423071;
             ["sublevel"] = 1;
          };
          [12] = {
             ["y"] = -227.78085937953;
             ["x"] = 398.22331186957;
             ["teeming"] = true;
             ["g"] = 17;
             ["sublevel"] = 1;
          };
          [11] = {
             ["y"] = -376.69289379098;
             ["x"] = 409.25105402897;
             ["teeming"] = true;
             ["g"] = 10;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91008;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Rockbound Pelter";
       ["displayId"] = 67568;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [20] = {
       ["clones"] = {
          [1] = {
             ["y"] = -271.97329886025;
             ["x"] = 186.79930014133;
             ["g"] = 28;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -279.19214613305;
             ["x"] = 186.93436377544;
             ["g"] = 28;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -338.13151416763;
             ["x"] = 161.81901510418;
             ["g"] = 31;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -318.32215343982;
             ["x"] = 133.63744180555;
             ["g"] = 30;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 102232;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Rockbound Trapper";
       ["displayId"] = 64665;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [21] = {
       ["clones"] = {
          [1] = {
             ["y"] = -301.35933059809;
             ["x"] = 198.63755258891;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -272.26842457608;
             ["x"] = 145.91024153332;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -330.99649079515;
             ["x"] = 167.9018661998;
             ["g"] = 31;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -311.06418892362;
             ["x"] = 139.07188714826;
             ["g"] = 30;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 113537;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1.4;
       ["name"] = "Emberhusk Dominator";
       ["displayId"] = 70784;
       ["creatureType"] = "Beast";
       ["level"] = 111;
       ["count"] = 10;
       ["health"] = 24528930;
    };
    [11] = {
       ["clones"] = {
          [1] = {
             ["y"] = -487.95428477581;
             ["x"] = 467.45697136899;
             ["patrol"] = {
                [6] = {
                   ["y"] = -492.0451897776;
                   ["x"] = 444.75784343273;
                };
                [2] = {
                   ["y"] = -487.95428477581;
                   ["x"] = 467.45697136899;
                };
                [8] = {
                   ["y"] = -500.68153177672;
                   ["x"] = 463.83385606157;
                };
                [3] = {
                   ["y"] = -474.44517993757;
                   ["x"] = 452.36383190061;
                };
                [1] = {
                   ["y"] = -496.13609477938;
                   ["x"] = 470.67037891044;
                };
                [4] = {
                   ["y"] = -479.31792326971;
                   ["x"] = 449.44458960235;
                };
                [5] = {
                   ["y"] = -484.7596966277;
                   ["x"] = 441.5416958032;
                };
                [7] = {
                   ["y"] = -502.95426978236;
                   ["x"] = 454.79647119134;
                };
             };
             ["patrolFacing"] = 0.98174770424681;
             ["g"] = 7;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -435.18663506784;
             ["x"] = 442.58663550248;
             ["patrol"] = {
                [6] = {
                   ["y"] = -414.44125625418;
                   ["x"] = 425.75962561963;
                };
                [2] = {
                   ["y"] = -443.60503184096;
                   ["x"] = 428.37852812729;
                };
                [3] = {
                   ["y"] = -442.46205698744;
                   ["x"] = 435.44188968825;
                };
                [1] = {
                   ["y"] = -437.49977867608;
                   ["x"] = 413.80382712089;
                };
                [4] = {
                   ["y"] = -435.18663506784;
                   ["x"] = 442.58663550248;
                };
                [5] = {
                   ["y"] = -426.13617182346;
                   ["x"] = 440.10448160543;
                };
                [7] = {
                   ["y"] = -420.33576730547;
                   ["x"] = 418.62464598308;
                };
             };
             ["patrolFacing"] = 0.29452431127404;
             ["g"] = 8;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -442.95423343369;
             ["x"] = 363.51424205082;
             ["g"] = 9;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91332;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Stoneclaw Hunter";
       ["displayId"] = 64667;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [22] = {
       ["clones"] = {
          [1] = {
             ["y"] = -264.71098828197;
             ["x"] = 546.37050528437;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91003;
       ["isBoss"] = true;
       ["encounterID"] = 1662;
       ["scale"] = 1;
       ["name"] = "Rokmora";
       ["displayId"] = 62386;
       ["creatureType"] = "Humanoid";
       ["level"] = 112;
       ["count"] = 0;
       ["health"] = 111016239;
    };
    [3] = {
       ["clones"] = {
          [7] = {
             ["y"] = -141.13712506599;
             ["x"] = 417.97981721945;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -261.68104036335;
             ["x"] = 686.63697268212;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -263.49920735949;
             ["x"] = 669.8187621585;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -148.86440307402;
             ["x"] = 405.70712172106;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -406.36374174185;
             ["x"] = 466.21509905449;
             ["sublevel"] = 1;
          };
          [9] = {
             ["y"] = -412.36374174185;
             ["x"] = 466.21509905449;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -138.40983555783;
             ["x"] = 401.16164570978;
             ["sublevel"] = 1;
          };
          [10] = {
             ["y"] = -418.36374174185;
             ["x"] = 466.21509905449;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -259.83238845692;
             ["x"] = 634.8782062355;
             ["sublevel"] = 1;
          };
          [6] = {
             ["y"] = -137.95526454833;
             ["x"] = 410.2526367463;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91006;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Rockback Gnasher";
       ["displayId"] = 65050;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [6] = {
       ["clones"] = {
          [1] = {
             ["y"] = -219.50139503988;
             ["x"] = 635.72797950132;
             ["g"] = 5;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 101438;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Vileshard Chunk";
       ["displayId"] = 64606;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [12] = {
       ["clones"] = {
          [1] = {
             ["y"] = -492.49972177314;
             ["x"] = 464.22356229038;
             ["g"] = 7;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -434.08119099532;
             ["x"] = 435.99812404913;
             ["g"] = 8;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -451.93710203094;
             ["x"] = 361.96651564036;
             ["g"] = 9;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91006;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Rockback Gnasher";
       ["displayId"] = 65050;
       ["creatureType"] = "Beast";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [24] = {
       ["clones"] = {
          [1] = {
             ["y"] = -351.16211884498;
             ["x"] = 144.09787242713;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91007;
       ["isBoss"] = true;
       ["encounterID"] = 1687;
       ["scale"] = 1;
       ["name"] = "Dargrul";
       ["displayId"] = 62392;
       ["creatureType"] = "Humanoid";
       ["level"] = 112;
       ["count"] = 0;
       ["health"] = 117360016;
    };
    [13] = {
       ["clones"] = {
          [1] = {
             ["y"] = -422.49969051284;
             ["x"] = 413.13815197421;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -477.49962930552;
             ["x"] = 473.59262286288;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 92387;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 0.6;
       ["name"] = "Drums of War";
       ["displayId"] = 63017;
       ["creatureType"] = "Mechanical";
       ["level"] = 110;
       ["count"] = 0;
       ["health"] = 2963859;
    };
    [7] = {
       ["clones"] = {
          [1] = {
             ["y"] = -225.21072831059;
             ["x"] = 632.54609918105;
             ["g"] = 5;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -357.73127026871;
             ["x"] = 405.76316354029;
             ["g"] = 12;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -230.15963713959;
             ["x"] = 631.15466291215;
             ["teeming"] = true;
             ["g"] = 5;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -302.63572182778;
             ["x"] = 387.22842718719;
             ["patrol"] = {
                [6] = {
                   ["y"] = -314.87302696693;
                   ["x"] = 373.58821623708;
                };
                [2] = {
                   ["y"] = -302.60033146854;
                   ["x"] = 386.31550225194;
                };
                [3] = {
                   ["y"] = -296.69123996364;
                   ["x"] = 381.7700652546;
                };
                [1] = {
                   ["y"] = -310.74173773058;
                   ["x"] = 386.87472622997;
                };
                [4] = {
                   ["y"] = -298.05489447121;
                   ["x"] = 370.86098524983;
                };
                [5] = {
                   ["y"] = -305.32756245579;
                   ["x"] = 369.49733074226;
                };
                [7] = {
                   ["y"] = -317.60033598207;
                   ["x"] = 380.8609232356;
                };
             };
             ["patrolFacing"] = 0.78539816339745;
             ["g"] = 14;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91000;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Vileshard Hulk";
       ["displayId"] = 65783;
       ["creatureType"] = "Humanoid";
       ["level"] = 111;
       ["count"] = 8;
       ["health"] = 24528930;
    };
    [14] = {
       ["clones"] = {
          [6] = {
             ["y"] = -222.33070978488;
             ["x"] = 395.65291511257;
             ["g"] = 17;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -300.72459888832;
             ["x"] = 424.51336424024;
             ["sublevel"] = 1;
          };
          [8] = {
             ["y"] = -219.59906888293;
             ["x"] = 390.95060487104;
             ["teeming"] = true;
             ["g"] = 17;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -290.27007038607;
             ["x"] = 386.33150619566;
             ["g"] = 13;
             ["sublevel"] = 1;
          };
          [1] = {
             ["y"] = -355.00401977449;
             ["x"] = 410.30860053762;
             ["g"] = 12;
             ["sublevel"] = 1;
          };
          [4] = {
             ["y"] = -306.00654866419;
             ["x"] = 392.118144872;
             ["g"] = 14;
             ["sublevel"] = 1;
          };
          [5] = {
             ["y"] = -321.72914559225;
             ["x"] = 356.25742554562;
             ["g"] = 16;
             ["sublevel"] = 1;
          };
          [7] = {
             ["y"] = -178.68372503463;
             ["x"] = 327.53034997138;
             ["g"] = 24;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 90998;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Blightshard Shaper";
       ["displayId"] = 65780;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [23] = {
       ["clones"] = {
          [1] = {
             ["y"] = -273.4195650778;
             ["x"] = 371.04740005228;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 91004;
       ["isBoss"] = true;
       ["encounterID"] = 1665;
       ["scale"] = 1;
       ["name"] = "Ularogg Cragshaper";
       ["displayId"] = 62390;
       ["creatureType"] = "Humanoid";
       ["level"] = 112;
       ["count"] = 0;
       ["health"] = 111016239;
    };
    [19] = {
       ["clones"] = {
          [1] = {
             ["y"] = -264.15513133871;
             ["x"] = 220.87621591054;
             ["g"] = 27;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -314.94177286;
             ["x"] = 161.81671847885;
             ["teeming"] = true;
             ["g"] = 34;
             ["sublevel"] = 1;
          };
          [3] = {
             ["y"] = -308.57814935954;
             ["x"] = 154.0894599778;
             ["teeming"] = true;
             ["g"] = 34;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 102253;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Understone Demolisher";
       ["displayId"] = 64783;
       ["creatureType"] = "Humanoid";
       ["level"] = 110;
       ["count"] = 4;
       ["health"] = 14819297;
    };
    [15] = {
       ["clones"] = {
          [1] = {
             ["y"] = -285.27008188621;
             ["x"] = 389.96795722979;
             ["g"] = 13;
             ["sublevel"] = 1;
          };
          [2] = {
             ["y"] = -182.86626361772;
             ["x"] = 332.60134300176;
             ["g"] = 24;
             ["sublevel"] = 1;
          };
       };
       ["id"] = 101437;
       ["color"] = {
          ["a"] = 0.8;
          ["b"] = 1;
          ["g"] = 1;
          ["r"] = 1;
       };
       ["scale"] = 1;
       ["name"] = "Burning Geode";
       ["displayId"] = 33425;
       ["creatureType"] = "Elemental";
       ["level"] = 110;
       ["count"] = 0;
       ["health"] = 1185544;
    };
 };