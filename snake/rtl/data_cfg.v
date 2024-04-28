module data_cfg(
    input  wire [4: 0]  cnt_bit         ,
    input  wire [6: 0]  cnt_pixel       ,
    input  wire [3: 0]  ges_data        ,             
    input  wire [47:0] index_data  ,
    input  wire [5:0]   score_position ,

    output wire         bit
);
reg  [1: 0]   ges_pic;
reg [23: 0]  data[63: 0];

assign bit = data[0 * 64 + cnt_pixel][23 - cnt_bit];

// assign data[00] = ((6'd00 == index_data[5:0])||(6'd00 == index_data[11:6])||(6'd00 == index_data[17:12])||(6'd00 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[01] = ((6'd01 == index_data[5:0])||(6'd01 == index_data[11:6])||(6'd01 == index_data[17:12])||(6'd01 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[02] = ((6'd02 == index_data[5:0])||(6'd02 == index_data[11:6])||(6'd02 == index_data[17:12])||(6'd02 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[03] = ((6'd03 == index_data[5:0])||(6'd03 == index_data[11:6])||(6'd03 == index_data[17:12])||(6'd03 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[04] = ((6'd04 == index_data[5:0])||(6'd04 == index_data[11:6])||(6'd04 == index_data[17:12])||(6'd04 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[05] = ((6'd05 == index_data[5:0])||(6'd05 == index_data[11:6])||(6'd05 == index_data[17:12])||(6'd05 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[06] = ((6'd06 == index_data[5:0])||(6'd06 == index_data[11:6])||(6'd06 == index_data[17:12])||(6'd06 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[07] = ((6'd07 == index_data[5:0])||(6'd07 == index_data[11:6])||(6'd07 == index_data[17:12])||(6'd07 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[08] = ((6'd08 == index_data[5:0])||(6'd08 == index_data[11:6])||(6'd08 == index_data[17:12])||(6'd08 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[09] = ((6'd09 == index_data[5:0])||(6'd09 == index_data[11:6])||(6'd09 == index_data[17:12])||(6'd09 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[10] = ((6'd10 == index_data[5:0])||(6'd10 == index_data[11:6])||(6'd10 == index_data[17:12])||(6'd10 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[11] = ((6'd11 == index_data[5:0])||(6'd11 == index_data[11:6])||(6'd11 == index_data[17:12])||(6'd11 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[12] = ((6'd12 == index_data[5:0])||(6'd12 == index_data[11:6])||(6'd12 == index_data[17:12])||(6'd12 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[13] = ((6'd13 == index_data[5:0])||(6'd13 == index_data[11:6])||(6'd13 == index_data[17:12])||(6'd13 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[14] = ((6'd14 == index_data[5:0])||(6'd14 == index_data[11:6])||(6'd14 == index_data[17:12])||(6'd14 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[15] = ((6'd15 == index_data[5:0])||(6'd15 == index_data[11:6])||(6'd15 == index_data[17:12])||(6'd15 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[16] = ((6'd16 == index_data[5:0])||(6'd16 == index_data[11:6])||(6'd16 == index_data[17:12])||(6'd16 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[17] = ((6'd17 == index_data[5:0])||(6'd17 == index_data[11:6])||(6'd17 == index_data[17:12])||(6'd17 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[18] = ((6'd18 == index_data[5:0])||(6'd18 == index_data[11:6])||(6'd18 == index_data[17:12])||(6'd18 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[19] = ((6'd19 == index_data[5:0])||(6'd19 == index_data[11:6])||(6'd19 == index_data[17:12])||(6'd19 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[20] = ((6'd20 == index_data[5:0])||(6'd20 == index_data[11:6])||(6'd20 == index_data[17:12])||(6'd20 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[21] = ((6'd21 == index_data[5:0])||(6'd21 == index_data[11:6])||(6'd21 == index_data[17:12])||(6'd21 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[22] = ((6'd22 == index_data[5:0])||(6'd22 == index_data[11:6])||(6'd22 == index_data[17:12])||(6'd22 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[23] = ((6'd23 == index_data[5:0])||(6'd23 == index_data[11:6])||(6'd23 == index_data[17:12])||(6'd23 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[24] = ((6'd24 == index_data[5:0])||(6'd24 == index_data[11:6])||(6'd24 == index_data[17:12])||(6'd24 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[25] = ((6'd25 == index_data[5:0])||(6'd25 == index_data[11:6])||(6'd25 == index_data[17:12])||(6'd25 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[26] = ((6'd26 == index_data[5:0])||(6'd26 == index_data[11:6])||(6'd26 == index_data[17:12])||(6'd26 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[27] = ((6'd27 == index_data[5:0])||(6'd27 == index_data[11:6])||(6'd27 == index_data[17:12])||(6'd27 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[28] = ((6'd28 == index_data[5:0])||(6'd28 == index_data[11:6])||(6'd28 == index_data[17:12])||(6'd28 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[29] = ((6'd29 == index_data[5:0])||(6'd29 == index_data[11:6])||(6'd29 == index_data[17:12])||(6'd29 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[30] = ((6'd30 == index_data[5:0])||(6'd30 == index_data[11:6])||(6'd30 == index_data[17:12])||(6'd30 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[31] = ((6'd31 == index_data[5:0])||(6'd31 == index_data[11:6])||(6'd31 == index_data[17:12])||(6'd31 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[32] = ((6'd32 == index_data[5:0])||(6'd32 == index_data[11:6])||(6'd32 == index_data[17:12])||(6'd32 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[33] = ((6'd33 == index_data[5:0])||(6'd33 == index_data[11:6])||(6'd33 == index_data[17:12])||(6'd33 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[34] = ((6'd34 == index_data[5:0])||(6'd34 == index_data[11:6])||(6'd34 == index_data[17:12])||(6'd34 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[35] = ((6'd35 == index_data[5:0])||(6'd35 == index_data[11:6])||(6'd35 == index_data[17:12])||(6'd35 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[36] = ((6'd36 == index_data[5:0])||(6'd36 == index_data[11:6])||(6'd36 == index_data[17:12])||(6'd36 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[37] = ((6'd37 == index_data[5:0])||(6'd37 == index_data[11:6])||(6'd37 == index_data[17:12])||(6'd37 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[38] = ((6'd38 == index_data[5:0])||(6'd38 == index_data[11:6])||(6'd38 == index_data[17:12])||(6'd38 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[39] = ((6'd39 == index_data[5:0])||(6'd39 == index_data[11:6])||(6'd39 == index_data[17:12])||(6'd39 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[40] = ((6'd40 == index_data[5:0])||(6'd40 == index_data[11:6])||(6'd40 == index_data[17:12])||(6'd40 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[41] = ((6'd41 == index_data[5:0])||(6'd41 == index_data[11:6])||(6'd41 == index_data[17:12])||(6'd41 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[42] = ((6'd42 == index_data[5:0])||(6'd42 == index_data[11:6])||(6'd42 == index_data[17:12])||(6'd42 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[43] = ((6'd43 == index_data[5:0])||(6'd43 == index_data[11:6])||(6'd43 == index_data[17:12])||(6'd43 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[44] = ((6'd44 == index_data[5:0])||(6'd44 == index_data[11:6])||(6'd44 == index_data[17:12])||(6'd44 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[45] = ((6'd45 == index_data[5:0])||(6'd45 == index_data[11:6])||(6'd45 == index_data[17:12])||(6'd45 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[46] = ((6'd46 == index_data[5:0])||(6'd46 == index_data[11:6])||(6'd46 == index_data[17:12])||(6'd46 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[47] = ((6'd47 == index_data[5:0])||(6'd47 == index_data[11:6])||(6'd47 == index_data[17:12])||(6'd47 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[48] = ((6'd48 == index_data[5:0])||(6'd48 == index_data[11:6])||(6'd48 == index_data[17:12])||(6'd48 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[49] = ((6'd49 == index_data[5:0])||(6'd49 == index_data[11:6])||(6'd49 == index_data[17:12])||(6'd49 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[50] = ((6'd50 == index_data[5:0])||(6'd50 == index_data[11:6])||(6'd50 == index_data[17:12])||(6'd50 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[51] = ((6'd51 == index_data[5:0])||(6'd51 == index_data[11:6])||(6'd51 == index_data[17:12])||(6'd51 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[52] = ((6'd52 == index_data[5:0])||(6'd52 == index_data[11:6])||(6'd52 == index_data[17:12])||(6'd52 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[53] = ((6'd53 == index_data[5:0])||(6'd53 == index_data[11:6])||(6'd53 == index_data[17:12])||(6'd53 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[54] = ((6'd54 == index_data[5:0])||(6'd54 == index_data[11:6])||(6'd54 == index_data[17:12])||(6'd54 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[55] = ((6'd55 == index_data[5:0])||(6'd55 == index_data[11:6])||(6'd55 == index_data[17:12])||(6'd55 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[56] = ((6'd56 == index_data[5:0])||(6'd56 == index_data[11:6])||(6'd56 == index_data[17:12])||(6'd56 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[57] = ((6'd57 == index_data[5:0])||(6'd57 == index_data[11:6])||(6'd57 == index_data[17:12])||(6'd57 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[58] = ((6'd58 == index_data[5:0])||(6'd58 == index_data[11:6])||(6'd58 == index_data[17:12])||(6'd58 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[59] = ((6'd59 == index_data[5:0])||(6'd59 == index_data[11:6])||(6'd59 == index_data[17:12])||(6'd59 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[60] = ((6'd60 == index_data[5:0])||(6'd60 == index_data[11:6])||(6'd60 == index_data[17:12])||(6'd60 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[61] = ((6'd61 == index_data[5:0])||(6'd61 == index_data[11:6])||(6'd61 == index_data[17:12])||(6'd61 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[62] = ((6'd62 == index_data[5:0])||(6'd62 == index_data[11:6])||(6'd62 == index_data[17:12])||(6'd62 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 
// assign data[63] = ((6'd63 == index_data[5:0])||(6'd63 == index_data[11:6])||(6'd63 == index_data[17:12])||(6'd63 == index_data[23:18]))?{8'h11,8'h00,8'h00}:{8'h00,8'h00,8'h00}; 


integer i;
integer j;
parameter snake_len = 4;
parameter  max_len= 4'd8;
always @ (*)  begin
    for (i = 0; i < 64; i = i + 1) begin
        data[i] = {8'h00, 8'h00, 8'h00};
        for (j = 0; j < snake_len; j = j + 1) begin
            data[i] = ((i == (index_data[(6*max_len-1) - (j * 6) -: 5])) ? {8'h11, 8'h00, 8'h00} : {8'h00, 8'h00, 8'h00});
        end
    end
end



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

