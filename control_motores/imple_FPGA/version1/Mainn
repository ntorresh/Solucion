module Mainn(
	
	input clk,
	input rst,
	
	//nuestras entradas son los switchs de la FPGA
	input mover_manual_theta_pos,
	input mover_manual_theta_neg,
	input mover_manual_phi_pos,
	input mover_manual_phi_neg,
	
	input mover_auto_theta_pos,
	input mover_auto_theta_neg,
	input mover_auto_phi_pos,
	input mover_auto_phi_neg,
	
	//salidas los LEDs de la FPGA
	output soutp,
	output soutn,
	output soupp,
	output soupn
    );
	
	reg SMA;
	reg [15:0]RV1;
	reg [15:0]RV2;
	reg [15:0]RH1;
	reg [15:0]RH2;
	reg [15:0]THM;
	reg [15:0]THA;
	reg [15:0]PHM;
	reg [15:0]PHA;
	
always @ (*) begin
	RV1='d10;
	RV2='d10;
	RH1='d10;
	RH2='d10;
	THM='d10;
	THA='d10;
	PHM='d10;
	PHA='d10;

	///casos para mover manualmente
	if(mover_manual_theta_pos) begin
		SMA=1;
		THA='d40;
	end
	if(mover_manual_theta_neg) begin
		SMA=1;
		THM='d40;
	end
	if(mover_manual_phi_pos) begin
		SMA=1;
		PHA='d40;
	end
	if(mover_manual_phi_neg) begin
		SMA=1;
		PHM='d40;
	end


	///casos para mover automaticamente
	if(mover_auto_theta_pos) begin
		SMA=0;
		RV1='d40;
	end
	if(mover_auto_theta_neg) begin
		SMA=0;
		RV2='d40;
	end
	if(mover_auto_phi_pos) begin
		SMA=0;
		RH1='d40;
	end
	if(mover_auto_phi_neg) begin
		SMA=0;
		RH2='d40;
	end
	
end

control_movimiento instance_name (
	.rst(rst),
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
