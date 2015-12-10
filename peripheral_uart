module peripheral_uart #(parameter clk_freq = 100000000 , parameter baud = 115200 )(clk , rst , cs , addr , rd , wr, d_in , d_out , uart_tx , uart_rx ); 
    
  input clk;			//UART: clk
  input rst;			//UART: reset
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;
   //PINS UART hacia el bluetooth
   output uart_tx;		//pin por el que se envían bit a bit los datos al bluetooth | UART: uart_txd
   input uart_rx;		//pin por el que se recive bit a bit los datos al bluetooth | UART: uart_rxd 

//------------------------------------ regs and wires-------------------------------			

wire [7:0] rx_data; 		

wire [7:0] tx_data; 		

wire uart_busy;  		

wire uart_error;			

wire uart_avail; 			

reg rx_ack;			

reg tx_wr;			

assign tx_data = d_in[7:0];

always @(negedge clk) begin//-------------------- escritura de registros

//assign

	
if (rst) begin
		tx_wr <=0;	
		rx_ack <=0;	
		d_out<= 16'h0;
end else begin
		tx_wr <=0;	
		rx_ack <=0;	
		d_out<= 16'h0;
	    if (cs && wr && ~uart_busy &&(addr==4'b0000))  begin //data tx
			tx_wr <=1;
		end  
		else if (cs && rd)  begin	

			case (addr)
				4'b0000:begin  d_out[7:0]<= rx_data; rx_ack <=1;end //data rx 
//				4'b0000:begin  d_out[7:0]<= 8'h0f; rx_ack <=1;end //data rx 
				4'b0010:begin  d_out[0]<= uart_avail;  end 	//avail
				4'b0100:begin  d_out[0]<= uart_error;  end	//error
				4'b0110:begin  d_out[0]<= uart_busy;   end	//busy
				default:begin  d_out<=0; end  
			endcase
		end
	end
end

uart #(
	.freq_hz(clk_freq),
	.baud(baud)
) uart0 (
	.tx_busy(uart_busy),			
	.uart_rxd(uart_rx),  			
	.uart_txd(uart_tx), 			
	.tx_wr(tx_wr),	
	.tx_data(tx_data), 			
	.rx_data(rx_data), 			
	.rx_avail(uart_avail),
	.rx_error(uart_error),
	.rx_ack(rx_ack),
	.clk(clk), 			
	.reset(rst));


endmodule
