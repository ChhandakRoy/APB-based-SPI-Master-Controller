/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03-SP4
// Date      : Thu Sep 17 20:16:08 2026
/////////////////////////////////////////////////////////////


module APB_SLAVE_INTERFACE_WIDTH8 ( PCLK, PRESETn, PWRITE_I, PSEL_I, PENABLE_I,
        PWDATA_I, PADDR_I, SS_I, MISO_DATA_I, RECEIVE_DATA_I, PRDATA_O, MSTR_O,
        PREADY_O, PSLVERR_O, CPOL_O, CPHA_O, LSBFE_O, SPISWAI_O, SPR_O, SPPR_O,
        SPI_INTERRUPT_RQST_O, SEND_DATA_O, MOSI_DATA_O, SPI_MODE_O );
  input [7:0] PWDATA_I;
  input [2:0] PADDR_I;
  input [7:0] MISO_DATA_I;
  output [7:0] PRDATA_O;
  output [2:0] SPR_O;
  output [2:0] SPPR_O;
  output [7:0] MOSI_DATA_O;
  output [1:0] SPI_MODE_O;
  input PCLK, PRESETn, PWRITE_I, PSEL_I, PENABLE_I, SS_I, RECEIVE_DATA_I;
  output MSTR_O, PREADY_O, PSLVERR_O, CPOL_O, CPHA_O, LSBFE_O, SPISWAI_O,
         SPI_INTERRUPT_RQST_O, SEND_DATA_O;
  wire   control_reg1_1, control_reg2_0, status_reg_7, \status_reg[5] ,
         \br_reg[7] , br_reg_3, dr_pending, N62, N63, N64, N65, N66, N67, N68,
         N69, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n164, n165, n166, n167, n168, n169, n170, n171, n172,
         n173, n174, n175, n176, n177, n178, n179, n180, n181, n182, n183,
         n184, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n185, n186, n187, n188,
         n189, n190, n191;
  wire   [7:5] control_reg1;
  wire   [7:2] control_reg2;
  wire   [1:0] APB_state;
  wire   [7:0] tx_data_reg;
  wire   [7:0] rx_data_reg;

  FD2 \APB_state_reg[0]  ( .D(n184), .CP(PCLK), .CD(PRESETn), .Q(APB_state[0])
         );
  FD2 \APB_state_reg[1]  ( .D(n183), .CP(PCLK), .CD(PRESETn), .Q(APB_state[1]),
        .QN(n189) );
  FD2 \SPI_state_reg[0]  ( .D(n181), .CP(PCLK), .CD(PRESETn), .Q(SPI_MODE_O[0]), .QN(n191) );
  FD2 \SPI_state_reg[1]  ( .D(n182), .CP(PCLK), .CD(PRESETn), .Q(SPI_MODE_O[1]), .QN(n186) );
  FD2 SEND_DATA_O_reg ( .D(n180), .CP(PCLK), .CD(PRESETn), .Q(SEND_DATA_O) );
  FD2 \MOSI_DATA_O_reg[0]  ( .D(n179), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[0]) );
  FD2 \MOSI_DATA_O_reg[7]  ( .D(n178), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[7]) );
  FD2 \MOSI_DATA_O_reg[6]  ( .D(n177), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[6]) );
  FD2 \MOSI_DATA_O_reg[5]  ( .D(n176), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[5]) );
  FD2 \MOSI_DATA_O_reg[4]  ( .D(n175), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[4]) );
  FD2 \MOSI_DATA_O_reg[3]  ( .D(n174), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[3]) );
  FD2 \MOSI_DATA_O_reg[2]  ( .D(n173), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[2]) );
  FD2 \MOSI_DATA_O_reg[1]  ( .D(n172), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_DATA_O[1]) );
  FD2 dr_pending_reg ( .D(n171), .CP(PCLK), .CD(PRESETn), .Q(dr_pending) );
  FD2 \PRDATA_O_reg[0]  ( .D(N62), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[0]) );
  FD2 \PRDATA_O_reg[1]  ( .D(N63), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[1]) );
  FD2 \PRDATA_O_reg[2]  ( .D(N64), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[2]) );
  FD2 \PRDATA_O_reg[3]  ( .D(N65), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[3]) );
  FD2 \PRDATA_O_reg[4]  ( .D(N66), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[4]) );
  FD2 \PRDATA_O_reg[5]  ( .D(N67), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[5]) );
  FD2 \PRDATA_O_reg[6]  ( .D(N68), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[6]) );
  FD2 spif_reg_reg ( .D(n169), .CP(PCLK), .CD(PRESETn), .Q(status_reg_7), .QN(
        n188) );
  FD2 \PRDATA_O_reg[7]  ( .D(N69), .CP(PCLK), .CD(PRESETn), .Q(PRDATA_O[7]) );
  FD2 \control_reg1_reg[0]  ( .D(n168), .CP(PCLK), .CD(PRESETn), .Q(LSBFE_O)
         );
  FD2 \control_reg1_reg[7]  ( .D(n167), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg1[7]) );
  FD2 \control_reg1_reg[6]  ( .D(n166), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg1[6]), .QN(n187) );
  FD2 \control_reg1_reg[5]  ( .D(n165), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg1[5]) );
  FD2 \control_reg1_reg[4]  ( .D(n164), .CP(PCLK), .CD(PRESETn), .Q(MSTR_O) );
  FD2 \control_reg1_reg[3]  ( .D(n163), .CP(PCLK), .CD(PRESETn), .Q(CPOL_O) );
  FD2 \control_reg1_reg[2]  ( .D(n162), .CP(PCLK), .CD(PRESETn), .Q(CPHA_O) );
  FD2 \control_reg1_reg[1]  ( .D(n161), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg1_1) );
  FD2 \control_reg2_reg[0]  ( .D(n160), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2_0) );
  FD2 \control_reg2_reg[7]  ( .D(n159), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[7]) );
  FD2 \control_reg2_reg[6]  ( .D(n158), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[6]) );
  FD2 \control_reg2_reg[5]  ( .D(n157), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[5]) );
  FD2 \control_reg2_reg[4]  ( .D(n156), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[4]) );
  FD2 \control_reg2_reg[3]  ( .D(n155), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[3]) );
  FD2 \control_reg2_reg[2]  ( .D(n154), .CP(PCLK), .CD(PRESETn), .Q(
        control_reg2[2]) );
  FD2 \control_reg2_reg[1]  ( .D(n153), .CP(PCLK), .CD(PRESETn), .Q(SPISWAI_O),
        .QN(n190) );
  FD2 \rx_data_reg_reg[0]  ( .D(n152), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[0]) );
  FD2 \rx_data_reg_reg[7]  ( .D(n151), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[7]) );
  FD2 \rx_data_reg_reg[6]  ( .D(n150), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[6]) );
  FD2 \rx_data_reg_reg[5]  ( .D(n149), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[5]) );
  FD2 \rx_data_reg_reg[4]  ( .D(n148), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[4]) );
  FD2 \rx_data_reg_reg[3]  ( .D(n147), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[3]) );
  FD2 \rx_data_reg_reg[2]  ( .D(n146), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[2]) );
  FD2 \rx_data_reg_reg[1]  ( .D(n145), .CP(PCLK), .CD(PRESETn), .Q(
        rx_data_reg[1]) );
  FD2 \br_reg_reg[0]  ( .D(n144), .CP(PCLK), .CD(PRESETn), .Q(SPR_O[0]) );
  FD2 \br_reg_reg[7]  ( .D(n143), .CP(PCLK), .CD(PRESETn), .Q(\br_reg[7] ) );
  FD2 \br_reg_reg[6]  ( .D(n142), .CP(PCLK), .CD(PRESETn), .Q(SPPR_O[2]) );
  FD2 \br_reg_reg[5]  ( .D(n141), .CP(PCLK), .CD(PRESETn), .Q(SPPR_O[1]) );
  FD2 \br_reg_reg[4]  ( .D(n140), .CP(PCLK), .CD(PRESETn), .Q(SPPR_O[0]) );
  FD2 \br_reg_reg[3]  ( .D(n139), .CP(PCLK), .CD(PRESETn), .Q(br_reg_3) );
  FD2 \br_reg_reg[2]  ( .D(n138), .CP(PCLK), .CD(PRESETn), .Q(SPR_O[2]) );
  FD2 \br_reg_reg[1]  ( .D(n137), .CP(PCLK), .CD(PRESETn), .Q(SPR_O[1]) );
  FD2 \tx_data_reg_reg[0]  ( .D(n136), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[0]) );
  FD2 \tx_data_reg_reg[7]  ( .D(n135), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[7]) );
  FD2 \tx_data_reg_reg[6]  ( .D(n134), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[6]) );
  FD2 \tx_data_reg_reg[5]  ( .D(n133), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[5]) );
  FD2 \tx_data_reg_reg[4]  ( .D(n132), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[4]) );
  FD2 \tx_data_reg_reg[3]  ( .D(n131), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[3]) );
  FD2 \tx_data_reg_reg[2]  ( .D(n130), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[2]) );
  FD2 \tx_data_reg_reg[1]  ( .D(n129), .CP(PCLK), .CD(PRESETn), .Q(
        tx_data_reg[1]) );
  FD4 sptef_reg_reg ( .D(n170), .CP(PCLK), .SD(PRESETn), .Q(\status_reg[5] )
         );
  IVP U3 ( .A(n65), .Z(n24) );
  NR2 U4 ( .A(APB_state[0]), .B(n189), .Z(PREADY_O) );
  IVA U5 ( .A(n20), .Z(n167) );
  IVA U6 ( .A(n22), .Z(n168) );
  IVA U7 ( .A(n14), .Z(n163) );
  IVA U8 ( .A(n11), .Z(n164) );
  IVA U9 ( .A(n21), .Z(n165) );
  IVA U10 ( .A(n15), .Z(n162) );
  IVA U11 ( .A(n17), .Z(n154) );
  IVA U12 ( .A(n16), .Z(n155) );
  IVA U13 ( .A(n13), .Z(n160) );
  IVA U14 ( .A(n18), .Z(n159) );
  IVA U15 ( .A(n23), .Z(n156) );
  IVA U16 ( .A(n19), .Z(n157) );
  IVA U17 ( .A(n34), .Z(n139) );
  IVA U18 ( .A(n33), .Z(n141) );
  IVA U19 ( .A(n36), .Z(n143) );
  IVA U20 ( .A(n38), .Z(n136) );
  IVA U21 ( .A(n41), .Z(n132) );
  IVA U22 ( .A(n37), .Z(n130) );
  IVA U23 ( .A(n40), .Z(n131) );
  IVA U24 ( .A(n39), .Z(n133) );
  IVA U25 ( .A(n42), .Z(n135) );
  IVA U26 ( .A(n55), .Z(n56) );
  ND4 U27 ( .A(n186), .B(n98), .C(SS_I), .D(dr_pending), .Z(n100) );
  IVP U28 ( .A(n104), .Z(n105) );
  IVP U29 ( .A(n106), .Z(n107) );
  IVP U30 ( .A(n35), .Z(n126) );
  ND2 U31 ( .A(n70), .B(n12), .Z(n104) );
  IVP U32 ( .A(n185), .Z(n98) );
  ND2 U33 ( .A(n63), .B(n12), .Z(n106) );
  NR2 U34 ( .A(n102), .B(n97), .Z(n185) );
  IVA U35 ( .A(n97), .Z(n12) );
  IVA U36 ( .A(n64), .Z(n54) );
  IVA U37 ( .A(n102), .Z(n66) );
  ND2 U38 ( .A(n4), .B(PREADY_O), .Z(n101) );
  IVP U39 ( .A(n122), .Z(n123) );
  ND2 U40 ( .A(PREADY_O), .B(PWRITE_I), .Z(n97) );
  NR2 U41 ( .A(PADDR_I[0]), .B(n49), .Z(n65) );
  NR2 U42 ( .A(PADDR_I[1]), .B(n1), .Z(n70) );
  ND2 U43 ( .A(PADDR_I[2]), .B(n2), .Z(n102) );
  ND2 U44 ( .A(RECEIVE_DATA_I), .B(n186), .Z(n122) );
  EO U45 ( .A(SPI_MODE_O[1]), .B(SPI_MODE_O[0]), .Z(n78) );
  ND2 U46 ( .A(n3), .B(PADDR_I[1]), .Z(n49) );
  NR2 U47 ( .A(n50), .B(PADDR_I[1]), .Z(n2) );
  IVP U48 ( .A(PADDR_I[0]), .Z(n50) );
  IVP U49 ( .A(PENABLE_I), .Z(n72) );
  IVP U50 ( .A(PWDATA_I[6]), .Z(n127) );
  IVA U51 ( .A(PWRITE_I), .Z(n4) );
  IVP U52 ( .A(PWDATA_I[1]), .Z(n128) );
  IVP U53 ( .A(PADDR_I[2]), .Z(n3) );
  ND2 U54 ( .A(n50), .B(n3), .Z(n1) );
  AN2P U55 ( .A(n3), .B(n2), .Z(n63) );
  AO2 U56 ( .A(control_reg1_1), .B(n70), .C(n63), .D(SPISWAI_O), .Z(n6) );
  AO2 U57 ( .A(n66), .B(rx_data_reg[1]), .C(n65), .D(SPR_O[1]), .Z(n5) );
  AO6 U58 ( .A(n6), .B(n5), .C(n101), .Z(N63) );
  AO2 U59 ( .A(n63), .B(control_reg2_0), .C(n70), .D(LSBFE_O), .Z(n8) );
  AO2 U60 ( .A(n66), .B(rx_data_reg[0]), .C(n65), .D(SPR_O[0]), .Z(n7) );
  AO6 U61 ( .A(n8), .B(n7), .C(n101), .Z(N62) );
  AO2 U62 ( .A(n63), .B(control_reg2[2]), .C(n70), .D(CPHA_O), .Z(n10) );
  AO2 U63 ( .A(n66), .B(rx_data_reg[2]), .C(n65), .D(SPR_O[2]), .Z(n9) );
  AO6 U64 ( .A(n10), .B(n9), .C(n101), .Z(N64) );
  AO4 U65 ( .A(n104), .B(PWDATA_I[4]), .C(MSTR_O), .D(n105), .Z(n11) );
  AO4 U66 ( .A(n106), .B(PWDATA_I[0]), .C(control_reg2_0), .D(n107), .Z(n13)
         );
  AO4 U67 ( .A(n104), .B(PWDATA_I[3]), .C(CPOL_O), .D(n105), .Z(n14) );
  AO4 U68 ( .A(n104), .B(PWDATA_I[2]), .C(CPHA_O), .D(n105), .Z(n15) );
  AO4 U69 ( .A(n106), .B(PWDATA_I[3]), .C(control_reg2[3]), .D(n107), .Z(n16)
         );
  AO4 U70 ( .A(n106), .B(PWDATA_I[2]), .C(control_reg2[2]), .D(n107), .Z(n17)
         );
  AO4 U71 ( .A(n106), .B(PWDATA_I[7]), .C(control_reg2[7]), .D(n107), .Z(n18)
         );
  AO4 U72 ( .A(n106), .B(PWDATA_I[5]), .C(control_reg2[5]), .D(n107), .Z(n19)
         );
  AO4 U73 ( .A(n104), .B(PWDATA_I[7]), .C(control_reg1[7]), .D(n105), .Z(n20)
         );
  AO4 U74 ( .A(n104), .B(PWDATA_I[5]), .C(control_reg1[5]), .D(n105), .Z(n21)
         );
  AO4 U75 ( .A(n104), .B(PWDATA_I[0]), .C(LSBFE_O), .D(n105), .Z(n22) );
  AO4 U76 ( .A(n106), .B(PWDATA_I[4]), .C(control_reg2[4]), .D(n107), .Z(n23)
         );
  OR2P U77 ( .A(n97), .B(n24), .Z(n35) );
  ND2 U78 ( .A(SPR_O[1]), .B(n35), .Z(n26) );
  ND2 U79 ( .A(n126), .B(PWDATA_I[1]), .Z(n25) );
  ND2 U80 ( .A(n26), .B(n25), .Z(n137) );
  ND2 U81 ( .A(SPR_O[2]), .B(n35), .Z(n28) );
  ND2 U82 ( .A(n126), .B(PWDATA_I[2]), .Z(n27) );
  ND2 U83 ( .A(n28), .B(n27), .Z(n138) );
  ND2 U84 ( .A(SPPR_O[0]), .B(n35), .Z(n30) );
  ND2 U85 ( .A(n126), .B(PWDATA_I[4]), .Z(n29) );
  ND2 U86 ( .A(n30), .B(n29), .Z(n140) );
  ND2 U87 ( .A(SPR_O[0]), .B(n35), .Z(n32) );
  ND2 U88 ( .A(n126), .B(PWDATA_I[0]), .Z(n31) );
  ND2 U89 ( .A(n32), .B(n31), .Z(n144) );
  AO4 U90 ( .A(n35), .B(PWDATA_I[5]), .C(SPPR_O[1]), .D(n126), .Z(n33) );
  AO4 U91 ( .A(n35), .B(PWDATA_I[3]), .C(br_reg_3), .D(n126), .Z(n34) );
  AO4 U92 ( .A(n35), .B(PWDATA_I[7]), .C(\br_reg[7] ), .D(n126), .Z(n36) );
  AO4 U93 ( .A(n98), .B(PWDATA_I[2]), .C(tx_data_reg[2]), .D(n185), .Z(n37) );
  AO4 U94 ( .A(n98), .B(PWDATA_I[0]), .C(tx_data_reg[0]), .D(n185), .Z(n38) );
  AO4 U95 ( .A(n98), .B(PWDATA_I[5]), .C(tx_data_reg[5]), .D(n185), .Z(n39) );
  AO4 U96 ( .A(n98), .B(PWDATA_I[3]), .C(tx_data_reg[3]), .D(n185), .Z(n40) );
  AO4 U97 ( .A(n98), .B(PWDATA_I[4]), .C(tx_data_reg[4]), .D(n185), .Z(n41) );
  AO4 U98 ( .A(n98), .B(PWDATA_I[7]), .C(tx_data_reg[7]), .D(n185), .Z(n42) );
  ND2 U99 ( .A(control_reg1[5]), .B(\status_reg[5] ), .Z(n46) );
  AO6 U100 ( .A(control_reg1_1), .B(MSTR_O), .C(SS_I), .Z(n43) );
  AO3 U101 ( .A(control_reg1_1), .B(MSTR_O), .C(control_reg2[4]), .D(n43), .Z(
        n53) );
  ND2 U102 ( .A(n188), .B(n53), .Z(n44) );
  ND2 U103 ( .A(control_reg1[7]), .B(n44), .Z(n45) );
  ND2 U104 ( .A(n46), .B(n45), .Z(SPI_INTERRUPT_RQST_O) );
  NR2 U105 ( .A(SS_I), .B(n97), .Z(PSLVERR_O) );
  AO2 U106 ( .A(n66), .B(rx_data_reg[3]), .C(n65), .D(br_reg_3), .Z(n48) );
  AO2 U107 ( .A(n63), .B(control_reg2[3]), .C(n70), .D(CPOL_O), .Z(n47) );
  AO6 U108 ( .A(n48), .B(n47), .C(n101), .Z(N65) );
  NR2 U109 ( .A(n50), .B(n49), .Z(n64) );
  AO2 U110 ( .A(control_reg2[4]), .B(n63), .C(MSTR_O), .D(n70), .Z(n52) );
  AO2 U111 ( .A(n66), .B(rx_data_reg[4]), .C(SPPR_O[0]), .D(n65), .Z(n51) );
  AO3 U112 ( .A(n54), .B(n53), .C(n52), .D(n51), .Z(n55) );
  NR2 U113 ( .A(n101), .B(n56), .Z(N66) );
  AO2 U114 ( .A(n64), .B(\status_reg[5] ), .C(n63), .D(control_reg2[5]), .Z(
        n58) );
  AO2 U115 ( .A(n66), .B(rx_data_reg[5]), .C(n65), .D(SPPR_O[1]), .Z(n57) );
  ND2 U116 ( .A(n58), .B(n57), .Z(n59) );
  AO6 U117 ( .A(control_reg1[5]), .B(n70), .C(n59), .Z(n60) );
  NR2 U118 ( .A(n60), .B(n101), .Z(N67) );
  AO2 U119 ( .A(n66), .B(rx_data_reg[6]), .C(n65), .D(SPPR_O[2]), .Z(n62) );
  AO2 U120 ( .A(n63), .B(control_reg2[6]), .C(n70), .D(control_reg1[6]), .Z(
        n61) );
  AO6 U121 ( .A(n62), .B(n61), .C(n101), .Z(N68) );
  AO2 U122 ( .A(n64), .B(status_reg_7), .C(n63), .D(control_reg2[7]), .Z(n68)
         );
  AO2 U123 ( .A(n66), .B(rx_data_reg[7]), .C(n65), .D(\br_reg[7] ), .Z(n67) );
  ND2 U124 ( .A(n68), .B(n67), .Z(n69) );
  AO6 U125 ( .A(control_reg1[7]), .B(n70), .C(n69), .Z(n71) );
  NR2 U126 ( .A(n71), .B(n101), .Z(N69) );
  NR2 U127 ( .A(APB_state[0]), .B(n72), .Z(n73) );
  EON1 U128 ( .A(n73), .B(n189), .C(n72), .D(PSEL_I), .Z(n184) );
  ND2 U129 ( .A(APB_state[1]), .B(APB_state[0]), .Z(n75) );
  AO3 U130 ( .A(APB_state[1]), .B(APB_state[0]), .C(PSEL_I), .D(PENABLE_I),
        .Z(n74) );
  ND2 U131 ( .A(n75), .B(n74), .Z(n183) );
  NR2 U132 ( .A(n190), .B(n186), .Z(n76) );
  ND2 U133 ( .A(n187), .B(n76), .Z(n77) );
  AO2 U134 ( .A(n190), .B(n186), .C(n191), .D(n77), .Z(n182) );
  AO2 U135 ( .A(n186), .B(control_reg1[6]), .C(SPISWAI_O), .D(n78), .Z(n181)
         );
  ND2 U136 ( .A(n185), .B(SEND_DATA_O), .Z(n79) );
  ND2 U137 ( .A(n100), .B(n79), .Z(n180) );
  ND2 U138 ( .A(MOSI_DATA_O[0]), .B(n100), .Z(n81) );
  IVP U139 ( .A(n100), .Z(n94) );
  ND2 U140 ( .A(n94), .B(tx_data_reg[0]), .Z(n80) );
  ND2 U141 ( .A(n81), .B(n80), .Z(n179) );
  ND2 U142 ( .A(MOSI_DATA_O[7]), .B(n100), .Z(n83) );
  ND2 U143 ( .A(n94), .B(tx_data_reg[7]), .Z(n82) );
  ND2 U144 ( .A(n83), .B(n82), .Z(n178) );
  ND2 U145 ( .A(MOSI_DATA_O[6]), .B(n100), .Z(n85) );
  ND2 U146 ( .A(n94), .B(tx_data_reg[6]), .Z(n84) );
  ND2 U147 ( .A(n85), .B(n84), .Z(n177) );
  ND2 U148 ( .A(MOSI_DATA_O[5]), .B(n100), .Z(n87) );
  ND2 U149 ( .A(n94), .B(tx_data_reg[5]), .Z(n86) );
  ND2 U150 ( .A(n87), .B(n86), .Z(n176) );
  ND2 U151 ( .A(MOSI_DATA_O[4]), .B(n100), .Z(n89) );
  ND2 U152 ( .A(n94), .B(tx_data_reg[4]), .Z(n88) );
  ND2 U153 ( .A(n89), .B(n88), .Z(n175) );
  ND2 U154 ( .A(MOSI_DATA_O[3]), .B(n100), .Z(n91) );
  ND2 U155 ( .A(n94), .B(tx_data_reg[3]), .Z(n90) );
  ND2 U156 ( .A(n91), .B(n90), .Z(n174) );
  ND2 U157 ( .A(MOSI_DATA_O[2]), .B(n100), .Z(n93) );
  ND2 U158 ( .A(n94), .B(tx_data_reg[2]), .Z(n92) );
  ND2 U159 ( .A(n93), .B(n92), .Z(n173) );
  ND2 U160 ( .A(MOSI_DATA_O[1]), .B(n100), .Z(n96) );
  ND2 U161 ( .A(n94), .B(tx_data_reg[1]), .Z(n95) );
  ND2 U162 ( .A(n96), .B(n95), .Z(n172) );
  EON1 U163 ( .A(n102), .B(n97), .C(n100), .D(dr_pending), .Z(n171) );
  ND2 U164 ( .A(\status_reg[5] ), .B(n98), .Z(n99) );
  ND2 U165 ( .A(n100), .B(n99), .Z(n170) );
  NR2 U166 ( .A(n102), .B(n101), .Z(n103) );
  AO7 U167 ( .A(n188), .B(n103), .C(n122), .Z(n169) );
  AO2 U168 ( .A(n105), .B(n127), .C(n187), .D(n104), .Z(n166) );
  EO1 U169 ( .A(n105), .B(n128), .C(control_reg1_1), .D(n105), .Z(n161) );
  EO1 U170 ( .A(n107), .B(n127), .C(control_reg2[6]), .D(n107), .Z(n158) );
  AO2 U171 ( .A(n107), .B(n128), .C(n190), .D(n106), .Z(n153) );
  ND2 U172 ( .A(rx_data_reg[0]), .B(n122), .Z(n109) );
  ND2 U173 ( .A(n123), .B(MISO_DATA_I[0]), .Z(n108) );
  ND2 U174 ( .A(n109), .B(n108), .Z(n152) );
  ND2 U175 ( .A(rx_data_reg[7]), .B(n122), .Z(n111) );
  ND2 U176 ( .A(n123), .B(MISO_DATA_I[7]), .Z(n110) );
  ND2 U177 ( .A(n111), .B(n110), .Z(n151) );
  ND2 U178 ( .A(rx_data_reg[6]), .B(n122), .Z(n113) );
  ND2 U179 ( .A(n123), .B(MISO_DATA_I[6]), .Z(n112) );
  ND2 U180 ( .A(n113), .B(n112), .Z(n150) );
  ND2 U181 ( .A(rx_data_reg[5]), .B(n122), .Z(n115) );
  ND2 U182 ( .A(n123), .B(MISO_DATA_I[5]), .Z(n114) );
  ND2 U183 ( .A(n115), .B(n114), .Z(n149) );
  ND2 U184 ( .A(rx_data_reg[4]), .B(n122), .Z(n117) );
  ND2 U185 ( .A(n123), .B(MISO_DATA_I[4]), .Z(n116) );
  ND2 U186 ( .A(n117), .B(n116), .Z(n148) );
  ND2 U187 ( .A(rx_data_reg[3]), .B(n122), .Z(n119) );
  ND2 U188 ( .A(n123), .B(MISO_DATA_I[3]), .Z(n118) );
  ND2 U189 ( .A(n119), .B(n118), .Z(n147) );
  ND2 U190 ( .A(rx_data_reg[2]), .B(n122), .Z(n121) );
  ND2 U191 ( .A(n123), .B(MISO_DATA_I[2]), .Z(n120) );
  ND2 U192 ( .A(n121), .B(n120), .Z(n146) );
  ND2 U193 ( .A(rx_data_reg[1]), .B(n122), .Z(n125) );
  ND2 U194 ( .A(n123), .B(MISO_DATA_I[1]), .Z(n124) );
  ND2 U195 ( .A(n125), .B(n124), .Z(n145) );
  EO1 U196 ( .A(n126), .B(n127), .C(SPPR_O[2]), .D(n126), .Z(n142) );
  EO1 U197 ( .A(n185), .B(n127), .C(tx_data_reg[6]), .D(n185), .Z(n134) );
  EO1 U198 ( .A(n185), .B(n128), .C(tx_data_reg[1]), .D(n185), .Z(n129) );
