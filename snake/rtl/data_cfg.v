module data_cfg(
    input       [4: 0]      cnt_bit         ,
    input       [6: 0]      cnt_pixel       ,
    input       [3: 0]      ges_data        ,
    input       [3:0 ]      cnt_in          ,
    input       [(4*6)-1:0] snakebody_data  ,
    input                   snake_en        ,     
    input       [47:0]      start_show_data ,
    input       [5:0]       score_position  ,
    input       wire        en_2            ,
    output                  bit
);
reg     [1: 0   ]   ges_pic         ;
wire    [23: 0  ]   data1[63: 0]    ;
reg     [23: 0  ]   data[63: 0]     ;
wire    [23: 0  ]   colors[63: 0]   ;

wire    [47:0   ]   index_data      ;
wire [23: 0]  data_champin[255: 0];
parameter green = 24'h110000;
parameter red = 24'h001100;

assign index_data = snake_en ? snakebody_data : start_show_data;

assign bit = data1[cnt_in * 64 + cnt_pixel][23 - cnt_bit];

//assign colors[score_position] = red;

genvar k;
genvar j;
parameter len = 4'd4;
generate
    for (k = 0; k < 64; k = k + 1) begin : data_gen
            assign data1[k] =(en_2 == 1'b1) ? (data_champin[k]) :((score_position == k) ? red : ((k == index_data[5:0])||(k == index_data[11:6])||(k == index_data[17:12])||(k == index_data[23:18]) ? green : 0));
    end
endgenerate

// integer i;
// integer j;
// parameter snake_len = 4;
// parameter  max_len= 4'd8;
// always @ (*)  begin
//     for (i = 0; i < 64; i = i + 1) begin
//         data[i] = {8'h00, 8'h00, 8'h00};
//         for (j = 0; j < snake_len; j = j + 1) begin
//             data[i] = ((i == (index_data[(6*max_len-1) - (j * 6) -: 5])) ? {8'h11, 8'h00, 8'h00} : {8'h00, 8'h00, 8'h00});
//         end
//     end
// end



// assign data[00] = ((score_position == 6'd00)||(6'd00 == index_data[5:0])||(6'd00 == index_data[11:6])||(6'd00 == index_data[17:12])||(6'd00 == index_data[23:18]))?green:0; 
// assign data[01] = ((score_position == 6'd01)||(6'd01 == index_data[5:0])||(6'd01 == index_data[11:6])||(6'd01 == index_data[17:12])||(6'd01 == index_data[23:18]))?green:0; 
// assign data[02] = ((score_position == 6'd02)||(6'd02 == index_data[5:0])||(6'd02 == index_data[11:6])||(6'd02 == index_data[17:12])||(6'd02 == index_data[23:18]))?green:0; 
// assign data[03] = ((score_position == 6'd03)||(6'd03 == index_data[5:0])||(6'd03 == index_data[11:6])||(6'd03 == index_data[17:12])||(6'd03 == index_data[23:18]))?green:0; 
// assign data[04] = ((score_position == 6'd04)||(6'd04 == index_data[5:0])||(6'd04 == index_data[11:6])||(6'd04 == index_data[17:12])||(6'd04 == index_data[23:18]))?green:0; 
// assign data[05] = ((score_position == 6'd05)||(6'd05 == index_data[5:0])||(6'd05 == index_data[11:6])||(6'd05 == index_data[17:12])||(6'd05 == index_data[23:18]))?green:0; 
// assign data[06] = ((score_position == 6'd06)||(6'd06 == index_data[5:0])||(6'd06 == index_data[11:6])||(6'd06 == index_data[17:12])||(6'd06 == index_data[23:18]))?green:0; 
// assign data[07] = ((score_position == 6'd07)||(6'd07 == index_data[5:0])||(6'd07 == index_data[11:6])||(6'd07 == index_data[17:12])||(6'd07 == index_data[23:18]))?green:0; 
// assign data[08] = ((score_position == 6'd08)||(6'd08 == index_data[5:0])||(6'd08 == index_data[11:6])||(6'd08 == index_data[17:12])||(6'd08 == index_data[23:18]))?green:0; 
// assign data[09] = ((score_position == 6'd09)||(6'd09 == index_data[5:0])||(6'd09 == index_data[11:6])||(6'd09 == index_data[17:12])||(6'd09 == index_data[23:18]))?green:0; 
// assign data[10] = ((score_position == 6'd10)||(6'd10 == index_data[5:0])||(6'd10 == index_data[11:6])||(6'd10 == index_data[17:12])||(6'd10 == index_data[23:18]))?green:0; 
// assign data[11] = ((score_position == 6'd11)||(6'd11 == index_data[5:0])||(6'd11 == index_data[11:6])||(6'd11 == index_data[17:12])||(6'd11 == index_data[23:18]))?green:0; 
// assign data[12] = ((score_position == 6'd12)||(6'd12 == index_data[5:0])||(6'd12 == index_data[11:6])||(6'd12 == index_data[17:12])||(6'd12 == index_data[23:18]))?green:0; 
// assign data[13] = ((score_position == 6'd13)||(6'd13 == index_data[5:0])||(6'd13 == index_data[11:6])||(6'd13 == index_data[17:12])||(6'd13 == index_data[23:18]))?green:0; 
// assign data[14] = ((score_position == 6'd14)||(6'd14 == index_data[5:0])||(6'd14 == index_data[11:6])||(6'd14 == index_data[17:12])||(6'd14 == index_data[23:18]))?green:0; 
// assign data[15] = ((score_position == 6'd15)||(6'd15 == index_data[5:0])||(6'd15 == index_data[11:6])||(6'd15 == index_data[17:12])||(6'd15 == index_data[23:18]))?green:0; 
// assign data[16] = ((score_position == 6'd16)||(6'd16 == index_data[5:0])||(6'd16 == index_data[11:6])||(6'd16 == index_data[17:12])||(6'd16 == index_data[23:18]))?green:0; 
// assign data[17] = ((score_position == 6'd17)||(6'd17 == index_data[5:0])||(6'd17 == index_data[11:6])||(6'd17 == index_data[17:12])||(6'd17 == index_data[23:18]))?green:0; 
// assign data[18] = ((score_position == 6'd18)||(6'd18 == index_data[5:0])||(6'd18 == index_data[11:6])||(6'd18 == index_data[17:12])||(6'd18 == index_data[23:18]))?green:0; 
// assign data[19] = ((score_position == 6'd19)||(6'd19 == index_data[5:0])||(6'd19 == index_data[11:6])||(6'd19 == index_data[17:12])||(6'd19 == index_data[23:18]))?green:0; 
// assign data[20] = ((score_position == 6'd20)||(6'd20 == index_data[5:0])||(6'd20 == index_data[11:6])||(6'd20 == index_data[17:12])||(6'd20 == index_data[23:18]))?green:0; 
// assign data[21] = ((score_position == 6'd21)||(6'd21 == index_data[5:0])||(6'd21 == index_data[11:6])||(6'd21 == index_data[17:12])||(6'd21 == index_data[23:18]))?green:0; 
// assign data[22] = ((score_position == 6'd22)||(6'd22 == index_data[5:0])||(6'd22 == index_data[11:6])||(6'd22 == index_data[17:12])||(6'd22 == index_data[23:18]))?green:0; 
// assign data[23] = ((score_position == 6'd23)||(6'd23 == index_data[5:0])||(6'd23 == index_data[11:6])||(6'd23 == index_data[17:12])||(6'd23 == index_data[23:18]))?green:0; 
// assign data[24] = ((score_position == 6'd24)||(6'd24 == index_data[5:0])||(6'd24 == index_data[11:6])||(6'd24 == index_data[17:12])||(6'd24 == index_data[23:18]))?green:0; 
// assign data[25] = ((score_position == 6'd25)||(6'd25 == index_data[5:0])||(6'd25 == index_data[11:6])||(6'd25 == index_data[17:12])||(6'd25 == index_data[23:18]))?green:0; 
// assign data[26] = ((score_position == 6'd26)||(6'd26 == index_data[5:0])||(6'd26 == index_data[11:6])||(6'd26 == index_data[17:12])||(6'd26 == index_data[23:18]))?green:0; 
// assign data[27] = ((score_position == 6'd27)||(6'd27 == index_data[5:0])||(6'd27 == index_data[11:6])||(6'd27 == index_data[17:12])||(6'd27 == index_data[23:18]))?green:0; 
// assign data[28] = ((score_position == 6'd28)||(6'd28 == index_data[5:0])||(6'd28 == index_data[11:6])||(6'd28 == index_data[17:12])||(6'd28 == index_data[23:18]))?green:0; 
// assign data[29] = ((score_position == 6'd29)||(6'd29 == index_data[5:0])||(6'd29 == index_data[11:6])||(6'd29 == index_data[17:12])||(6'd29 == index_data[23:18]))?green:0; 
// assign data[30] = ((score_position == 6'd30)||(6'd30 == index_data[5:0])||(6'd30 == index_data[11:6])||(6'd30 == index_data[17:12])||(6'd30 == index_data[23:18]))?green:0; 
// assign data[31] = ((score_position == 6'd31)||(6'd31 == index_data[5:0])||(6'd31 == index_data[11:6])||(6'd31 == index_data[17:12])||(6'd31 == index_data[23:18]))?green:0; 
// assign data[32] = ((score_position == 6'd32)||(6'd32 == index_data[5:0])||(6'd32 == index_data[11:6])||(6'd32 == index_data[17:12])||(6'd32 == index_data[23:18]))?green:0; 
// assign data[33] = ((score_position == 6'd33)||(6'd33 == index_data[5:0])||(6'd33 == index_data[11:6])||(6'd33 == index_data[17:12])||(6'd33 == index_data[23:18]))?green:0; 
// assign data[34] = ((score_position == 6'd34)||(6'd34 == index_data[5:0])||(6'd34 == index_data[11:6])||(6'd34 == index_data[17:12])||(6'd34 == index_data[23:18]))?green:0; 
// assign data[35] = ((score_position == 6'd35)||(6'd35 == index_data[5:0])||(6'd35 == index_data[11:6])||(6'd35 == index_data[17:12])||(6'd35 == index_data[23:18]))?green:0; 
// assign data[36] = ((score_position == 6'd36)||(6'd36 == index_data[5:0])||(6'd36 == index_data[11:6])||(6'd36 == index_data[17:12])||(6'd36 == index_data[23:18]))?green:0; 
// assign data[37] = ((score_position == 6'd37)||(6'd37 == index_data[5:0])||(6'd37 == index_data[11:6])||(6'd37 == index_data[17:12])||(6'd37 == index_data[23:18]))?green:0; 
// assign data[38] = ((score_position == 6'd38)||(6'd38 == index_data[5:0])||(6'd38 == index_data[11:6])||(6'd38 == index_data[17:12])||(6'd38 == index_data[23:18]))?green:0; 
// assign data[39] = ((score_position == 6'd39)||(6'd39 == index_data[5:0])||(6'd39 == index_data[11:6])||(6'd39 == index_data[17:12])||(6'd39 == index_data[23:18]))?green:0; 
// assign data[40] = ((score_position == 6'd40)||(6'd40 == index_data[5:0])||(6'd40 == index_data[11:6])||(6'd40 == index_data[17:12])||(6'd40 == index_data[23:18]))?green:0; 
// assign data[41] = ((score_position == 6'd41)||(6'd41 == index_data[5:0])||(6'd41 == index_data[11:6])||(6'd41 == index_data[17:12])||(6'd41 == index_data[23:18]))?green:0; 
// assign data[42] = ((score_position == 6'd42)||(6'd42 == index_data[5:0])||(6'd42 == index_data[11:6])||(6'd42 == index_data[17:12])||(6'd42 == index_data[23:18]))?green:0; 
// assign data[43] = ((score_position == 6'd43)||(6'd43 == index_data[5:0])||(6'd43 == index_data[11:6])||(6'd43 == index_data[17:12])||(6'd43 == index_data[23:18]))?green:0; 
// assign data[44] = ((score_position == 6'd44)||(6'd44 == index_data[5:0])||(6'd44 == index_data[11:6])||(6'd44 == index_data[17:12])||(6'd44 == index_data[23:18]))?green:0; 
// assign data[45] = ((score_position == 6'd45)||(6'd45 == index_data[5:0])||(6'd45 == index_data[11:6])||(6'd45 == index_data[17:12])||(6'd45 == index_data[23:18]))?green:0; 
// assign data[46] = ((score_position == 6'd46)||(6'd46 == index_data[5:0])||(6'd46 == index_data[11:6])||(6'd46 == index_data[17:12])||(6'd46 == index_data[23:18]))?green:0; 
// assign data[47] = ((score_position == 6'd47)||(6'd47 == index_data[5:0])||(6'd47 == index_data[11:6])||(6'd47 == index_data[17:12])||(6'd47 == index_data[23:18]))?green:0; 
// assign data[48] = ((score_position == 6'd48)||(6'd48 == index_data[5:0])||(6'd48 == index_data[11:6])||(6'd48 == index_data[17:12])||(6'd48 == index_data[23:18]))?green:0; 
// assign data[49] = ((score_position == 6'd49)||(6'd49 == index_data[5:0])||(6'd49 == index_data[11:6])||(6'd49 == index_data[17:12])||(6'd49 == index_data[23:18]))?green:0; 
// assign data[50] = ((score_position == 6'd50)||(6'd50 == index_data[5:0])||(6'd50 == index_data[11:6])||(6'd50 == index_data[17:12])||(6'd50 == index_data[23:18]))?green:0; 
// assign data[51] = ((score_position == 6'd51)||(6'd51 == index_data[5:0])||(6'd51 == index_data[11:6])||(6'd51 == index_data[17:12])||(6'd51 == index_data[23:18]))?green:0; 
// assign data[52] = ((score_position == 6'd52)||(6'd52 == index_data[5:0])||(6'd52 == index_data[11:6])||(6'd52 == index_data[17:12])||(6'd52 == index_data[23:18]))?green:0; 
// assign data[53] = ((score_position == 6'd53)||(6'd53 == index_data[5:0])||(6'd53 == index_data[11:6])||(6'd53 == index_data[17:12])||(6'd53 == index_data[23:18]))?green:0; 
// assign data[54] = ((score_position == 6'd54)||(6'd54 == index_data[5:0])||(6'd54 == index_data[11:6])||(6'd54 == index_data[17:12])||(6'd54 == index_data[23:18]))?green:0; 
// assign data[55] = ((score_position == 6'd55)||(6'd55 == index_data[5:0])||(6'd55 == index_data[11:6])||(6'd55 == index_data[17:12])||(6'd55 == index_data[23:18]))?green:0; 
// assign data[56] = ((score_position == 6'd56)||(6'd56 == index_data[5:0])||(6'd56 == index_data[11:6])||(6'd56 == index_data[17:12])||(6'd56 == index_data[23:18]))?green:0; 
// assign data[57] = ((score_position == 6'd57)||(6'd57 == index_data[5:0])||(6'd57 == index_data[11:6])||(6'd57 == index_data[17:12])||(6'd57 == index_data[23:18]))?green:0; 
// assign data[58] = ((score_position == 6'd58)||(6'd58 == index_data[5:0])||(6'd58 == index_data[11:6])||(6'd58 == index_data[17:12])||(6'd58 == index_data[23:18]))?green:0; 
// assign data[59] = ((score_position == 6'd59)||(6'd59 == index_data[5:0])||(6'd59 == index_data[11:6])||(6'd59 == index_data[17:12])||(6'd59 == index_data[23:18]))?green:0; 
// assign data[60] = ((score_position == 6'd60)||(6'd60 == index_data[5:0])||(6'd60 == index_data[11:6])||(6'd60 == index_data[17:12])||(6'd60 == index_data[23:18]))?green:0; 
// assign data[61] = ((score_position == 6'd61)||(6'd61 == index_data[5:0])||(6'd61 == index_data[11:6])||(6'd61 == index_data[17:12])||(6'd61 == index_data[23:18]))?green:0; 
// assign data[62] = ((score_position == 6'd62)||(6'd62 == index_data[5:0])||(6'd62 == index_data[11:6])||(6'd62 == index_data[17:12])||(6'd62 == index_data[23:18]))?green:0; 
// assign data[63] = ((score_position == 6'd63)||(6'd63 == index_data[5:0])||(6'd63 == index_data[11:6])||(6'd63 == index_data[17:12])||(6'd63 == index_data[23:18]))?green:0; 

assign  data_champin[63]  =  {8'h00,8'h00,8'h00}  ;//0
assign  data_champin[62]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[61]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[60]  =  {8'h11,8'h11,8'h00}  ;    
assign  data_champin[59]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[58]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[57]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[56]  =  {8'h00,8'h00,8'h00}  ;    
assign  data_champin[55]  =  {8'h00,8'h00,8'h00}  ;//1
assign  data_champin[54]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[53]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[52]  =  {8'h11,8'h11,8'h00}  ;    
assign  data_champin[51]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[50]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[49]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[48]  =  {8'h00,8'h00,8'h00}  ;    
assign  data_champin[47]  =  {8'h00,8'h00,8'h00}   ;//2
assign  data_champin[46]  =  {8'h00,8'h00,8'h00}   ;
assign  data_champin[45]  =   {8'h00,8'h00,8'h00} ;
assign  data_champin[44]  =   {8'h11,8'h11,8'h00}  ;    
assign  data_champin[43]  =   {8'h11,8'h11,8'h00}  ;
assign  data_champin[42]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[41]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[40]  =   {8'h00,8'h00,8'h00}  ;    
assign  data_champin[39]  =  {8'h00,8'h00,8'h00}   ;//3
assign  data_champin[38]  =  {8'h00,8'h00,8'h00}   ;
assign  data_champin[37]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[36]  =   {8'h11,8'h11,8'h00}  ;    
assign  data_champin[35]  =   {8'h11,8'h11,8'h00}  ;
assign  data_champin[34]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[33]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[32]  =   {8'h00,8'h00,8'h00}  ;    
assign  data_champin[31]  =  {8'h00,8'h00,8'h00}   ;//4
assign  data_champin[30]  =  {8'h00,8'h00,8'h00}    ;
assign  data_champin[29]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[28]  =   {8'h00,8'h00,8'h00}  ;    
assign  data_champin[27]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[26]  =   {8'h11,8'h11,8'h00}  ;
assign  data_champin[25]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[24]  =   {8'h00,8'h00,8'h00}  ;    
assign  data_champin[23]  =  {8'h00,8'h00,8'h00}   ;    //5
assign  data_champin[22]  =  {8'h11,8'h11,8'h00}   ;
assign  data_champin[21]  =   {8'h00,8'h00,8'h00} ;
assign  data_champin[20]  =   {8'h00,8'h11,8'h00}   ;
assign  data_champin[19]  =   {8'h00,8'h11,8'h00} ;    
assign  data_champin[18]  =   {8'h00,8'h00,8'h00}  ;    
assign  data_champin[17]  =   {8'h11,8'h11,8'h00}  ;
assign  data_champin[16]  =   {8'h00,8'h00,8'h00}  ;
assign  data_champin[15]  =  {8'h00,8'h00,8'h00}  ;//6
assign  data_champin[14]  =  {8'h11,8'h11,8'h00}  ;
assign  data_champin[13]  =  {8'h11,8'h11,8'h00} ;
assign  data_champin[12]  =   {8'h11,8'h11,8'h00} ;
assign  data_champin[11]  =   {8'h11,8'h11,8'h00} ;    
assign  data_champin[10]  =   {8'h11,8'h11,8'h00} ;
assign  data_champin[9]  =   {8'h11,8'h11,8'h00} ;
assign  data_champin[8]  =   {8'h00,8'h00,8'h00} ;
assign  data_champin[7]  =  {8'h00,8'h00,8'h00}  ;    //7
assign  data_champin[6]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[5]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[4]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[3]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[2]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[1]  =  {8'h00,8'h00,8'h00}  ;
assign  data_champin[0]  =  {8'h00,8'h00,8'h00}  ;


always @(*) begin
    case(ges_data)
        4'b0001:     ges_pic = 2'd0;
        4'b0010:     ges_pic = 2'd1;
        4'b0100:     ges_pic = 2'd2;
        4'b1000:     ges_pic = 2'd3;
        default:     ges_pic = 2'd0;
    endcase
end
endmodule

