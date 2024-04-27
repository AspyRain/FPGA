module data_cfg(
    input  wire [4: 0]  cnt_bit     ,
    input  wire [6: 0]  cnt_pixel   ,
    input  wire [3: 0]  ges_data    ,
    input  wire [3:0 ]   cnt_in      ,
    output wire         bit
);
reg  [1: 0]   ges_pic;
wire [23: 0]  data[255: 0];



assign bit = data[cnt_in * 64 + cnt_pixel][23 - cnt_bit];

always @(*) begin
    case(ges_data)
        4'b0001:     ges_pic = 2'd0;
        4'b0010:     ges_pic = 2'd1;
        4'b0100:     ges_pic = 2'd2;
        4'b1000:     ges_pic = 2'd3;
        default:     ges_pic = 2'd0;
    endcase
end
//10
assign  data[0]  =  {8'h00,8'h00,8'h00}  ;//0
assign  data[1]  =  {8'h00,8'h00,8'h00}  ;
assign  data[2]  =  {8'h00,8'h00,8'h00}  ;
assign  data[3]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[4]  =  {8'h00,8'h00,8'h00}  ;
assign  data[5]  =  {8'h00,8'h00,8'h00}  ;
assign  data[6]  =  {8'h00,8'h00,8'h00}  ;
assign  data[7]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[8]  =  {8'h00,8'h00,8'h00}  ;//1
assign  data[9]  =  {8'hff,8'hff,8'hff}  ;
assign  data[10]  =  {8'hff,8'hff,8'hff}  ;
assign  data[11]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[12]  =  {8'h00,8'h00,8'h00}  ;
assign  data[13]  =  {8'h00,8'h00,8'h00}  ;
assign  data[14]  =  {8'hff,8'hff,8'hff}  ;
assign  data[15]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[16]  =  {8'h00,8'h00,8'h00}   ;//2
assign  data[17]  =  {8'hff,8'hff,8'hff}   ;
assign  data[18]  =   {8'h00,8'h00,8'h00} ;
assign  data[19]  =   {8'hff,8'hff,8'hff}  ;	
assign  data[20]  =   {8'h00,8'h00,8'h00}  ;
assign  data[21]  =   {8'h00,8'h00,8'h00}  ;
assign  data[22]  =   {8'hff,8'hff,8'hff}  ;
assign  data[23]  =   {8'h00,8'h00,8'h00}  ;	
assign  data[24]  =  {8'h00,8'h00,8'h00}   ;//3
assign  data[25]  =  {8'hff,8'hff,8'hff}   ;
assign  data[26]  =   {8'h00,8'h00,8'h00}  ;
assign  data[27]  =   {8'hff,8'hff,8'hff}  ;	
assign  data[28]  =   {8'h00,8'h00,8'h00}  ;
assign  data[29]  =   {8'h00,8'h00,8'h00}  ;
assign  data[30]  =   {8'hff,8'hff,8'hff}  ;
assign  data[31]  =   {8'h00,8'h00,8'h00}  ;	
assign  data[32]  =  {8'h00,8'h00,8'h00}   ;//4
assign  data[33]  =  {8'hff,8'hff,8'hff}   ;
assign  data[34]  =  {8'h00,8'h00,8'h00}  ;
assign  data[35]  =   {8'hff,8'hff,8'hff}  ;	
assign  data[36]  =   {8'h00,8'h00,8'h00}  ;
assign  data[37]  =   {8'h00,8'h00,8'h00}  ;
assign  data[38]  =   {8'hff,8'hff,8'hff}  ;
assign  data[39]  =   {8'h00,8'h00,8'h00}  ;	
assign  data[40]  =  {8'h00,8'h00,8'h00}   ;	//5
assign  data[41]  =  {8'hff,8'hff,8'hff}   ;
assign  data[42]  =   {8'h00,8'h00,8'h00} ;
assign  data[43]  =   {8'hff,8'hff,8'hff}   ;
assign  data[44]  =   {8'h00,8'h00,8'h00} ;	
assign  data[45]  =   {8'h00,8'h00,8'h00}  ;	
assign  data[46]  =   {8'hff,8'hff,8'hff}  ;
assign  data[47]  =   {8'h00,8'h00,8'h00}  ;
assign  data[48]  =  {8'h00,8'h00,8'h00}  ;//6
assign  data[49]  =  {8'hff,8'hff,8'hff}  ;
assign  data[50]  =   {8'hff,8'hff,8'hff} ;
assign  data[51]  =   {8'hff,8'hff,8'hff} ;
assign  data[52]  =   {8'h00,8'h00,8'h00} ;	
assign  data[53]  =   {8'h00,8'h00,8'h00} ;
assign  data[54]  =   {8'hff,8'hff,8'hff} ;
assign  data[55]  =   {8'h00,8'h00,8'h00} ;
assign  data[56]  =  {8'h00,8'h00,8'h00}  ;	//7
assign  data[57]  =  {8'h00,8'h00,8'h00}  ;
assign  data[58]  =  {8'h00,8'h00,8'h00}  ;
assign  data[59]  =  {8'h00,8'h00,8'h00}  ;
assign  data[60]  =  {8'h00,8'h00,8'h00}  ;
assign  data[61]  =  {8'h00,8'h00,8'h00}  ;
assign  data[62]  =  {8'h00,8'h00,8'h00}  ;
assign  data[63]  =  {8'h00,8'h00,8'h00}  ;

//9
assign  data[64 ]  =  {8'h00,8'h00,8'h00}  ;//0
assign  data[65 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[66 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[67 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[68 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[69 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[70 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[71 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[72 ]  =  {8'h00,8'h00,8'h00}  ;//1
assign  data[73 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[74 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[75 ]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[76 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[77 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[78 ]  =  {8'h00,8'h00,8'h00}   ;
assign  data[79 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[80 ]  =  {8'h00,8'h00,8'h00}   ;//2
assign  data[81 ]  =  {8'h00,8'h00,8'h00}    ;
assign  data[82 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[83 ]  =  {8'h00,8'h00,8'h00}   ;	
assign  data[84 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[85 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[86 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[87 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[88 ]  =  {8'h00,8'h00,8'h00}  ;//3
assign  data[89 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[90 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[91 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[92 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[93 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[94 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[95 ]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[96 ]  =  {8'h00,8'h00,8'h00}  ;//4
assign  data[97 ]  =  {8'h00,8'h00,8'h00}  ;
assign  data[98 ]  =  {8'hff,8'hff,8'hff}  ;
assign  data[99 ]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[100]  =  {8'hff,8'hff,8'hff}  ;
assign  data[101]  =  {8'hff,8'hff,8'hff}  ;
assign  data[102]  =  {8'h00,8'h00,8'h00}  ;
assign  data[103]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[104]  =  {8'h00,8'h00,8'h00}  ;	//5
assign  data[105]  =  {8'h00,8'h00,8'h00}  ;
assign  data[106]  =  {8'hff,8'hff,8'hff}  ;
assign  data[107]  =  {8'h00,8'h00,8'h00}   ;
assign  data[108]  =  {8'h00,8'h00,8'h00} ;	
assign  data[109]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[110]  =  {8'h00,8'h00,8'h00}  ;
assign  data[111]  =  {8'h00,8'h00,8'h00}  ;
assign  data[112]  =  {8'h00,8'h00,8'h00} ;//6
assign  data[113]  =  {8'h00,8'h00,8'h00} ;
assign  data[114]  =  {8'hff,8'hff,8'hff} ;
assign  data[115]  =  {8'hff,8'hff,8'hff} ;
assign  data[116]  =  {8'hff,8'hff,8'hff} ;	
assign  data[117]  =  {8'hff,8'hff,8'hff} ;
assign  data[118]  =  {8'h00,8'h00,8'h00} ;
assign  data[119]  =  {8'h00,8'h00,8'h00} ;
assign  data[120]  =  {8'h00,8'h00,8'h00}  ;//7
assign  data[121]  =  {8'h00,8'h00,8'h00}  ;
assign  data[122]  =  {8'h00,8'h00,8'h00}  ;
assign  data[123]  =  {8'h00,8'h00,8'h00}  ;
assign  data[124]  =  {8'h00,8'h00,8'h00}  ;
assign  data[125]  =  {8'h00,8'h00,8'h00}  ;
assign  data[126]  =  {8'h00,8'h00,8'h00}  ;
assign  data[127]  =  {8'h00,8'h00,8'h00}  ;

//8
assign  data[128]  =  {8'h00,8'h00,8'h00}  ;//0
assign  data[129]  =  {8'h00,8'h00,8'h00}  ;
assign  data[130]  =  {8'h00,8'h00,8'h00}  ;
assign  data[131]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[132]  =  {8'h00,8'h00,8'h00}  ;
assign  data[133]  =  {8'h00,8'h00,8'h00}  ;
assign  data[134]  =  {8'h00,8'h00,8'h00}  ;
assign  data[135]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[136]  =  {8'h00,8'h00,8'h00}  ;//1
assign  data[137]  =  {8'h00,8'h00,8'h00}  ;
assign  data[138]  =  {8'h00,8'h00,8'h00}   ;
assign  data[139]  =  {8'h00,8'h00,8'h00}   ;	
assign  data[140]  =  {8'h00,8'h00,8'h00}   ;
assign  data[141]  =  {8'h00,8'h00,8'h00}   ;
assign  data[142]  =  {8'h00,8'h00,8'h00}   ;
assign  data[143]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[144]  =  {8'h00,8'h00,8'h00}   ;//2
assign  data[145]  =  {8'h00,8'h00,8'h00}    ;
assign  data[146]  =  {8'hff,8'hff,8'hff}  ;
assign  data[147]  =  {8'hff,8'hff,8'hff}   ;	
assign  data[148]  =  {8'hff,8'hff,8'hff}  ;
assign  data[149]  =  {8'hff,8'hff,8'hff}  ;
assign  data[150]  =  {8'h00,8'h00,8'h00}  ;
assign  data[151]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[152]  =  {8'h00,8'h00,8'h00} ;//3
assign  data[153]  =  {8'h00,8'h00,8'h00} ;
assign  data[154]  =  {8'hff,8'hff,8'hff} ;
assign  data[155]  =  {8'h00,8'h00,8'h00} ;	
assign  data[156]  =  {8'h00,8'h00,8'h00} ;
assign  data[157]  =  {8'hff,8'hff,8'hff} ;
assign  data[158]  =  {8'h00,8'h00,8'h00} ;
assign  data[159]  =  {8'h00,8'h00,8'h00} ;	
assign  data[160]  =  {8'h00,8'h00,8'h00}  ;//4
assign  data[161]  =  {8'h00,8'h00,8'h00}  ;
assign  data[162]  =  {8'hff,8'hff,8'hff}  ;
assign  data[163]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[164]  =  {8'hff,8'hff,8'hff}  ;
assign  data[165]  =  {8'hff,8'hff,8'hff}  ;
assign  data[166]  =  {8'h00,8'h00,8'h00}  ;
assign  data[167]  =  {8'h00,8'h00,8'h00}  ;	
assign  data[168]  =  {8'h00,8'h00,8'h00}  ;//5
assign  data[169]  =  {8'h00,8'h00,8'h00}  ;
assign  data[170]  =  {8'hff,8'hff,8'hff}  ;
assign  data[171]  =  {8'h00,8'h00,8'h00}   ;
assign  data[172]  =  {8'h00,8'h00,8'h00} ;	
assign  data[173]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[174]  =  {8'h00,8'h00,8'h00}  ;
assign  data[175]  =  {8'h00,8'h00,8'h00}  ;
assign  data[176]  =  {8'h00,8'h00,8'h00}  ;//6
assign  data[177]  =  {8'h00,8'h00,8'h00}  ;
assign  data[178]  =  {8'hff,8'hff,8'hff}  ;
assign  data[179]  =  {8'hff,8'hff,8'hff}  ;
assign  data[180]  =  {8'hff,8'hff,8'hff}  ;	
assign  data[181]  =  {8'hff,8'hff,8'hff}  ;
assign  data[182]  =  {8'h00,8'h00,8'h00}  ;
assign  data[183]  =  {8'h00,8'h00,8'h00}  ;
assign  data[184]  =  {8'h00,8'h00,8'h00}  ;//7
assign  data[185]  =  {8'h00,8'h00,8'h00}  ;
assign  data[186]  =  {8'h00,8'h00,8'h00}  ;
assign  data[187]  =  {8'h00,8'h00,8'h00}  ;
assign  data[188]  =  {8'h00,8'h00,8'h00}  ;
assign  data[189]  =  {8'h00,8'h00,8'h00}  ;
assign  data[190]  =  {8'h00,8'h00,8'h00}  ;
assign  data[191]  =  {8'h00,8'h00,8'h00}  ;



endmodule