endmodule


module BAUD_GENERATOR ( PCLK, PRESETn, SPI_MODE_I, SPISWAI_I, SPPR_I, SPR_I,
        CPOL_I, CPHA_I, SS_I, SCLK_O, MISO_RCV_SCLKP_O, MISO_RCV_SCLKN_O,
        MOSI_SEND_SCLKP_O, MOSI_SEND_SCLKN_O, BAUD_RATE_DIV_O );
  input [1:0] SPI_MODE_I;
  input [2:0] SPPR_I;
  input [2:0] SPR_I;
  output [11:0] BAUD_RATE_DIV_O;
  input PCLK, PRESETn, SPISWAI_I, CPOL_I, CPHA_I, SS_I;
  output SCLK_O, MISO_RCV_SCLKP_O, MISO_RCV_SCLKN_O, MOSI_SEND_SCLKP_O,
         MOSI_SEND_SCLKN_O;
  wire   n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n112, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n111, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288;
  wire   [11:0] count;

  FD3 SCLK_O_reg ( .D(n98), .CP(PCLK), .CD(n82), .SD(n83), .Q(SCLK_O) );
  FD2 \active_BRD_reg[11]  ( .D(n110), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[11]) );
  FD2 \active_BRD_reg[10]  ( .D(n109), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[10]), .QN(n271) );
  FD2 \active_BRD_reg[9]  ( .D(n108), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[9]) );
  FD2 \active_BRD_reg[8]  ( .D(n107), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[8]), .QN(n270) );
  FD2 \active_BRD_reg[7]  ( .D(n106), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[7]) );
  FD2 \active_BRD_reg[6]  ( .D(n105), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[6]), .QN(n281) );
  FD2 \active_BRD_reg[5]  ( .D(n104), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[5]), .QN(n269) );
  FD2 \active_BRD_reg[4]  ( .D(n103), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[4]), .QN(n266) );
  FD2 \active_BRD_reg[3]  ( .D(n102), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[3]), .QN(n273) );
  FD2 \active_BRD_reg[2]  ( .D(n101), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[2]), .QN(n268) );
  FD2 \active_BRD_reg[1]  ( .D(n100), .CP(PCLK), .CD(PRESETn), .Q(
        BAUD_RATE_DIV_O[1]), .QN(n272) );
  FD2 \count_reg[11]  ( .D(n88), .CP(PCLK), .CD(PRESETn), .Q(count[11]), .QN(
        n284) );
  FD2 \count_reg[10]  ( .D(n89), .CP(PCLK), .CD(PRESETn), .Q(count[10]), .QN(
        n275) );
  FD2 \count_reg[9]  ( .D(n90), .CP(PCLK), .CD(PRESETn), .Q(count[9]) );
  FD2 \count_reg[8]  ( .D(n91), .CP(PCLK), .CD(PRESETn), .Q(count[8]), .QN(
        n283) );
  FD2 \count_reg[7]  ( .D(n92), .CP(PCLK), .CD(PRESETn), .Q(count[7]), .QN(
        n279) );
  FD2 \count_reg[6]  ( .D(n93), .CP(PCLK), .CD(PRESETn), .Q(count[6]), .QN(
        n282) );
  FD2 \count_reg[5]  ( .D(n94), .CP(PCLK), .CD(PRESETn), .Q(count[5]), .QN(
        n277) );
  FD2 \count_reg[4]  ( .D(n95), .CP(PCLK), .CD(PRESETn), .Q(count[4]), .QN(
        n274) );
  FD2 \count_reg[3]  ( .D(n96), .CP(PCLK), .CD(PRESETn), .Q(count[3]), .QN(
        n276) );
  FD2 \count_reg[2]  ( .D(n97), .CP(PCLK), .CD(PRESETn), .Q(count[2]), .QN(
        n278) );
  FD2 \count_reg[1]  ( .D(n99), .CP(PCLK), .CD(PRESETn), .Q(count[1]), .QN(
        n267) );
  FD2 \count_reg[0]  ( .D(n112), .CP(PCLK), .CD(PRESETn), .Q(count[0]), .QN(
        n280) );
  FD2 MOSI_SEND_SCLKP_O_reg ( .D(n87), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_SEND_SCLKP_O), .QN(n285) );
  FD2 MISO_RCV_SCLKP_O_reg ( .D(n86), .CP(PCLK), .CD(PRESETn), .Q(
        MISO_RCV_SCLKP_O), .QN(n286) );
  FD2 MOSI_SEND_SCLKN_O_reg ( .D(n85), .CP(PCLK), .CD(PRESETn), .Q(
        MOSI_SEND_SCLKN_O), .QN(n287) );
  FD2 MISO_RCV_SCLKN_O_reg ( .D(n84), .CP(PCLK), .CD(PRESETn), .Q(
        MISO_RCV_SCLKN_O), .QN(n288) );
  FA1A U3 ( .A(n71), .B(n70), .CI(n69), .CO(n118), .S(n76) );
  FA1A U4 ( .A(n58), .B(n57), .CI(n56), .CO(n77), .S(n64) );
  FA1A U5 ( .A(n48), .B(n47), .CI(n46), .CO(n65), .S(n51) );
  FA1A U6 ( .A(n37), .B(n36), .CI(n35), .CO(n52), .S(n41) );
  FA1A U7 ( .A(n21), .B(n20), .CI(n19), .CO(n29), .S(n2) );
  HA1 U8 ( .A(n18), .B(n17), .CO(n30), .S(n19) );
  IVDA U9 ( .A(SS_I), .Y(n255), .Z(n170) );
  NR2 U10 ( .A(n205), .B(n204), .Z(n206) );
  IVA U11 ( .A(n202), .Z(n200) );
  IVP U12 ( .A(n207), .Z(n203) );
  ND2 U13 ( .A(n261), .B(n173), .Z(n207) );
  AO3 U14 ( .A(count[8]), .B(n166), .C(n165), .D(n164), .Z(n173) );
  ND4 U15 ( .A(n250), .B(n249), .C(n248), .D(n247), .Z(n251) );
  AO6 U16 ( .A(BAUD_RATE_DIV_O[9]), .B(n129), .C(n162), .Z(n166) );
  NR2 U17 ( .A(BAUD_RATE_DIV_O[9]), .B(n129), .Z(n162) );
  IVA U18 ( .A(n240), .Z(n215) );
  NR2 U19 ( .A(n233), .B(BAUD_RATE_DIV_O[8]), .Z(n240) );
  IVA U20 ( .A(n7), .Z(n21) );
  ND2 U21 ( .A(n141), .B(n270), .Z(n129) );
  NR2 U22 ( .A(BAUD_RATE_DIV_O[7]), .B(n142), .Z(n141) );
  MUX21L U23 ( .A(n28), .B(n15), .S(n62), .Z(n17) );
  MUX21L U24 ( .A(n15), .B(n12), .S(n62), .Z(n5) );
  ND2 U25 ( .A(n140), .B(n281), .Z(n142) );
  MUX21L U26 ( .A(n115), .B(n73), .S(n62), .Z(n70) );
  NR2 U27 ( .A(n73), .B(n74), .Z(n69) );
  MUX21L U28 ( .A(n73), .B(n59), .S(n62), .Z(n57) );
  IVA U29 ( .A(n226), .Z(n154) );
  AN3 U30 ( .A(n269), .B(n266), .C(n145), .Z(n140) );
  MUX21L U31 ( .A(n59), .B(n49), .S(n62), .Z(n47) );
  MUX21L U32 ( .A(n49), .B(n38), .S(n62), .Z(n36) );
  MUX21L U33 ( .A(n38), .B(n28), .S(n62), .Z(n26) );
  IVA U34 ( .A(n261), .Z(n256) );
  NR2 U35 ( .A(n115), .B(n114), .Z(n123) );
  NR2 U36 ( .A(n73), .B(n114), .Z(n111) );
  IVA U37 ( .A(n145), .Z(n151) );
  IVA U38 ( .A(n239), .Z(n224) );
  IVA U39 ( .A(n257), .Z(n258) );
  IVA U40 ( .A(n219), .Z(n144) );
  IVA U41 ( .A(n216), .Z(n212) );
  NR2 U42 ( .A(n153), .B(n152), .Z(n226) );
  NR2 U43 ( .A(n146), .B(BAUD_RATE_DIV_O[3]), .Z(n145) );
  EO U44 ( .A(CPOL_I), .B(CPHA_I), .Z(n257) );
  IVP U45 ( .A(SPPR_I[2]), .Z(n114) );
  IVA U46 ( .A(SPR_I[0]), .Z(n61) );
  IVP U47 ( .A(SPPR_I[1]), .Z(n74) );
  B2I U48 ( .A(SPPR_I[0]), .Z1(n72), .Z2(n62) );
  IVA U49 ( .A(SPR_I[1]), .Z(n39) );
  IVA U50 ( .A(SPR_I[2]), .Z(n16) );
  AO7 U51 ( .A(count[2]), .B(n148), .C(n147), .Z(n149) );
  IVP U52 ( .A(PRESETn), .Z(n128) );
  ND2 U53 ( .A(BAUD_RATE_DIV_O[3]), .B(n255), .Z(n4) );
  ND2 U54 ( .A(n39), .B(n16), .Z(n1) );
  OR2P U55 ( .A(SPR_I[0]), .B(n1), .Z(n12) );
  NR2 U56 ( .A(n12), .B(n74), .Z(n6) );
  OR2P U57 ( .A(n61), .B(n1), .Z(n15) );
  ND2 U58 ( .A(n6), .B(n5), .Z(n7) );
  NR2 U59 ( .A(n12), .B(n114), .Z(n20) );
  NR2 U60 ( .A(n15), .B(n74), .Z(n18) );
  ND3 U61 ( .A(SPR_I[1]), .B(n61), .C(n16), .Z(n28) );
  ND2 U62 ( .A(n170), .B(n2), .Z(n3) );
  ND2 U63 ( .A(n4), .B(n3), .Z(n102) );
  ND2 U64 ( .A(BAUD_RATE_DIV_O[2]), .B(n255), .Z(n11) );
  OR2P U65 ( .A(n6), .B(n5), .Z(n8) );
  AN2P U66 ( .A(n8), .B(n7), .Z(n9) );
  ND2 U67 ( .A(n170), .B(n9), .Z(n10) );
  ND2 U68 ( .A(n11), .B(n10), .Z(n101) );
  NR2 U69 ( .A(n12), .B(n62), .Z(n13) );
  ND2 U70 ( .A(n170), .B(n13), .Z(n14) );
  AO7 U71 ( .A(SS_I), .B(n272), .C(n14), .Z(n100) );
  ND2 U72 ( .A(BAUD_RATE_DIV_O[4]), .B(n255), .Z(n24) );
  NR2 U73 ( .A(n15), .B(n114), .Z(n27) );
  ND3 U74 ( .A(SPR_I[1]), .B(SPR_I[0]), .C(n16), .Z(n38) );
  NR2 U75 ( .A(n28), .B(n74), .Z(n25) );
  ND2 U76 ( .A(SS_I), .B(n22), .Z(n23) );
  ND2 U77 ( .A(n24), .B(n23), .Z(n103) );
  ND2 U78 ( .A(BAUD_RATE_DIV_O[5]), .B(n255), .Z(n34) );
  FA1A U79 ( .A(n27), .B(n26), .CI(n25), .CO(n42), .S(n31) );
  NR2 U80 ( .A(n28), .B(n114), .Z(n37) );
  ND3 U81 ( .A(SPR_I[2]), .B(n61), .C(n39), .Z(n49) );
  NR2 U82 ( .A(n38), .B(n74), .Z(n35) );
  FA1A U83 ( .A(n31), .B(n30), .CI(n29), .CO(n40), .S(n22) );
  ND2 U84 ( .A(n170), .B(n32), .Z(n33) );
  ND2 U85 ( .A(n34), .B(n33), .Z(n104) );
  ND2 U86 ( .A(BAUD_RATE_DIV_O[6]), .B(n255), .Z(n45) );
  NR2 U87 ( .A(n38), .B(n114), .Z(n48) );
  ND3 U88 ( .A(SPR_I[0]), .B(SPR_I[2]), .C(n39), .Z(n59) );
  NR2 U89 ( .A(n49), .B(n74), .Z(n46) );
  FA1A U90 ( .A(n42), .B(n41), .CI(n40), .CO(n50), .S(n32) );
  ND2 U91 ( .A(n170), .B(n43), .Z(n44) );
  ND2 U92 ( .A(n45), .B(n44), .Z(n105) );
  ND2 U93 ( .A(BAUD_RATE_DIV_O[7]), .B(n255), .Z(n55) );
  NR2 U94 ( .A(n49), .B(n114), .Z(n58) );
  ND2 U95 ( .A(SPR_I[1]), .B(SPR_I[2]), .Z(n60) );
  OR2P U96 ( .A(SPR_I[0]), .B(n60), .Z(n73) );
  NR2 U97 ( .A(n59), .B(n74), .Z(n56) );
  FA1A U98 ( .A(n52), .B(n51), .CI(n50), .CO(n63), .S(n43) );
  ND2 U99 ( .A(n170), .B(n53), .Z(n54) );
  ND2 U100 ( .A(n55), .B(n54), .Z(n106) );
  ND2 U101 ( .A(BAUD_RATE_DIV_O[8]), .B(n255), .Z(n68) );
  NR2 U102 ( .A(n59), .B(n114), .Z(n71) );
  OR2P U103 ( .A(n61), .B(n60), .Z(n115) );
  FA1A U104 ( .A(n65), .B(n64), .CI(n63), .CO(n75), .S(n53) );
  ND2 U105 ( .A(n170), .B(n66), .Z(n67) );
  ND2 U106 ( .A(n68), .B(n67), .Z(n107) );
  ND2 U107 ( .A(BAUD_RATE_DIV_O[9]), .B(n255), .Z(n80) );
  NR2 U108 ( .A(n115), .B(n72), .Z(n113) );
  NR2 U109 ( .A(n115), .B(n74), .Z(n81) );
  FA1A U110 ( .A(n77), .B(n76), .CI(n75), .CO(n116), .S(n66) );
  ND2 U111 ( .A(n170), .B(n78), .Z(n79) );
  ND2 U112 ( .A(n80), .B(n79), .Z(n108) );
  ND2 U113 ( .A(BAUD_RATE_DIV_O[10]), .B(n255), .Z(n121) );
  FA1A U114 ( .A(n113), .B(n111), .CI(n81), .CO(n124), .S(n117) );
  FA1A U115 ( .A(n118), .B(n117), .CI(n116), .CO(n122), .S(n78) );
  ND2 U116 ( .A(n170), .B(n119), .Z(n120) );
  ND2 U117 ( .A(n121), .B(n120), .Z(n109) );
  ND2 U118 ( .A(BAUD_RATE_DIV_O[11]), .B(n255), .Z(n127) );
  FA1A U119 ( .A(n124), .B(n123), .CI(n122), .CO(n125), .S(n119) );
  ND2 U120 ( .A(n170), .B(n125), .Z(n126) );
  ND2 U121 ( .A(n127), .B(n126), .Z(n110) );
  ND2 U122 ( .A(CPOL_I), .B(n128), .Z(n83) );
  OR2P U123 ( .A(CPOL_I), .B(PRESETn), .Z(n82) );
  AO1P U124 ( .A(SPISWAI_I), .B(SPI_MODE_I[0]), .C(SPI_MODE_I[1]), .D(n170),
        .Z(n261) );
  ND2 U125 ( .A(n255), .B(n256), .Z(n198) );
  ND2 U126 ( .A(n268), .B(n272), .Z(n146) );
  NR2 U127 ( .A(count[9]), .B(n162), .Z(n133) );
  AN2P U128 ( .A(BAUD_RATE_DIV_O[11]), .B(n275), .Z(n239) );
  ND2 U129 ( .A(count[9]), .B(n162), .Z(n131) );
  NR2 U130 ( .A(n224), .B(n131), .Z(n130) );
  NR2 U131 ( .A(n133), .B(n130), .Z(n134) );
  ND2 U132 ( .A(n131), .B(BAUD_RATE_DIV_O[10]), .Z(n132) );
  AO4 U133 ( .A(n134), .B(BAUD_RATE_DIV_O[10]), .C(n133), .D(n132), .Z(n165)
         );
  AO2 U134 ( .A(BAUD_RATE_DIV_O[6]), .B(n277), .C(count[5]), .D(n281), .Z(n230) );
  AO2 U135 ( .A(BAUD_RATE_DIV_O[8]), .B(n279), .C(count[7]), .D(n270), .Z(n234) );
  AO4 U136 ( .A(n266), .B(count[3]), .C(n276), .D(BAUD_RATE_DIV_O[4]), .Z(n216) );
  AO4 U137 ( .A(n269), .B(n274), .C(count[4]), .D(BAUD_RATE_DIV_O[5]), .Z(n219) );
  NR2 U138 ( .A(BAUD_RATE_DIV_O[4]), .B(n144), .Z(n135) );
  AO7 U139 ( .A(n212), .B(n135), .C(n145), .Z(n137) );
  ND2 U140 ( .A(n141), .B(n234), .Z(n136) );
  AO3 U141 ( .A(n141), .B(n234), .C(n137), .D(n136), .Z(n139) );
  NR2 U142 ( .A(n140), .B(n230), .Z(n138) );
  AO1P U143 ( .A(n140), .B(n230), .C(n139), .D(n138), .Z(n161) );
  AO6 U144 ( .A(BAUD_RATE_DIV_O[7]), .B(n142), .C(n141), .Z(n159) );
  NR2 U145 ( .A(BAUD_RATE_DIV_O[11]), .B(n275), .Z(n143) );
  AO1P U146 ( .A(BAUD_RATE_DIV_O[10]), .B(n239), .C(count[11]), .D(n143), .Z(
        n250) );
  AO2 U147 ( .A(BAUD_RATE_DIV_O[2]), .B(n267), .C(count[1]), .D(n268), .Z(n153) );
  ND2 U148 ( .A(BAUD_RATE_DIV_O[1]), .B(n280), .Z(n225) );
  AO2 U149 ( .A(BAUD_RATE_DIV_O[4]), .B(n144), .C(n153), .D(n225), .Z(n156) );
  ND2 U150 ( .A(n212), .B(n219), .Z(n150) );
  ND2 U151 ( .A(BAUD_RATE_DIV_O[3]), .B(n146), .Z(n148) );
  ND2 U152 ( .A(count[2]), .B(n148), .Z(n147) );
  AO4 U153 ( .A(n151), .B(n278), .C(n150), .D(n149), .Z(n155) );
  NR2 U154 ( .A(n280), .B(BAUD_RATE_DIV_O[1]), .Z(n152) );
  ND4 U155 ( .A(n250), .B(n156), .C(n155), .D(n154), .Z(n158) );
  NR2 U156 ( .A(count[6]), .B(n159), .Z(n157) );
  AO1P U157 ( .A(count[6]), .B(n159), .C(n158), .D(n157), .Z(n160) );
  AO3 U158 ( .A(n162), .B(n224), .C(n161), .D(n160), .Z(n163) );
  AO6 U159 ( .A(count[8]), .B(n166), .C(n163), .Z(n164) );
  ND2 U160 ( .A(n203), .B(n280), .Z(n167) );
  AO7 U161 ( .A(n198), .B(n280), .C(n167), .Z(n112) );
  NR2 U162 ( .A(count[1]), .B(n207), .Z(n175) );
  ND2 U163 ( .A(count[0]), .B(n175), .Z(n169) );
  ND2 U164 ( .A(n198), .B(n167), .Z(n174) );
  ND2 U165 ( .A(count[1]), .B(n174), .Z(n168) );
  ND2 U166 ( .A(n169), .B(n168), .Z(n99) );
  OR2P U167 ( .A(n256), .B(SCLK_O), .Z(n260) );
  AO3 U168 ( .A(n256), .B(n173), .C(SCLK_O), .D(n255), .Z(n172) );
  ND2 U169 ( .A(n170), .B(CPOL_I), .Z(n171) );
  AO3 U170 ( .A(n173), .B(n260), .C(n172), .D(n171), .Z(n98) );
  NR2 U171 ( .A(n267), .B(n280), .Z(n178) );
  ND2 U172 ( .A(n178), .B(n278), .Z(n177) );
  NR2 U173 ( .A(n175), .B(n174), .Z(n176) );
  AO4 U174 ( .A(n207), .B(n177), .C(n176), .D(n278), .Z(n97) );
  ND2 U175 ( .A(count[2]), .B(n178), .Z(n179) );
  AO2 U176 ( .A(n203), .B(n179), .C(n255), .D(n256), .Z(n182) );
  ND2 U177 ( .A(n276), .B(n203), .Z(n180) );
  AO4 U178 ( .A(n182), .B(n276), .C(n179), .D(n180), .Z(n96) );
  NR2 U179 ( .A(n276), .B(n179), .Z(n184) );
  ND2 U180 ( .A(n203), .B(n184), .Z(n183) );
  AN2P U181 ( .A(count[4]), .B(n180), .Z(n181) );
  AO2 U182 ( .A(n183), .B(n274), .C(n182), .D(n181), .Z(n95) );
  ND2 U183 ( .A(count[4]), .B(n184), .Z(n185) );
  AO2 U184 ( .A(n203), .B(n185), .C(n255), .D(n256), .Z(n188) );
  ND2 U185 ( .A(n277), .B(n203), .Z(n186) );
  AO4 U186 ( .A(n188), .B(n277), .C(n185), .D(n186), .Z(n94) );
  NR2 U187 ( .A(n277), .B(n185), .Z(n190) );
  ND2 U188 ( .A(n203), .B(n190), .Z(n189) );
  AN2P U189 ( .A(count[6]), .B(n186), .Z(n187) );
  AO2 U190 ( .A(n189), .B(n282), .C(n188), .D(n187), .Z(n93) );
  ND2 U191 ( .A(count[6]), .B(n190), .Z(n192) );
  ND2 U192 ( .A(n203), .B(n192), .Z(n191) );
  AN2P U193 ( .A(n198), .B(n191), .Z(n193) );
  ND2 U194 ( .A(n279), .B(n203), .Z(n194) );
  AO4 U195 ( .A(n193), .B(n279), .C(n192), .D(n194), .Z(n92) );
  NR2 U196 ( .A(n279), .B(n192), .Z(n197) );
  ND2 U197 ( .A(n197), .B(n283), .Z(n196) );
  AN2P U198 ( .A(n194), .B(n193), .Z(n195) );
  AO4 U199 ( .A(n207), .B(n196), .C(n195), .D(n283), .Z(n91) );
  NR2 U200 ( .A(count[9]), .B(n207), .Z(n202) );
  ND2 U201 ( .A(count[8]), .B(n197), .Z(n205) );
  ND2 U202 ( .A(n203), .B(n205), .Z(n199) );
  ND2 U203 ( .A(n199), .B(n198), .Z(n201) );
  EON1 U204 ( .A(n200), .B(n205), .C(n201), .D(count[9]), .Z(n90) );
  NR2 U205 ( .A(n202), .B(n201), .Z(n210) );
  ND2 U206 ( .A(count[9]), .B(n203), .Z(n204) );
  EO1 U207 ( .A(count[10]), .B(n210), .C(n206), .D(count[10]), .Z(n89) );
  ND2 U208 ( .A(count[10]), .B(n206), .Z(n211) );
  NR2 U209 ( .A(count[10]), .B(n207), .Z(n208) );
  NR2 U210 ( .A(n284), .B(n208), .Z(n209) );
  AO2 U211 ( .A(n211), .B(n284), .C(n210), .D(n209), .Z(n88) );
  ND2 U212 ( .A(n273), .B(n268), .Z(n254) );
  NR2 U213 ( .A(n273), .B(n268), .Z(n214) );
  ND2 U214 ( .A(n214), .B(n278), .Z(n213) );
  AO3 U215 ( .A(n214), .B(n278), .C(n213), .D(n212), .Z(n253) );
  NR2 U216 ( .A(n254), .B(BAUD_RATE_DIV_O[4]), .Z(n220) );
  AN2P U217 ( .A(n269), .B(n220), .Z(n231) );
  ND2 U218 ( .A(n231), .B(n281), .Z(n221) );
  OR2P U219 ( .A(BAUD_RATE_DIV_O[7]), .B(n221), .Z(n233) );
  NR2 U220 ( .A(BAUD_RATE_DIV_O[9]), .B(n215), .Z(n238) );
  AO1P U221 ( .A(count[2]), .B(n216), .C(BAUD_RATE_DIV_O[3]), .D(
        BAUD_RATE_DIV_O[2]), .Z(n218) );
  NR2 U222 ( .A(n220), .B(n219), .Z(n217) );
  AO1P U223 ( .A(n220), .B(n219), .C(n218), .D(n217), .Z(n223) );
  ND2 U224 ( .A(count[6]), .B(n221), .Z(n227) );
  AO3 U225 ( .A(count[6]), .B(n221), .C(BAUD_RATE_DIV_O[7]), .D(n227), .Z(n222) );
  AO3 U226 ( .A(n238), .B(n224), .C(n223), .D(n222), .Z(n252) );
  AO3 U227 ( .A(BAUD_RATE_DIV_O[7]), .B(n227), .C(n226), .D(n225), .Z(n229) );
  NR2 U228 ( .A(n231), .B(n230), .Z(n228) );
  AO1P U229 ( .A(n231), .B(n230), .C(n229), .D(n228), .Z(n249) );
  EO1 U230 ( .A(count[9]), .B(n271), .C(n271), .D(count[9]), .Z(n237) );
  NR2 U231 ( .A(n234), .B(n233), .Z(n232) );
  AO2 U232 ( .A(n234), .B(n233), .C(count[6]), .D(n232), .Z(n236) );
  NR2 U233 ( .A(n238), .B(n237), .Z(n235) );
  AO1P U234 ( .A(n238), .B(n237), .C(n236), .D(n235), .Z(n248) );
  NR2 U235 ( .A(count[8]), .B(n240), .Z(n245) );
  NR2 U236 ( .A(BAUD_RATE_DIV_O[10]), .B(n239), .Z(n241) );
  ND2 U237 ( .A(count[8]), .B(n240), .Z(n243) );
  NR2 U238 ( .A(n241), .B(n243), .Z(n242) );
  NR2 U239 ( .A(n245), .B(n242), .Z(n246) );
  ND2 U240 ( .A(n243), .B(BAUD_RATE_DIV_O[9]), .Z(n244) );
  AO4 U241 ( .A(n246), .B(BAUD_RATE_DIV_O[9]), .C(n245), .D(n244), .Z(n247) );
  AO1P U242 ( .A(n254), .B(n253), .C(n252), .D(n251), .Z(n259) );
  ND2 U243 ( .A(n257), .B(n259), .Z(n265) );
  AO7 U244 ( .A(n259), .B(n256), .C(n255), .Z(n263) );
  AO4 U245 ( .A(n260), .B(n265), .C(n263), .D(n285), .Z(n87) );
  ND2 U246 ( .A(n259), .B(n258), .Z(n262) );
  AO4 U247 ( .A(n260), .B(n262), .C(n263), .D(n286), .Z(n86) );
  ND2 U248 ( .A(n261), .B(SCLK_O), .Z(n264) );
  AO4 U249 ( .A(n263), .B(n287), .C(n262), .D(n264), .Z(n85) );
  AO4 U250 ( .A(n265), .B(n264), .C(n263), .D(n288), .Z(n84) );
