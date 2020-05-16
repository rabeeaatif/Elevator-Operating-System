/************************************************************************************
*     The UART design files are owned and controlled by Eleptic Technologies    	*
*	  and must be used only for laboratory experiments for the course "Digital   	*
*     Logic Design" offered in Habib University. It is not allowed to edit these 	*
*	  files without prior permission from Eleptic Technologies. Furthermore, the 	*
*	  design files can only be used with the Eleptic Technologies devices and/or 	*
*	  software. Use with non-Eleptic devices or softwares is strictly prohibited 	*
*     and immediately terminates your license.                                 		*
*                                                              		                *
*	  File Name:	top.v															*
*	  Developer:	Hasan Baig														*
*	  Vendor: 		Eleptic Technologies											*
*	  Date:			October 03, 2019.												*
*																					*
*     (c) Copyright 2019-2020 Eleptic Technologies,                                 *
*     All rights reserved.                                          	            *
************************************************************************************/


module top
#(
parameter	M	=	40000000/38400/16, //put value of clock 40000000, baud rate 38400
			N	=	8
)
(
	input clk,
	input reset,
	input rx,
	input [7:0] data_from_exHW,
	output tx,
	output [7:0] data_to_exHW
	
);

wire [7:0] data_to_SW;
wire [7:0] data_from_SW;

//assign counter_data = {4'b0000,count[3:0]};

ex_interface ex_int
(
	.data_from_exHW(data_from_exHW),
	.data_to_exHW(data_to_exHW),
	.data_to_SW(data_to_SW),
	.data_from_SW(data_from_SW)
);

	uart_top #( .M(M), .N(N))
	UART
	(
		.clk(clk),
		.reset(reset),
		.data_to_tx(data_to_SW),
		.data_from_rx(data_from_SW),
		//.rx_done(),
		.rx(rx),
		.tx(tx)
	);

endmodule  
