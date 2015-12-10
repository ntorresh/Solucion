module Mainn(
	
	input clk,
	input rst,
	
	//nuestras entradas son los switchs de la FPGA
	input sma,
	input rv1,
	input rv2, 
	input rh1,
	input rh2,
	input tm,
	input ta,
	input fm,
	input fa,
	
	//salidas los LEDs de la FPGA
	output soutp,
	output soutn,
	output soupp,
	output soupn
    );
	
	reg SMA;
	reg RST;
	reg [15:0]RV1;
	reg [15:0]RV2;
	reg [15:0]RH1;
	reg [15:0]RH2;
	reg [15:0]THM;
	reg [15:0]THA;
	reg [15:0]PHM;
	reg [15:0]PHA;
	
	
always @ (*) begin
	
	if(sma)begin SMA=1; end else begin SMA=0; end
	if(rv1)begin RV1=30; end else begin RV1=15; end
	if(rv2)begin RV2=40; end else begin RV2=15; end
	if(rh1)begin RH1=35; end else begin RH1=15; end
	if(rh2)begin RH2=45; end else begin RH2=15; end

	if(tm)begin THM='d30; end else begin THM=15; end
	if(ta)begin THA='d40; end else begin THA=15; end
	if(fm)begin PHM='d35; end else begin PHM=15; end
	if(fa)begin PHA='d45; end else begin PHA=15; end
	if(rst)begin RST=1; end else begin RST=0; end

end

control_movimiento instance_name (
	 .rst(RST),
    .sma(SMA), 
    .clk(clk), 
    .R_vertical_1(RV1), 
    .R_vertical_2(RV2), 
    .R_horizontal_1(RH1), 
    .R_horizontal_2(RH2), 
    .theta_manual(THM), 
    .theta_actual(THA),
    .phi_manual(PHM), 
    .phi_actual(PHA), 
    .s_out_theta_pos(soutp), 
    .s_out_theta_neg(soutn), 
    .s_out_phi_pos(soupp), 
    .s_out_phi_neg(soupn));
	 
endmodule