endmodule


module SPI_SHIFT_REGISTER_WIDTH8 ( PCLK, PRESETn, CPOL_I, CPHA_I, SS_I,
        SEND_DATA_I, LSBFE_I, DATA_MOSI_I, MISO_I, RECEIVE_DATA_I,
        MISO_RCV_SCLKP_I, MISO_RCV_SCLKN_I, MOSI_SEND_SCLKP_I,
        MOSI_SEND_SCLKN_I, DATA_MISO_O, MOSI_O );
  input [7:0] DATA_MOSI_I;
  output [7:0] DATA_MISO_O;
  input PCLK, PRESETn, CPOL_I, CPHA_I, SS_I, SEND_DATA_I, LSBFE_I, MISO_I,
         RECEIVE_DATA_I, MISO_RCV_SCLKP_I, MISO_RCV_SCLKN_I, MOSI_SEND_SCLKP_I,
         MOSI_SEND_SCLKN_I;
  output MOSI_O;
  wire   n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n93, n94, n95, n96, n97, n98, n99, n100, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n92, n101, n102, n103, n104;
  wire   [7:0] Tx_shift_reg;
  wire   [7:0] Rx_shift_reg;
  wire   [3:0] bitcnt1;
  wire   [3:0] bitcnt2;

  FD1 \bitcnt2_reg[0]  ( .D(n99), .CP(PCLK), .Q(bitcnt2[0]) );
  FD1 \bitcnt2_reg[3]  ( .D(n96), .CP(PCLK), .Q(bitcnt2[3]) );
  FD1 \bitcnt2_reg[2]  ( .D(n97), .CP(PCLK), .QN(n102) );
  FD1 \bitcnt2_reg[1]  ( .D(n98), .CP(PCLK), .Q(bitcnt2[1]) );
  FD1 \bitcnt1_reg[0]  ( .D(n95), .CP(PCLK), .Q(bitcnt1[0]), .QN(n104) );
  FD1 \bitcnt1_reg[1]  ( .D(n94), .CP(PCLK), .Q(bitcnt1[1]), .QN(n103) );
  FD1 \bitcnt1_reg[2]  ( .D(n93), .CP(PCLK), .Q(bitcnt1[2]) );
  FD2 \Rx_shift_reg_reg[7]  ( .D(n77), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[7]) );
  FD2 \Rx_shift_reg_reg[6]  ( .D(n78), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[6]) );
  FD2 \Rx_shift_reg_reg[5]  ( .D(n79), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[5]) );
  FD2 \Rx_shift_reg_reg[4]  ( .D(n80), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[4]) );
  FD2 \Rx_shift_reg_reg[3]  ( .D(n81), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[3]) );
  FD2 \Rx_shift_reg_reg[2]  ( .D(n82), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[2]) );
  FD2 \Rx_shift_reg_reg[1]  ( .D(n83), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[1]) );
  FD2 \Rx_shift_reg_reg[0]  ( .D(n84), .CP(PCLK), .CD(PRESETn), .Q(
        Rx_shift_reg[0]) );
  FD2 \Tx_shift_reg_reg[0]  ( .D(n100), .CP(PCLK), .CD(PRESETn), .QN(n72) );
  FD2 \Tx_shift_reg_reg[1]  ( .D(n85), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[1]) );
  FD2 \Tx_shift_reg_reg[2]  ( .D(n86), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[2]), .QN(n73) );
  FD2 \Tx_shift_reg_reg[3]  ( .D(n87), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[3]), .QN(n92) );
  FD2 \Tx_shift_reg_reg[4]  ( .D(n88), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[4]), .QN(n76) );
  FD2 \Tx_shift_reg_reg[5]  ( .D(n89), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[5]), .QN(n75) );
  FD2 \Tx_shift_reg_reg[6]  ( .D(n90), .CP(PCLK), .CD(PRESETn), .Q(
        Tx_shift_reg[6]), .QN(n74) );
  FD2 \Tx_shift_reg_reg[7]  ( .D(n91), .CP(PCLK), .CD(PRESETn), .QN(n101) );
  NR2 U3 ( .A(n69), .B(n52), .Z(n67) );
  NR2 U4 ( .A(n69), .B(n51), .Z(n68) );
  IVA U5 ( .A(n11), .Z(n13) );
  NR2 U6 ( .A(n11), .B(n10), .Z(n18) );
  IVP U7 ( .A(n50), .Z(n69) );
  AO6 U8 ( .A(SS_I), .B(SEND_DATA_I), .C(n20), .Z(n45) );
  NR2 U9 ( .A(bitcnt2[3]), .B(n9), .Z(n50) );
  AO6 U10 ( .A(bitcnt1[2]), .B(n4), .C(n3), .Z(n20) );
  IVA U11 ( .A(n46), .Z(n52) );
  IVA U12 ( .A(n26), .Z(n4) );
  IVA U13 ( .A(n1), .Z(n2) );
  ND2 U14 ( .A(bitcnt1[1]), .B(bitcnt1[0]), .Z(n26) );
  EO U15 ( .A(CPHA_I), .B(CPOL_I), .Z(n1) );
  IVA U16 ( .A(LSBFE_I), .Z(n5) );
  AO2 U17 ( .A(LSBFE_I), .B(n72), .C(n101), .D(n5), .Z(MOSI_O) );
  AN2P U18 ( .A(Rx_shift_reg[0]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[0]) );
  AN2P U19 ( .A(Rx_shift_reg[1]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[1]) );
  AN2P U20 ( .A(Rx_shift_reg[2]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[2]) );
  AN2P U21 ( .A(Rx_shift_reg[3]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[3]) );
  AN2P U22 ( .A(Rx_shift_reg[4]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[4]) );
  AN2P U23 ( .A(Rx_shift_reg[5]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[5]) );
  AN2P U24 ( .A(Rx_shift_reg[6]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[6]) );
  AN2P U25 ( .A(Rx_shift_reg[7]), .B(RECEIVE_DATA_I), .Z(DATA_MISO_O[7]) );
  NR2 U26 ( .A(SS_I), .B(n1), .Z(n8) );
  NR2 U27 ( .A(SS_I), .B(n2), .Z(n7) );
  AO2 U28 ( .A(n8), .B(MOSI_SEND_SCLKN_I), .C(n7), .D(MOSI_SEND_SCLKP_I), .Z(
        n3) );
  NR2 U29 ( .A(n5), .B(SS_I), .Z(n29) );
  AO2 U30 ( .A(SS_I), .B(DATA_MOSI_I[0]), .C(n29), .D(Tx_shift_reg[1]), .Z(n6)
         );
  IVDA U31 ( .A(n45), .Y(n48) );
  AO2 U32 ( .A(n45), .B(n72), .C(n6), .D(n48), .Z(n100) );
  AO2 U33 ( .A(n8), .B(MISO_RCV_SCLKP_I), .C(n7), .D(MISO_RCV_SCLKN_I), .Z(n9)
         );
  AO7 U34 ( .A(SS_I), .B(n50), .C(PRESETn), .Z(n11) );
  NR2 U35 ( .A(SS_I), .B(bitcnt2[0]), .Z(n10) );
  NR2 U36 ( .A(n13), .B(bitcnt2[0]), .Z(n12) );
  NR2 U37 ( .A(n18), .B(n12), .Z(n99) );
  ND2 U38 ( .A(n13), .B(bitcnt2[0]), .Z(n14) );
  NR2 U39 ( .A(SS_I), .B(n14), .Z(n15) );
  EO1 U40 ( .A(bitcnt2[1]), .B(n18), .C(n15), .D(bitcnt2[1]), .Z(n98) );
  ND2 U41 ( .A(bitcnt2[1]), .B(n15), .Z(n19) );
  NR2 U42 ( .A(SS_I), .B(bitcnt2[1]), .Z(n16) );
  NR2 U43 ( .A(n102), .B(n16), .Z(n17) );
  AO2 U44 ( .A(n19), .B(n102), .C(n18), .D(n17), .Z(n97) );
  ND2 U45 ( .A(SS_I), .B(PRESETn), .Z(n25) );
  EON1 U46 ( .A(n102), .B(n19), .C(n25), .D(bitcnt2[3]), .Z(n96) );
  ND2 U47 ( .A(PRESETn), .B(n20), .Z(n27) );
  AO7 U48 ( .A(SS_I), .B(n20), .C(PRESETn), .Z(n22) );
  EO1 U49 ( .A(n27), .B(n104), .C(n104), .D(n22), .Z(n95) );
  NR2 U50 ( .A(SS_I), .B(bitcnt1[0]), .Z(n21) );
  NR2 U51 ( .A(n22), .B(n21), .Z(n24) );
  ND2 U52 ( .A(n24), .B(n103), .Z(n23) );
  AO4 U53 ( .A(n24), .B(n103), .C(SS_I), .D(n23), .Z(n94) );
  EON1 U54 ( .A(n27), .B(n26), .C(n25), .D(bitcnt1[2]), .Z(n93) );
  NR2 U55 ( .A(SS_I), .B(LSBFE_I), .Z(n46) );
  AO2 U56 ( .A(SS_I), .B(DATA_MOSI_I[7]), .C(n46), .D(Tx_shift_reg[6]), .Z(n28) );
  AO2 U57 ( .A(n45), .B(n101), .C(n28), .D(n48), .Z(n91) );
  AO2 U58 ( .A(SS_I), .B(DATA_MOSI_I[6]), .C(n46), .D(Tx_shift_reg[5]), .Z(n32) );
  IVP U59 ( .A(n29), .Z(n51) );
  NR2 U60 ( .A(n51), .B(n101), .Z(n30) );
  NR2 U61 ( .A(n45), .B(n30), .Z(n31) );
  AO2 U62 ( .A(n74), .B(n45), .C(n32), .D(n31), .Z(n90) );
  AO2 U63 ( .A(SS_I), .B(DATA_MOSI_I[5]), .C(n46), .D(Tx_shift_reg[4]), .Z(n35) );
  NR2 U64 ( .A(n51), .B(n74), .Z(n33) );
  NR2 U65 ( .A(n45), .B(n33), .Z(n34) );
  AO2 U66 ( .A(n75), .B(n45), .C(n35), .D(n34), .Z(n89) );
  AO2 U67 ( .A(SS_I), .B(DATA_MOSI_I[4]), .C(n46), .D(Tx_shift_reg[3]), .Z(n38) );
  NR2 U68 ( .A(n51), .B(n75), .Z(n36) );
  NR2 U69 ( .A(n45), .B(n36), .Z(n37) );
  AO2 U70 ( .A(n76), .B(n45), .C(n38), .D(n37), .Z(n88) );
  AO2 U71 ( .A(SS_I), .B(DATA_MOSI_I[3]), .C(n46), .D(Tx_shift_reg[2]), .Z(n41) );
  NR2 U72 ( .A(n51), .B(n76), .Z(n39) );
  NR2 U73 ( .A(n45), .B(n39), .Z(n40) );
  AO2 U74 ( .A(n92), .B(n45), .C(n41), .D(n40), .Z(n87) );
  AO2 U75 ( .A(SS_I), .B(DATA_MOSI_I[2]), .C(n46), .D(Tx_shift_reg[1]), .Z(n44) );
  NR2 U76 ( .A(n51), .B(n92), .Z(n42) );
  NR2 U77 ( .A(n45), .B(n42), .Z(n43) );
  AO2 U78 ( .A(n73), .B(n45), .C(n44), .D(n43), .Z(n86) );
  AO4 U79 ( .A(n51), .B(n73), .C(n52), .D(n72), .Z(n47) );
  AO6 U80 ( .A(SS_I), .B(DATA_MOSI_I[1]), .C(n47), .Z(n49) );
  EO1 U81 ( .A(n49), .B(n48), .C(n48), .D(Tx_shift_reg[1]), .Z(n85) );
  AO2 U82 ( .A(n68), .B(Rx_shift_reg[1]), .C(MISO_I), .D(n67), .Z(n54) );
  ND2 U83 ( .A(Rx_shift_reg[0]), .B(n69), .Z(n53) );
  ND2 U84 ( .A(n54), .B(n53), .Z(n84) );
  AO2 U85 ( .A(Rx_shift_reg[0]), .B(n67), .C(n68), .D(Rx_shift_reg[2]), .Z(n56) );
  ND2 U86 ( .A(Rx_shift_reg[1]), .B(n69), .Z(n55) );
  ND2 U87 ( .A(n56), .B(n55), .Z(n83) );
  AO2 U88 ( .A(n68), .B(Rx_shift_reg[3]), .C(Rx_shift_reg[1]), .D(n67), .Z(n58) );
  ND2 U89 ( .A(Rx_shift_reg[2]), .B(n69), .Z(n57) );
  ND2 U90 ( .A(n58), .B(n57), .Z(n82) );
  AO2 U91 ( .A(n68), .B(Rx_shift_reg[4]), .C(n67), .D(Rx_shift_reg[2]), .Z(n60) );
  ND2 U92 ( .A(Rx_shift_reg[3]), .B(n69), .Z(n59) );
  ND2 U93 ( .A(n60), .B(n59), .Z(n81) );
  AO2 U94 ( .A(n68), .B(Rx_shift_reg[5]), .C(n67), .D(Rx_shift_reg[3]), .Z(n62) );
  ND2 U95 ( .A(Rx_shift_reg[4]), .B(n69), .Z(n61) );
  ND2 U96 ( .A(n62), .B(n61), .Z(n80) );
  AO2 U97 ( .A(n68), .B(Rx_shift_reg[6]), .C(n67), .D(Rx_shift_reg[4]), .Z(n64) );
  ND2 U98 ( .A(Rx_shift_reg[5]), .B(n69), .Z(n63) );
  ND2 U99 ( .A(n64), .B(n63), .Z(n79) );
  AO2 U100 ( .A(n68), .B(Rx_shift_reg[7]), .C(n67), .D(Rx_shift_reg[5]), .Z(
        n66) );
  ND2 U101 ( .A(Rx_shift_reg[6]), .B(n69), .Z(n65) );
  ND2 U102 ( .A(n66), .B(n65), .Z(n78) );
  AO2 U103 ( .A(n68), .B(MISO_I), .C(n67), .D(Rx_shift_reg[6]), .Z(n71) );
  ND2 U104 ( .A(Rx_shift_reg[7]), .B(n69), .Z(n70) );
  ND2 U105 ( .A(n71), .B(n70), .Z(n77) );
