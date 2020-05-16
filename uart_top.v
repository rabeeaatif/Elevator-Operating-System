/************************************************************************************
*     The UART design files are owned and controlled by Eleptic Technologies    	*
*	  and must be used only for laboratory experiments for the course "Digital   	*
*     Logic Design" offered in Habib University. It is not allowed to edit these 	*
*	  files without prior permission from Eleptic Technologies. Furthermore, the 	*
*	  design files can only be used with the Eleptic Technologies devices and/or 	*
*	  software. Use with non-Eleptic devices or softwares is strictly prohibited 	*
*     and immediately terminates your license.                                 		*
*                                                              		                *
*	  File Name:	uart_top.v														*
*	  Developer:	Hasan Baig														*
*	  Vendor: 		Eleptic Technologies											*
*	  Date:			October 03, 2019.												*
*																					*
*     (c) Copyright 2019-2020 Eleptic Technologies,                                 *
*     All rights reserved.                                          	            *
************************************************************************************/


module uart_top
#(
parameter	M	=	65, //put value of clock 40000000, baud rate 38400
			N	=	8
)
//This UART is designed to work with the clock of 40Mhz, with the baud rate of 38,400. This requires
//a change in M bits to value 65 in mod_m_counter.v file. 
(
	input 			clk, 
	input			reset, 
	input	[7:0]	data_to_tx,
	input			rx,
	output			tx,
	output 	[7:0]	data_from_rx
	//output			rx_done

);


wire s_tick , clk40M;
wire [7:0]	din;
wire tx_start;
wire rx_done_tick;
wire [7:0] dout;
wire [7:0] data_received_out;

assign rx_done = rx_done_tick;
assign data_from_rx = data_received_out;
assign	frame_out	=	din;

mod_m_counter #( .M(M), .N(N))
baud_gen_unit
( 
	.clk(clk), //.clk(clk40M), 
	.reset(reset), 
	.s_tick(s_tick)
);

rx uart_rx_unit
(
	.clk(clk), //.clk(clk40M), 
	.reset(reset), 
	.rx(rx),
	.s_tick(s_tick), 
	.rx_done_tick(rx_done_tick), 
	.dout(dout)
);

tx uart_tx_unit 
(
	.clk(clk), //.clk(clk40M), 
	.reset(reset), 
	.tx_start(tx_start), 
	.s_tick(s_tick),
	.din(din),
	.tx_done_tick(tx_done_tick),
	.tx(tx)
);

tx_rx_controller	controller
(
	.clk(clk), //.clk(clk40M), 
	.reset(reset),
	.data_to_tx(data_to_tx),
	.rx_done_tick(rx_done_tick),
	.data_received(dout),
	.tx_start(tx_start),
	.frame_out(din),
	.data_received_out(data_received_out)
	
);


endmodule
