// synopsys translate_off
//`include "..\..\testbench\verilog\timescale.v"
//`include "timescale.v"
// synopsys translate_on
`timescale 1ns / 10ps

module peripheral_i2c( clk, rst, addr, d_in, d_out, rd, wr, cs,	scl, sda);
	////scl_pad_i, scl_pad_o, scl_padoen_o, sda_pad_i, sda_pad_o, sda_padoen_o );

	// inputs & outputs
	//

	// wishbone signals
	input        	clk;    	// master clock input
	input        	rst;     	// synchronous active high reset
	input 		cs;
  	input 		[3:0]addr; 	// 4 LSB from j1_io_addr
  	input 		rd;
  	input 		wr;
	input  		[15:0] d_in;     // databus input
	output reg	[15:0] d_out;    // databus output
	inout scl, sda; 

	//
	// variable declarations
	//


    // registers declaration             
	wire  	[15:0] prer; // clock prescale register 
	wire  	[ 7:0] ctr;  // control register        	
	wire  	[ 7:0] txr;  // transmit register       	
	wire 	[ 7:0] rxr;  // receive register         	
	wire  	[ 7:0] cr;   // command register        	
	wire 	[ 7:0] sr;   // status register          	
	
	// done signal: command completed, clear command register
	wire done;

	// core enable signal
	wire core_en;
	wire ien;

	// status register signals
	wire irxack;
/*	reg  rxack;       // received aknowledge from slave
	reg  tip;         // transfer in progress 
	reg  irq_flag;    // interrupt pending flag */
	wire i2c_busy;    // bus busy (start signal detected)
	wire i2c_al;      // i2c bus arbitration lost
/*	reg  al;          // status register arbitration lost bit */

	// status signals between byte controller and bit controller
	wire [3:0] core_cmd; // output from byte controller to input of bit controller
	wire core_txd;       // output from byte controller to input of bit controller
	wire core_ack, core_rxd; // output from bit controller to input of byte controller

	// assign scl and sda to individual wires
        wire scl_pad_i = scl;
	wire scl_pad_o;       
	wire scl_padoen_o; 

        wire sda_pad_i = sda;     
	wire sda_pad_o;       
	wire sda_padoen_o; 

	//
	// module body
	//

	// generate internal reset
	wire rst_i = rst;

	// generate wishbone signals
	wire wacc = cs & wr; 
	
        // decode command register
	wire sta  = cr[7];
	wire sto  = cr[6];
	wire rd1  = cr[5];
	wire wr1  = cr[4];
	wire ack  = cr[3];
	wire iack = cr[0];

	// decode control register
	assign core_en = ctr[7];
	assign ien = ctr[6];


        
	// assign DAT_O
	always @(posedge clk)
	begin
		if(cs & rd)
	  case (addr) // synopsis parallel_case
	    4'b0000: d_out <= #1 prer[ 7:0];
	    4'b0010: d_out <= #1 prer[15:8];
	    4'b0100: d_out <= #1 ctr;
	    4'b0110: d_out <= #1 rxr; // write is transmit register (txr)
	    4'b1000: d_out <= #1 sr;  // write is command register (cr)
	    4'b1010: d_out <= #1 txr;
	    4'b1100: d_out <= #1 cr;
	    4'b1110: d_out <= #1 0;   // reserved
	  endcase
	end
	

	// hookup byte controller block
	i2c_master_byte_ctrl byte_controller (
		.clk      ( clk     ),
		.rst      ( rst     ),
		.nReset   ( rst_i        ),
		//.ena      ( core_en      ),
		.clk_cnt  ( prer         ),
		.start    ( sta          ),
		.stop     ( sto          ),
		.read     ( rd1           ),
		.write    ( wr2           ),
		.ack_in   ( ack          ),
		.din      ( txr          ),
		.cmd_ack  ( done         ),
		.ack_out  ( irxack       ),
		.dout     ( rxr          ),
		//.i2c_busy ( i2c_busy     ),
		.i2c_al   ( i2c_al       ),
		//.scl_i    ( scl_pad_i    ),
		//.scl_o    ( scl_pad_o    ),
		//.scl_oen  ( scl_padoen_o ),
		//.sda_i    ( sda_pad_i    ),
		//.sda_o    ( sda_pad_o    ),
		//.sda_oen  ( sda_padoen_o ),
		.core_cmd ( core_cmd     ),
		.core_ack ( core_ack      ),
		.core_txd ( core_txd     ),
		.core_rxd ( core_rxd     )
	);
	
	i2c_master_bit_ctrl bit_controller (
		.clk     ( clk ),
		.rst     ( rst ),
		.nReset  ( rst_i    ),
		.ena     ( core_en  ),
		.clk_cnt ( prer     ),
		.cmd     ( core_cmd ),
		.cmd_ack ( core_ack ),
		.busy    ( i2c_busy ),
		.al      ( i2c_al   ),  // output to other modules
		.din     ( core_txd ),
		.dout    ( core_rxd ),
		.scl_i   ( scl_pad_i),
		.scl_o   ( scl_pad_o),
		.scl_oen ( scl_padoen_o ),
		.sda_i   ( sda_pad_i),
		.sda_o   ( sda_pad_o),
		.sda_oen ( sda_padoen_o  )
	);
	      
	i2c_master_registers registers(
		  .wb_clk_i(clk), 
		  .rst_i(rst_i), 
		  .wb_rst_i(rst),
		  .wb_dat_i(d_in),
                  .wb_wacc(wacc), 
                  .wb_adr_i(addr),
                  .i2c_al(i2c_al), 
                  .i2c_busy(i2c_busy),
                  .done(done),
                  //.sta(sta),
                  .irxack(irxack),
                  //.rd(rd), 
                  //.wr(wr),
                  //.iack(iack),
		  .prer(prer),                  
		  .ctr(ctr), 
                  .txr(txr), 
                  .cr(cr),
                  .sr(sr)
                  );
                  
          // generate scl and sda pins
	  assign scl = (scl_padoen_o ? 1'bz : scl_pad_o);
	  assign sda = (sda_padoen_o ? 1'bz : sda_pad_o);
	  
	  

endmodule