endmodule


module SPI_SLAVE_CONTROL_SELECT_WIDTH8 ( PCLK, PRESETn, MSTR_I, SPISWAI_I,
        SPI_MODE_I, SEND_DATA_I, BAUD_RATE_DIV_I, RECEIVE_DATA_O, SS_O );
  input [1:0] SPI_MODE_I;
  input [11:0] BAUD_RATE_DIV_I;
  input PCLK, PRESETn, MSTR_I, SPISWAI_I, SEND_DATA_I;
  output RECEIVE_DATA_O, SS_O;
  wire   END, n91, n92, n93, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n2, n3, n4, n5, n6, n7, n8,
         n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n94, n111,
         n112, n113, n114;
  wire   [15:0] count;

  FD2 START_reg ( .D(n110), .CP(PCLK), .CD(PRESETn), .QN(n113) );
  FD2 \count_reg[0]  ( .D(n109), .CP(PCLK), .CD(PRESETn), .Q(count[0]), .QN(
        n87) );
  FD2 \count_reg[1]  ( .D(n108), .CP(PCLK), .CD(PRESETn), .QN(n111) );
  FD2 \count_reg[2]  ( .D(n107), .CP(PCLK), .CD(PRESETn), .Q(count[2]), .QN(
        n114) );
  FD2 \count_reg[3]  ( .D(n106), .CP(PCLK), .CD(PRESETn), .QN(n112) );
  FD2 \count_reg[4]  ( .D(n105), .CP(PCLK), .CD(PRESETn), .Q(count[4]), .QN(
        n83) );
  FD2 \count_reg[5]  ( .D(n104), .CP(PCLK), .CD(PRESETn), .QN(n90) );
  FD2 \count_reg[6]  ( .D(n103), .CP(PCLK), .CD(PRESETn), .Q(count[6]), .QN(
        n94) );
  FD2 \count_reg[7]  ( .D(n102), .CP(PCLK), .CD(PRESETn), .Q(count[7]), .QN(
        n89) );
  FD2 \count_reg[8]  ( .D(n101), .CP(PCLK), .CD(PRESETn), .Q(count[8]), .QN(
        n84) );
  FD2 \count_reg[9]  ( .D(n100), .CP(PCLK), .CD(PRESETn), .Q(count[9]), .QN(
        n85) );
  FD2 \count_reg[10]  ( .D(n99), .CP(PCLK), .CD(PRESETn), .Q(count[10]), .QN(
        n81) );
  FD2 \count_reg[11]  ( .D(n98), .CP(PCLK), .CD(PRESETn), .Q(count[11]), .QN(
        n86) );
  FD2 \count_reg[12]  ( .D(n97), .CP(PCLK), .CD(PRESETn), .Q(count[12]) );
  FD2 \count_reg[13]  ( .D(n96), .CP(PCLK), .CD(PRESETn), .Q(count[13]), .QN(
        n82) );
  FD2 \count_reg[14]  ( .D(n95), .CP(PCLK), .CD(PRESETn), .QN(n88) );
  FD2 END_reg ( .D(n93), .CP(PCLK), .CD(PRESETn), .Q(END) );
  FD2 RECEIVE_DATA_O_reg ( .D(n92), .CP(PCLK), .CD(PRESETn), .Q(RECEIVE_DATA_O) );
  FD4 SS_O_reg ( .D(n91), .CP(PCLK), .SD(PRESETn), .Q(SS_O) );
  NR2 U3 ( .A(n65), .B(n64), .Z(n68) );
  IVA U4 ( .A(n32), .Z(n30) );
  NR2 U5 ( .A(n70), .B(n69), .Z(n62) );
  IVP U6 ( .A(n31), .Z(n70) );
  IVA U7 ( .A(n25), .Z(n74) );
  ND2 U8 ( .A(n25), .B(n80), .Z(n31) );
  AO4 U9 ( .A(n22), .B(n20), .C(n21), .D(n20), .Z(n25) );
  IVA U10 ( .A(n69), .Z(n76) );
  ND2 U11 ( .A(n78), .B(n28), .Z(n69) );
  IVA U12 ( .A(n23), .Z(n24) );
  NR2 U13 ( .A(n23), .B(n113), .Z(n80) );
  AO6 U14 ( .A(SPI_MODE_I[1]), .B(n27), .C(n26), .Z(n78) );
  NR2 U15 ( .A(BAUD_RATE_DIV_I[11]), .B(n88), .Z(n20) );
  IVA U16 ( .A(BAUD_RATE_DIV_I[6]), .Z(n14) );
  IVA U17 ( .A(BAUD_RATE_DIV_I[9]), .Z(n17) );
  IVA U18 ( .A(SPI_MODE_I[0]), .Z(n27) );
  IVA U19 ( .A(MSTR_I), .Z(n26) );
  AO6 U20 ( .A(SPI_MODE_I[0]), .B(SPISWAI_I), .C(SPI_MODE_I[1]), .Z(n2) );
  ND2 U21 ( .A(MSTR_I), .B(n2), .Z(n23) );
  AO1P U22 ( .A(BAUD_RATE_DIV_I[7]), .B(n81), .C(BAUD_RATE_DIV_I[6]), .D(n85),
        .Z(n4) );
  AO4 U23 ( .A(BAUD_RATE_DIV_I[7]), .B(n81), .C(BAUD_RATE_DIV_I[8]), .D(n86),
        .Z(n3) );
  NR2 U24 ( .A(n4), .B(n3), .Z(n16) );
  AO2 U25 ( .A(BAUD_RATE_DIV_I[5]), .B(n84), .C(BAUD_RATE_DIV_I[7]), .D(n81),
        .Z(n13) );
  ND2 U26 ( .A(BAUD_RATE_DIV_I[2]), .B(n90), .Z(n6) );
  AO3 U27 ( .A(BAUD_RATE_DIV_I[2]), .B(n90), .C(n83), .D(BAUD_RATE_DIV_I[1]),
        .Z(n5) );
  ND2 U28 ( .A(n6), .B(n5), .Z(n7) );
  AO5 U29 ( .A(n7), .B(BAUD_RATE_DIV_I[3]), .C(n94), .Z(n8) );
  NR2 U30 ( .A(n8), .B(count[7]), .Z(n11) );
  ND2 U31 ( .A(n8), .B(count[7]), .Z(n10) );
  OR2P U32 ( .A(n84), .B(BAUD_RATE_DIV_I[5]), .Z(n9) );
  AO3 U33 ( .A(BAUD_RATE_DIV_I[4]), .B(n11), .C(n10), .D(n9), .Z(n12) );
  AO3 U34 ( .A(count[9]), .B(n14), .C(n13), .D(n12), .Z(n15) );
  AO2 U35 ( .A(BAUD_RATE_DIV_I[8]), .B(n86), .C(n16), .D(n15), .Z(n18) );
  AO5 U36 ( .A(count[12]), .B(n18), .C(n17), .Z(n19) );
  AO5 U37 ( .A(BAUD_RATE_DIV_I[10]), .B(n82), .C(n19), .Z(n22) );
  ND2 U38 ( .A(BAUD_RATE_DIV_I[11]), .B(n88), .Z(n21) );
  ND2 U39 ( .A(n24), .B(SEND_DATA_I), .Z(n28) );
  AO2 U40 ( .A(n80), .B(n74), .C(n113), .D(n28), .Z(n110) );
  NR2 U41 ( .A(count[0]), .B(n31), .Z(n32) );
  AO3 U42 ( .A(count[0]), .B(n69), .C(n78), .D(n31), .Z(n29) );
  ND2 U43 ( .A(n30), .B(n29), .Z(n109) );
  NR2 U44 ( .A(n62), .B(n32), .Z(n35) );
  ND2 U45 ( .A(n111), .B(n70), .Z(n33) );
  AO4 U46 ( .A(n35), .B(n111), .C(n33), .D(n87), .Z(n108) );
  NR2 U47 ( .A(n111), .B(n87), .Z(n37) );
  ND2 U48 ( .A(n70), .B(n37), .Z(n36) );
  AN2P U49 ( .A(count[2]), .B(n33), .Z(n34) );
  AO2 U50 ( .A(n36), .B(n114), .C(n35), .D(n34), .Z(n107) );
  ND2 U51 ( .A(count[2]), .B(n37), .Z(n38) );
  AO6 U52 ( .A(n70), .B(n38), .C(n62), .Z(n41) );
  ND2 U53 ( .A(n112), .B(n70), .Z(n39) );
  AO4 U54 ( .A(n41), .B(n112), .C(n39), .D(n38), .Z(n106) );
  NR2 U55 ( .A(n112), .B(n38), .Z(n43) );
  ND2 U56 ( .A(n70), .B(n43), .Z(n42) );
  AN2P U57 ( .A(count[4]), .B(n39), .Z(n40) );
  AO2 U58 ( .A(n42), .B(n83), .C(n41), .D(n40), .Z(n105) );
  ND2 U59 ( .A(count[4]), .B(n43), .Z(n44) );
  AO6 U60 ( .A(n70), .B(n44), .C(n62), .Z(n47) );
  ND2 U61 ( .A(n90), .B(n70), .Z(n45) );
  AO4 U62 ( .A(n47), .B(n90), .C(n45), .D(n44), .Z(n104) );
  NR2 U63 ( .A(n90), .B(n44), .Z(n49) );
  ND2 U64 ( .A(n70), .B(n49), .Z(n48) );
  AN2P U65 ( .A(count[6]), .B(n45), .Z(n46) );
  AO2 U66 ( .A(n48), .B(n94), .C(n47), .D(n46), .Z(n103) );
  ND2 U67 ( .A(count[6]), .B(n49), .Z(n50) );
  AO6 U68 ( .A(n70), .B(n50), .C(n62), .Z(n53) );
  ND2 U69 ( .A(n89), .B(n70), .Z(n51) );
  AO4 U70 ( .A(n53), .B(n89), .C(n51), .D(n50), .Z(n102) );
  NR2 U71 ( .A(n89), .B(n50), .Z(n55) );
  ND2 U72 ( .A(n70), .B(n55), .Z(n54) );
  AN2P U73 ( .A(count[8]), .B(n51), .Z(n52) );
  AO2 U74 ( .A(n54), .B(n84), .C(n53), .D(n52), .Z(n101) );
  ND2 U75 ( .A(count[8]), .B(n55), .Z(n56) );
  AO6 U76 ( .A(n70), .B(n56), .C(n62), .Z(n59) );
  ND2 U77 ( .A(n85), .B(n70), .Z(n57) );
  AO4 U78 ( .A(n59), .B(n85), .C(n57), .D(n56), .Z(n100) );
  NR2 U79 ( .A(n85), .B(n56), .Z(n61) );
  ND2 U80 ( .A(n70), .B(n61), .Z(n60) );
  AN2P U81 ( .A(count[10]), .B(n57), .Z(n58) );
  AO2 U82 ( .A(n60), .B(n81), .C(n59), .D(n58), .Z(n99) );
  ND2 U83 ( .A(count[10]), .B(n61), .Z(n65) );
  AO6 U84 ( .A(n70), .B(n65), .C(n62), .Z(n67) );
  ND2 U85 ( .A(n86), .B(n70), .Z(n63) );
  AO4 U86 ( .A(n67), .B(n86), .C(n63), .D(n65), .Z(n98) );
  AN2P U87 ( .A(count[12]), .B(n63), .Z(n66) );
  ND2 U88 ( .A(count[11]), .B(n70), .Z(n64) );
  EO1 U89 ( .A(n67), .B(n66), .C(n68), .D(count[12]), .Z(n97) );
  ND2 U90 ( .A(count[12]), .B(n68), .Z(n72) );
  NR2 U91 ( .A(n70), .B(n76), .Z(n73) );
  ND2 U92 ( .A(count[13]), .B(n72), .Z(n71) );
  AO4 U93 ( .A(count[13]), .B(n72), .C(n73), .D(n71), .Z(n96) );
  AO4 U94 ( .A(n73), .B(n88), .C(n82), .D(n72), .Z(n95) );
  ND2 U95 ( .A(n80), .B(n74), .Z(n77) );
  NR2 U96 ( .A(END), .B(n77), .Z(n93) );
  ND2 U97 ( .A(n78), .B(RECEIVE_DATA_O), .Z(n75) );
  AO6 U98 ( .A(n77), .B(n75), .C(END), .Z(n92) );
  ND2 U99 ( .A(n76), .B(SS_O), .Z(n79) );
  AO3 U100 ( .A(n80), .B(n79), .C(n78), .D(n77), .Z(n91) );
