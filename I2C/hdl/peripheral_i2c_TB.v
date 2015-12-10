`timescale 1ns / 1ps

`define SIMULATION


module peripheral_i2c_TB;

	// entradas
	reg 	clk;
	reg 	rst;
	reg 	[15:0]d_in;
   	reg 	cs;
   	reg 	[3:0]addr;
   	reg 	rd;
   	reg 	wr;
   	wire 	[15:0]d_out;
	wire 	scl;
	wire 	sda;


//eventos for
reg [20:0] i;
//event reset_trigger;

	// Instanciacion Unit Under Test (UUT)
	peripheral_i2c uut (
    .clk(clk), 
    .rst(rst), 
    .addr(addr), 
    .d_in(d_in), 
    .d_out(d_out), 
    .rd(rd), 
    .wr(wr), 
    .cs(cs), 
    .scl(scl), 
    .sda(sda)
    );

	initial begin	// Inicializar entradas
	
		rst = 1;
		clk = 0;
		
		// esperar 100 ns por un reset global
		#10;
      		rst = 0;
					
	end
	
   
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	
	initial begin
	#OFFSET;
	forever 
	  begin
	  clk =1'b0;
	  #(PERIOD - (PERIOD*DUTY_CYCLE)) clk=1'b1;
	  #(PERIOD*DUTY_CYCLE);
	end
	end
	


 initial begin // Reset the system, Start the image capture process
      forever begin 
//inicializar
		d_in = 8'hE5; addr = 4'b0000; cs=1; rd=0; wr=1; //prerl   reloj fpga 450 MHz
		for(i=0; i<8; i=i+1) begin @ (posedge clk);// 
       		end
		d_in = 8'h09; addr = 4'b0001; cs=1; rd=0; wr=1; //prerh   REVISAR RELOJ Y EQUIVALENCIA
		for(i=0; i<8; i=i+1) begin @ (posedge clk);// 
       		end		

		d_in = 8'h80; addr = 4'b0010; cs=1; rd=0; wr=1; //INICIALIZE ctr
//WRITE

		 for(i=0; i<8; i=i+1) begin @ (posedge clk);//1. txr MPU_SLAVE_ADDR = 0xD2
       		end
 		d_in = 8'hD2; addr = 4'b0011; cs=1; rd=0; wr=1;
		
		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //2. cr 90
       		end
 		d_in = 8'h90; addr = 4'b0100; cs=1; rd=0; wr=1;	

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //3. SR 00000010 = 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=0; wr=1;	// 00000010

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //4. Set TXR with a slave memory address for the data to be written to
       		end
 		d_in = 8'h18; addr = 4'b0011; cs=1; rd=0; wr=1;	// MPU_GYRO(ACC)_FS_RANGE h18 = d24

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //5. Set CR with 8’h10 to enable a WRITE to send to the slave memory address.
		end
		d_in = 8'h10; addr = 4'b0100; cs=1; rd=0; wr=1;

 		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //6. Check the TIP bit of SR, to make sure the command is done. 2? o 0?
       		end
 		d_in = 8'h02; addr = 8'b0100; cs=1; rd=0; wr=1;	// 00000010

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //7. Set TXR with 8-bit data for the slave device.
		end
		d_in = 8'hB6; addr = 4'b0011; cs=1; rd=0; wr=1; // dato ejemplo hB6=d182

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //8. Set CR with 8’h10 to enable a WRITE to send data.
		end
		d_in = 8'h10; addr = 4'b0100; cs=1; rd=0; wr=1;

 		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //9. Check the TIP bit of SR, to make sure the command is done. 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=0; wr=1;

// loop  10. Repeat steps 7 to 9 to continue to send data to the slave device.

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //11. Set TXR with 8-bit data for the slave device.
		end
		d_in = 8'hB6; addr = 4'b0011; cs=1; rd=0; wr=1; // dato ejemplo hB6=d182

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //12. Set CR with 8’h50 to enable a WRITE to send data, and stop.
		end
		d_in = 8'h50; addr = 4'b0100; cs=1; rd=0; wr=1;

// Read

		 for(i=0; i<8; i=i+1) begin @ (posedge clk);//1. txr MPU_SLAVE_ADDR = 0xD2
       		end
 		d_in = 8'hD2; addr = 4'b0011; cs=1; rd=1; wr=0;
		
		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //2. cr 90
       		end
 		d_in = 8'h90; addr = 4'b0100; cs=1; rd=1; wr=0;	

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //3. SR 00000010 = 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=1; wr=0;	// 00000010

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //4. Set TRX with the slave memory address, where the data is to be read from.
       		end
 		d_in = 8'h3B; addr = 4'b0011; cs=1; rd=1; wr=0;	// MPU_GYRO(ACC)_FS_RANGE h18 = d24

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //5. Set CR with 8’h10 to enable a WRITE to send to the slave memory address.
		end
		d_in = 8'h10; addr = 4'b0100; cs=1; rd=1; wr=0;

 		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //6. Check the TIP bit of SR, to make sure the command is done. 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=1; wr=0;	// 00000010

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //7. Set TRX with a value of Slave address + READ bit.
		end
		d_in = 8'h78; addr = 4'b0011; cs=1; rd=1; wr=0; // 3C.... h78=d120

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //8. Set CR with 8’h10 to enable a WRITE to send data.
		end
		d_in = 8'h90; addr = 4'b0100; cs=1; rd=1; wr=0;

 		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //9. Check the TIP bit of SR, to make sure the command is done. 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=1; wr=0;

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //10. Set CR with 8’h10 to enable a WRITE to send data.
		end
		d_in = 8'h20; addr = 4'b0100; cs=1; rd=1; wr=0;

 		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //11. Check the TIP bit of SR, to make sure the command is done. 2? o 0?
       		end
 		d_in = 8'h02; addr = 4'b0100; cs=1; rd=1; wr=0;

// loop  12. Repeat steps 10 to 11 to continue.

		 for(i=0; i<8; i=i+1) begin @ (posedge clk); //13. cr 28 NACK stop
       		end
 		d_in = 8'h28; addr = 4'b0100; cs=1; rd=1; wr=0;	

  initial begin: TEST_CASE
     $dumpfile("peripheral_i2c_TB.vcd");
     $dumpvars(1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*200) $finish;
   end

	  
endmodule
