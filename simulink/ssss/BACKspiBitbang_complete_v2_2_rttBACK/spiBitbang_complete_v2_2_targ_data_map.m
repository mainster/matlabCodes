  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 21;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc paramMap
    ;%
    paramMap.nSections           = nTotSects;
    paramMap.sectIdxOffset       = sectIdxOffset;
      paramMap.sections(nTotSects) = dumSection; %prealloc
    paramMap.nTotData            = -1;
    
    ;%
    ;% Auto data (spiBitbang_complete_v2_2_P)
    ;%
      section.nData     = 37;
      section.data(37)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.Out_Y0
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_P.cs_Y0
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_P.clk_delayed_Y0
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_P.txSubShifts_Y0
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_P.Constant1_Value
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_P.Constant2_Value
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_P.Delay1_InitialCondition
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 7;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_Amp
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 8;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_Period
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 9;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_Duty
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 10;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_PhaseDelay
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 11;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value_a
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 12;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value_j
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 13;
	
	  ;% spiBitbang_complete_v2_2_P.Start16BitRead_Amp
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 14;
	
	  ;% spiBitbang_complete_v2_2_P.Start16BitRead_Period
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 15;
	
	  ;% spiBitbang_complete_v2_2_P.Start16BitRead_Duty
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 16;
	
	  ;% spiBitbang_complete_v2_2_P.Start16BitRead_PhaseDelay
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 17;
	
	  ;% spiBitbang_complete_v2_2_P.stop1_Value
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 18;
	
	  ;% spiBitbang_complete_v2_2_P.stop4_Value
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 19;
	
	  ;% spiBitbang_complete_v2_2_P.stop2_Value
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 23;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer_Amp
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 27;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer_Period
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 28;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer_Duty
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 29;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer_PhaseDelay
	  section.data(25).logicalSrcIdx = 24;
	  section.data(25).dtTransOffset = 30;
	
	  ;% spiBitbang_complete_v2_2_P.ad_Value
	  section.data(26).logicalSrcIdx = 25;
	  section.data(26).dtTransOffset = 31;
	
	  ;% spiBitbang_complete_v2_2_P.Gain_Gain
	  section.data(27).logicalSrcIdx = 26;
	  section.data(27).dtTransOffset = 38;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value_l
	  section.data(28).logicalSrcIdx = 27;
	  section.data(28).dtTransOffset = 39;
	
	  ;% spiBitbang_complete_v2_2_P.s1_Value
	  section.data(29).logicalSrcIdx = 28;
	  section.data(29).dtTransOffset = 40;
	
	  ;% spiBitbang_complete_v2_2_P.s2_Value
	  section.data(30).logicalSrcIdx = 29;
	  section.data(30).dtTransOffset = 41;
	
	  ;% spiBitbang_complete_v2_2_P.s3_Value
	  section.data(31).logicalSrcIdx = 30;
	  section.data(31).dtTransOffset = 42;
	
	  ;% spiBitbang_complete_v2_2_P.Termin_Value
	  section.data(32).logicalSrcIdx = 31;
	  section.data(32).dtTransOffset = 43;
	
	  ;% spiBitbang_complete_v2_2_P.stop3_Value
	  section.data(33).logicalSrcIdx = 32;
	  section.data(33).dtTransOffset = 44;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer1_Amp
	  section.data(34).logicalSrcIdx = 33;
	  section.data(34).dtTransOffset = 48;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer1_Period
	  section.data(35).logicalSrcIdx = 34;
	  section.data(35).dtTransOffset = 49;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer1_Duty
	  section.data(36).logicalSrcIdx = 35;
	  section.data(36).dtTransOffset = 50;
	
	  ;% spiBitbang_complete_v2_2_P.ResTimer1_PhaseDelay
	  section.data(37).logicalSrcIdx = 36;
	  section.data(37).dtTransOffset = 51;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
      section.nData     = 16;
      section.data(16)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.Delay1_DelayLength
	  section.data(1).logicalSrcIdx = 37;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_OnOff_TARGETCNT
	  section.data(2).logicalSrcIdx = 38;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_P.f_sck_OnOff_ACTLEVEL
	  section.data(3).logicalSrcIdx = 39;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_P.NSampleEnable_TARGETCNT
	  section.data(4).logicalSrcIdx = 40;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL
	  section.data(5).logicalSrcIdx = 41;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_P.NSampleEnable_TARGETCNT_k
	  section.data(6).logicalSrcIdx = 42;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL_n
	  section.data(7).logicalSrcIdx = 43;
	  section.data(7).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_P.CSn_p1
	  section.data(8).logicalSrcIdx = 44;
	  section.data(8).dtTransOffset = 7;
	
	  ;% spiBitbang_complete_v2_2_P.CSn_p2
	  section.data(9).logicalSrcIdx = 45;
	  section.data(9).dtTransOffset = 8;
	
	  ;% spiBitbang_complete_v2_2_P.CSn_p3
	  section.data(10).logicalSrcIdx = 46;
	  section.data(10).dtTransOffset = 9;
	
	  ;% spiBitbang_complete_v2_2_P.MOSI_p1
	  section.data(11).logicalSrcIdx = 47;
	  section.data(11).dtTransOffset = 10;
	
	  ;% spiBitbang_complete_v2_2_P.MOSI_p2
	  section.data(12).logicalSrcIdx = 48;
	  section.data(12).dtTransOffset = 11;
	
	  ;% spiBitbang_complete_v2_2_P.MOSI_p3
	  section.data(13).logicalSrcIdx = 49;
	  section.data(13).dtTransOffset = 12;
	
	  ;% spiBitbang_complete_v2_2_P.SCK_p1
	  section.data(14).logicalSrcIdx = 50;
	  section.data(14).dtTransOffset = 13;
	
	  ;% spiBitbang_complete_v2_2_P.SCK_p2
	  section.data(15).logicalSrcIdx = 51;
	  section.data(15).dtTransOffset = 14;
	
	  ;% spiBitbang_complete_v2_2_P.SCK_p3
	  section.data(16).logicalSrcIdx = 52;
	  section.data(16).dtTransOffset = 15;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(2) = section;
      clear section
      
      section.nData     = 7;
      section.data(7)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.out_Y0
	  section.data(1).logicalSrcIdx = 53;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.TxData_Value
	  section.data(2).logicalSrcIdx = 54;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value_p
	  section.data(3).logicalSrcIdx = 55;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_P.Output_InitialCondition
	  section.data(4).logicalSrcIdx = 56;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_P.Constant_Value_o
	  section.data(5).logicalSrcIdx = 57;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_P.FixPtConstant_Value
	  section.data(6).logicalSrcIdx = 58;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_P.FixPtSwitch_Threshold
	  section.data(7).logicalSrcIdx = 59;
	  section.data(7).dtTransOffset = 6;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(3) = section;
      clear section
      
      section.nData     = 8;
      section.data(8)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.TransmitCommand_CurrentSetting
	  section.data(1).logicalSrcIdx = 60;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.Counter_InitialCount
	  section.data(2).logicalSrcIdx = 61;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_P.Counter_HitValue
	  section.data(3).logicalSrcIdx = 62;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_P.CSn_p4
	  section.data(4).logicalSrcIdx = 63;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_P.MOSI_p4
	  section.data(5).logicalSrcIdx = 64;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_P.SCK_p4
	  section.data(6).logicalSrcIdx = 65;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_P.Counter_InitialCount_h
	  section.data(7).logicalSrcIdx = 66;
	  section.data(7).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_P.Counter_HitValue_n
	  section.data(8).logicalSrcIdx = 67;
	  section.data(8).dtTransOffset = 7;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(4) = section;
      clear section
      
      section.nData     = 21;
      section.data(21)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.Q_Y0
	  section.data(1).logicalSrcIdx = 68;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.Q_Y0_b
	  section.data(2).logicalSrcIdx = 69;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_P.tx_Y0
	  section.data(3).logicalSrcIdx = 70;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_P.UnitDelay_InitialCondition
	  section.data(4).logicalSrcIdx = 71;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0
	  section.data(5).logicalSrcIdx = 72;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_P.stop_Value
	  section.data(6).logicalSrcIdx = 73;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_l
	  section.data(7).logicalSrcIdx = 74;
	  section.data(7).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_j
	  section.data(8).logicalSrcIdx = 75;
	  section.data(8).dtTransOffset = 7;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_a
	  section.data(9).logicalSrcIdx = 76;
	  section.data(9).dtTransOffset = 8;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_h
	  section.data(10).logicalSrcIdx = 77;
	  section.data(10).dtTransOffset = 9;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_g
	  section.data(11).logicalSrcIdx = 78;
	  section.data(11).dtTransOffset = 10;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_e
	  section.data(12).logicalSrcIdx = 79;
	  section.data(12).dtTransOffset = 11;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_n
	  section.data(13).logicalSrcIdx = 80;
	  section.data(13).dtTransOffset = 12;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_jo
	  section.data(14).logicalSrcIdx = 81;
	  section.data(14).dtTransOffset = 13;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_gi
	  section.data(15).logicalSrcIdx = 82;
	  section.data(15).dtTransOffset = 14;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_jw
	  section.data(16).logicalSrcIdx = 83;
	  section.data(16).dtTransOffset = 15;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_b
	  section.data(17).logicalSrcIdx = 84;
	  section.data(17).dtTransOffset = 16;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_p
	  section.data(18).logicalSrcIdx = 85;
	  section.data(18).dtTransOffset = 17;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1__jwm
	  section.data(19).logicalSrcIdx = 86;
	  section.data(19).dtTransOffset = 18;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_f
	  section.data(20).logicalSrcIdx = 87;
	  section.data(20).dtTransOffset = 19;
	
	  ;% spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_h4
	  section.data(21).logicalSrcIdx = 88;
	  section.data(21).dtTransOffset = 20;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(5) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.Gain_Gain_b
	  section.data(1).logicalSrcIdx = 89;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(6) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_m.Q_Y0
	  section.data(1).logicalSrcIdx = 90;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_m.Q_Y0_a
	  section.data(2).logicalSrcIdx = 91;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(7) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_h.Q_Y0
	  section.data(1).logicalSrcIdx = 92;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_h.Q_Y0_a
	  section.data(2).logicalSrcIdx = 93;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(8) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_a.Q_Y0
	  section.data(1).logicalSrcIdx = 94;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_a.Q_Y0_a
	  section.data(2).logicalSrcIdx = 95;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(9) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_g.Q_Y0
	  section.data(1).logicalSrcIdx = 96;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_g.Q_Y0_a
	  section.data(2).logicalSrcIdx = 97;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(10) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_j.Q_Y0
	  section.data(1).logicalSrcIdx = 98;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_j.Q_Y0_a
	  section.data(2).logicalSrcIdx = 99;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(11) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_l.Q_Y0
	  section.data(1).logicalSrcIdx = 100;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_l.Q_Y0_a
	  section.data(2).logicalSrcIdx = 101;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(12) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_p3.Q_Y0
	  section.data(1).logicalSrcIdx = 102;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_p3.Q_Y0_a
	  section.data(2).logicalSrcIdx = 103;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(13) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_hh.Q_Y0
	  section.data(1).logicalSrcIdx = 104;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_hh.Q_Y0_a
	  section.data(2).logicalSrcIdx = 105;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(14) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_ht.Q_Y0
	  section.data(1).logicalSrcIdx = 106;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_ht.Q_Y0_a
	  section.data(2).logicalSrcIdx = 107;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(15) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_p.Q_Y0
	  section.data(1).logicalSrcIdx = 108;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_p.Q_Y0_a
	  section.data(2).logicalSrcIdx = 109;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(16) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_gy.Q_Y0
	  section.data(1).logicalSrcIdx = 110;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_gy.Q_Y0_a
	  section.data(2).logicalSrcIdx = 111;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(17) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_as.Q_Y0
	  section.data(1).logicalSrcIdx = 112;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_as.Q_Y0_a
	  section.data(2).logicalSrcIdx = 113;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(18) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_e.Q_Y0
	  section.data(1).logicalSrcIdx = 114;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_e.Q_Y0_a
	  section.data(2).logicalSrcIdx = 115;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(19) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_o.Q_Y0
	  section.data(1).logicalSrcIdx = 116;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_o.Q_Y0_a
	  section.data(2).logicalSrcIdx = 117;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(20) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_b.Q_Y0
	  section.data(1).logicalSrcIdx = 118;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_P.DFlipFlop_b.Q_Y0_a
	  section.data(2).logicalSrcIdx = 119;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(21) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (parameter)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    paramMap.nTotData = nTotData;
    


  ;%**************************
  ;% Create Block Output Map *
  ;%**************************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 19;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc sigMap
    ;%
    sigMap.nSections           = nTotSects;
    sigMap.sectIdxOffset       = sectIdxOffset;
      sigMap.sections(nTotSects) = dumSection; %prealloc
    sigMap.nTotData            = -1;
    
    ;%
    ;% Auto data (spiBitbang_complete_v2_2_B)
    ;%
      section.nData     = 29;
      section.data(29)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.ctrGen
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_B.Burst_En16
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_B.transEn
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_B.txStr
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_B.clk_delayed
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_B.Sum8
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_B.Sum9
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 7;
	
	  ;% spiBitbang_complete_v2_2_B.Sum10
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 8;
	
	  ;% spiBitbang_complete_v2_2_B.Sum11
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 9;
	
	  ;% spiBitbang_complete_v2_2_B.Hit
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 10;
	
	  ;% spiBitbang_complete_v2_2_B.CLK_ffs
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 11;
	
	  ;% spiBitbang_complete_v2_2_B.DatIn
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 12;
	
	  ;% spiBitbang_complete_v2_2_B.Res
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 13;
	
	  ;% spiBitbang_complete_v2_2_B.DatIn_a
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 14;
	
	  ;% spiBitbang_complete_v2_2_B.CtrUp
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 15;
	
	  ;% spiBitbang_complete_v2_2_B.Sum3
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 16;
	
	  ;% spiBitbang_complete_v2_2_B.LastQ
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 17;
	
	  ;% spiBitbang_complete_v2_2_B.ctxStream
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 18;
	
	  ;% spiBitbang_complete_v2_2_B.sclk_delayed
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 19;
	
	  ;% spiBitbang_complete_v2_2_B.sHit
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 20;
	
	  ;% spiBitbang_complete_v2_2_B.sHit_delay
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 21;
	
	  ;% spiBitbang_complete_v2_2_B.Termin
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 22;
	
	  ;% spiBitbang_complete_v2_2_B.conv4
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 23;
	
	  ;% spiBitbang_complete_v2_2_B.conv3
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 24;
	
	  ;% spiBitbang_complete_v2_2_B.conv1
	  section.data(25).logicalSrcIdx = 24;
	  section.data(25).dtTransOffset = 25;
	
	  ;% spiBitbang_complete_v2_2_B.Sum
	  section.data(26).logicalSrcIdx = 25;
	  section.data(26).dtTransOffset = 26;
	
	  ;% spiBitbang_complete_v2_2_B.clk
	  section.data(27).logicalSrcIdx = 26;
	  section.data(27).dtTransOffset = 30;
	
	  ;% spiBitbang_complete_v2_2_B.gen_CS
	  section.data(28).logicalSrcIdx = 27;
	  section.data(28).dtTransOffset = 31;
	
	  ;% spiBitbang_complete_v2_2_B.clk_delayed_n
	  section.data(29).logicalSrcIdx = 28;
	  section.data(29).dtTransOffset = 32;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
      section.nData     = 4;
      section.data(4)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.u
	  section.data(1).logicalSrcIdx = 29;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_B.s
	  section.data(2).logicalSrcIdx = 30;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_B.shiftout
	  section.data(3).logicalSrcIdx = 31;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_B.BitwiseOperator
	  section.data(4).logicalSrcIdx = 32;
	  section.data(4).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.MaskCtr
	  section.data(1).logicalSrcIdx = 33;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(3) = section;
      clear section
      
      section.nData     = 9;
      section.data(9)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.interrupt
	  section.data(1).logicalSrcIdx = 35;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_B.En16
	  section.data(2).logicalSrcIdx = 36;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_B.cast11
	  section.data(3).logicalSrcIdx = 38;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_B.VectorConcatenate1
	  section.data(4).logicalSrcIdx = 39;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_B.LogicalOperator
	  section.data(5).logicalSrcIdx = 40;
	  section.data(5).dtTransOffset = 19;
	
	  ;% spiBitbang_complete_v2_2_B.conv2
	  section.data(6).logicalSrcIdx = 41;
	  section.data(6).dtTransOffset = 20;
	
	  ;% spiBitbang_complete_v2_2_B.D
	  section.data(7).logicalSrcIdx = 42;
	  section.data(7).dtTransOffset = 21;
	
	  ;% spiBitbang_complete_v2_2_B.NSampleEnable
	  section.data(8).logicalSrcIdx = 43;
	  section.data(8).dtTransOffset = 22;
	
	  ;% spiBitbang_complete_v2_2_B.NSampleEnable_m
	  section.data(9).logicalSrcIdx = 44;
	  section.data(9).dtTransOffset = 23;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(4) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_m.D
	  section.data(1).logicalSrcIdx = 45;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(5) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_h.D
	  section.data(1).logicalSrcIdx = 46;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(6) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_a.D
	  section.data(1).logicalSrcIdx = 47;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(7) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_g.D
	  section.data(1).logicalSrcIdx = 48;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(8) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_j.D
	  section.data(1).logicalSrcIdx = 49;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(9) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_l.D
	  section.data(1).logicalSrcIdx = 50;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(10) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_p3.D
	  section.data(1).logicalSrcIdx = 51;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(11) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_hh.D
	  section.data(1).logicalSrcIdx = 52;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(12) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_ht.D
	  section.data(1).logicalSrcIdx = 53;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(13) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_p.D
	  section.data(1).logicalSrcIdx = 54;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(14) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_gy.D
	  section.data(1).logicalSrcIdx = 55;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(15) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_as.D
	  section.data(1).logicalSrcIdx = 56;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(16) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_e.D
	  section.data(1).logicalSrcIdx = 57;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(17) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_o.D
	  section.data(1).logicalSrcIdx = 58;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(18) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_B.DFlipFlop_b.D
	  section.data(1).logicalSrcIdx = 59;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(19) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (signal)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    sigMap.nTotData = nTotData;
    


  ;%*******************
  ;% Create DWork Map *
  ;%*******************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 39;
    sectIdxOffset = 19;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc dworkMap
    ;%
    dworkMap.nSections           = nTotSects;
    dworkMap.sectIdxOffset       = sectIdxOffset;
      dworkMap.sections(nTotSects) = dumSection; %prealloc
    dworkMap.nTotData            = -1;
    
    ;%
    ;% Auto data (spiBitbang_complete_v2_2_DW)
    ;%
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.Delay1_DSTATE
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 6;
      section.data(6)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.Scope10_PWORK.LoggedData
	  section.data(1).logicalSrcIdx = 1;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.subsystem_einfach_PWORK.LoggedData
	  section.data(2).logicalSrcIdx = 2;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_DW.Scope2_PWORK.LoggedData
	  section.data(3).logicalSrcIdx = 3;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_DW.Scope1_PWORK.LoggedData
	  section.data(4).logicalSrcIdx = 4;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_DW.Scope9_PWORK.LoggedData
	  section.data(5).logicalSrcIdx = 5;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_DW.SignalToWorkspace_PWORK.LoggedData
	  section.data(6).logicalSrcIdx = 6;
	  section.data(6).dtTransOffset = 5;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 4;
      section.data(4)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.clockTickCounter
	  section.data(1).logicalSrcIdx = 7;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.clockTickCounter_c
	  section.data(2).logicalSrcIdx = 8;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_DW.clockTickCounter_n
	  section.data(3).logicalSrcIdx = 9;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_DW.clockTickCounter_l
	  section.data(4).logicalSrcIdx = 10;
	  section.data(4).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(3) = section;
      clear section
      
      section.nData     = 7;
      section.data(7)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.f_sck_OnOff_Counter
	  section.data(1).logicalSrcIdx = 11;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.Counter_ClkEphState
	  section.data(2).logicalSrcIdx = 12;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_DW.Counter_RstEphState
	  section.data(3).logicalSrcIdx = 13;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_DW.NSampleEnable_Counter
	  section.data(4).logicalSrcIdx = 14;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_DW.NSampleEnable_Counter_o
	  section.data(5).logicalSrcIdx = 15;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_DW.Counter_ClkEphState_g
	  section.data(6).logicalSrcIdx = 16;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_DW.Counter_RstEphState_m
	  section.data(7).logicalSrcIdx = 17;
	  section.data(7).dtTransOffset = 6;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(4) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.Output_DSTATE
	  section.data(1).logicalSrcIdx = 18;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(5) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.UnitDelay_DSTATE
	  section.data(1).logicalSrcIdx = 19;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(6) = section;
      clear section
      
      section.nData     = 5;
      section.data(5)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 20;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.TxSubsystem_SubsysRanBC
	  section.data(2).logicalSrcIdx = 21;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_DW.TriggeredToWorkspace_SubsysRanB
	  section.data(3).logicalSrcIdx = 22;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_DW.TriggeredSignalFromWorkspace_Su
	  section.data(4).logicalSrcIdx = 23;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_DW.Bitmask_SubsysRanBC
	  section.data(5).logicalSrcIdx = 24;
	  section.data(5).dtTransOffset = 4;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(7) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.Counter_Count
	  section.data(1).logicalSrcIdx = 25;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.Counter_Count_o
	  section.data(2).logicalSrcIdx = 26;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(8) = section;
      clear section
      
      section.nData     = 18;
      section.data(18)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Prev
	  section.data(1).logicalSrcIdx = 27;
	  section.data(1).dtTransOffset = 0;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_g
	  section.data(2).logicalSrcIdx = 28;
	  section.data(2).dtTransOffset = 1;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_m
	  section.data(3).logicalSrcIdx = 29;
	  section.data(3).dtTransOffset = 2;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_o
	  section.data(4).logicalSrcIdx = 30;
	  section.data(4).dtTransOffset = 3;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_n
	  section.data(5).logicalSrcIdx = 31;
	  section.data(5).dtTransOffset = 4;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_k
	  section.data(6).logicalSrcIdx = 32;
	  section.data(6).dtTransOffset = 5;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_gk
	  section.data(7).logicalSrcIdx = 33;
	  section.data(7).dtTransOffset = 6;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_j
	  section.data(8).logicalSrcIdx = 34;
	  section.data(8).dtTransOffset = 7;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_d
	  section.data(9).logicalSrcIdx = 35;
	  section.data(9).dtTransOffset = 8;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_np
	  section.data(10).logicalSrcIdx = 36;
	  section.data(10).dtTransOffset = 9;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_n0
	  section.data(11).logicalSrcIdx = 37;
	  section.data(11).dtTransOffset = 10;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_ja
	  section.data(12).logicalSrcIdx = 38;
	  section.data(12).dtTransOffset = 11;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_nq
	  section.data(13).logicalSrcIdx = 39;
	  section.data(13).dtTransOffset = 12;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_h
	  section.data(14).logicalSrcIdx = 40;
	  section.data(14).dtTransOffset = 13;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_oj
	  section.data(15).logicalSrcIdx = 41;
	  section.data(15).dtTransOffset = 14;
	
	  ;% spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_p
	  section.data(16).logicalSrcIdx = 42;
	  section.data(16).dtTransOffset = 15;
	
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_MODE
	  section.data(17).logicalSrcIdx = 43;
	  section.data(17).dtTransOffset = 16;
	
	  ;% spiBitbang_complete_v2_2_DW.TxSubsystem_MODE
	  section.data(18).logicalSrcIdx = 44;
	  section.data(18).dtTransOffset = 17;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(9) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_m.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 45;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(10) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_m.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 46;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(11) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_h.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 47;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(12) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_h.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 48;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(13) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_a.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 49;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(14) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_a.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 50;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(15) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_g.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 51;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(16) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_g.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 52;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(17) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_j.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 53;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(18) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_j.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 54;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(19) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_l.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 55;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(20) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_l.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 56;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(21) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_p3.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 57;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(22) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_p3.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 58;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(23) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_hh.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 59;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(24) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_hh.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 60;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(25) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_ht.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 61;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(26) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_ht.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 62;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(27) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_p.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 63;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(28) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_p.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 64;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(29) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_gy.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 65;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(30) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_gy.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 66;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(31) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_as.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 67;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(32) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_as.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 68;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(33) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_e.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 69;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(34) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_e.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 70;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(35) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_o.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 71;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(36) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_o.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 72;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(37) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_b.DFlipFlop_SubsysRanBC
	  section.data(1).logicalSrcIdx = 73;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(38) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% spiBitbang_complete_v2_2_DW.DFlipFlop_b.DFlipFlop_MODE
	  section.data(1).logicalSrcIdx = 74;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(39) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (dwork)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    dworkMap.nTotData = nTotData;
    


  ;%
  ;% Add individual maps to base struct.
  ;%

  targMap.paramMap  = paramMap;    
  targMap.signalMap = sigMap;
  targMap.dworkMap  = dworkMap;
  
  ;%
  ;% Add checksums to base struct.
  ;%


  targMap.checksum0 = 292249521;
  targMap.checksum1 = 3657097572;
  targMap.checksum2 = 2164101857;
  targMap.checksum3 = 511334093;