endmodule


module SPI_TOP ( PCLK, PRESETn, PWRITE_I, PSEL_I, PENABLE_I, PWDATA_I, PADDR_I,
        PRDATA_O, PREADY_O, PSLVERR_O, SPI_INTERRUPT_RQST_O, SCLK_O, MOSI_O,
        MISO_I, SS_O );
  input [7:0] PWDATA_I;
  input [2:0] PADDR_I;
  output [7:0] PRDATA_O;
  input PCLK, PRESETn, PWRITE_I, PSEL_I, PENABLE_I, MISO_I;
  output PREADY_O, PSLVERR_O, SPI_INTERRUPT_RQST_O, SCLK_O, MOSI_O, SS_O;
  wire   RECEIVE_DATA, MSTR, CPOL, CPHA, LSBFE, SPISWAI, SEND_DATA,
         MISO_RCV_SCLKP, MISO_RCV_SCLKN, MOSI_SEND_SCLKP, MOSI_SEND_SCLKN,
         net3653;
  wire   [7:0] DATA_MISO;
  wire   [2:0] SPR;
  wire   [2:0] SPPR;
  wire   [7:0] MOSI_DATA;
  wire   [1:0] SPI_MODE;
  wire   [11:0] BAUD_RATE_DIV;
  wire   SYNOPSYS_UNCONNECTED__0;

  APB_SLAVE_INTERFACE_WIDTH8 APB_slave_interface ( .PCLK(PCLK), .PRESETn(
        PRESETn), .PWRITE_I(PWRITE_I), .PSEL_I(PSEL_I), .PENABLE_I(PENABLE_I),
        .PWDATA_I(PWDATA_I), .PADDR_I(PADDR_I), .SS_I(SS_O), .MISO_DATA_I(
        DATA_MISO), .RECEIVE_DATA_I(RECEIVE_DATA), .PRDATA_O(PRDATA_O),
        .MSTR_O(MSTR), .PREADY_O(PREADY_O), .PSLVERR_O(PSLVERR_O), .CPOL_O(
        CPOL), .CPHA_O(CPHA), .LSBFE_O(LSBFE), .SPISWAI_O(SPISWAI), .SPR_O(SPR), .SPPR_O(SPPR), .SPI_INTERRUPT_RQST_O(SPI_INTERRUPT_RQST_O), .SEND_DATA_O(
        SEND_DATA), .MOSI_DATA_O(MOSI_DATA), .SPI_MODE_O(SPI_MODE) );
  BAUD_GENERATOR Baud_gen ( .PCLK(PCLK), .PRESETn(PRESETn), .SPI_MODE_I(
        SPI_MODE), .SPISWAI_I(SPISWAI), .SPPR_I(SPPR), .SPR_I(SPR), .CPOL_I(
        CPOL), .CPHA_I(CPHA), .SS_I(SS_O), .SCLK_O(SCLK_O), .MISO_RCV_SCLKP_O(
        MISO_RCV_SCLKP), .MISO_RCV_SCLKN_O(MISO_RCV_SCLKN),
        .MOSI_SEND_SCLKP_O(MOSI_SEND_SCLKP), .MOSI_SEND_SCLKN_O(
        MOSI_SEND_SCLKN), .BAUD_RATE_DIV_O({BAUD_RATE_DIV[11:1],
        SYNOPSYS_UNCONNECTED__0}) );
  SPI_SHIFT_REGISTER_WIDTH8 Shift_reg ( .PCLK(PCLK), .PRESETn(PRESETn),
        .CPOL_I(CPOL), .CPHA_I(CPHA), .SS_I(SS_O), .SEND_DATA_I(SEND_DATA),
        .LSBFE_I(LSBFE), .DATA_MOSI_I(MOSI_DATA), .MISO_I(MISO_I),
        .RECEIVE_DATA_I(RECEIVE_DATA), .MISO_RCV_SCLKP_I(MISO_RCV_SCLKP),
        .MISO_RCV_SCLKN_I(MISO_RCV_SCLKN), .MOSI_SEND_SCLKP_I(MOSI_SEND_SCLKP),
        .MOSI_SEND_SCLKN_I(MOSI_SEND_SCLKN), .DATA_MISO_O(DATA_MISO), .MOSI_O(
        MOSI_O) );
  SPI_SLAVE_CONTROL_SELECT_WIDTH8 SPI_slave_control_select ( .PCLK(PCLK),
        .PRESETn(PRESETn), .MSTR_I(MSTR), .SPISWAI_I(SPISWAI), .SPI_MODE_I(
        SPI_MODE), .SEND_DATA_I(SEND_DATA), .BAUD_RATE_DIV_I({
        BAUD_RATE_DIV[11:1], net3653}), .RECEIVE_DATA_O(RECEIVE_DATA), .SS_O(
        SS_O) );
endmodule
