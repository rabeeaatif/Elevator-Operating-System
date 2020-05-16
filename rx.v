/************************************************************************************
*     The UART design files are owned and controlled by Eleptic Technologies    	*
*	  and must be used only for laboratory experiments for the course "Digital   	*
*     Logic Design" offered in Habib University. It is not allowed to edit these 	*
*	  files without prior permission from Eleptic Technologies. Furthermore, the 	*
*	  design files can only be used with the Eleptic Technologies devices and/or 	*
*	  software. Use with non-Eleptic devices or softwares is strictly prohibited 	*
*     and immediately terminates your license.                                 		*
*                                                              		                *
*	  File Name:	rx.v															*
*	  Developer:	Hasan Baig														*
*	  Vendor: 		Eleptic Technologies											*
*	  Date:			October 03, 2019.												*
*																					*
*     (c) Copyright 2019-2020 Eleptic Technologies,                                 *
*     All rights reserved.                                          	            *
************************************************************************************/

module rx
(
	input		clk, 
	input		reset,
	input		rx, 
	input		s_tick,
	
	output reg	rx_done_tick ,
	output wire [7:0] dout
);

parameter DBIT = 8, 	// data bits
SB_TICK = 16; 			// ticks for stop bits


// symbolic state declaration
localparam [1:0]
	idle 	= 2'b00,
	start 	= 2'b01,
	data 	= 2'b10,
	stop 	= 2'b11;

// signal declaration
reg [1:0] state_reg, state_next ;
reg [3:0] s_reg , s_next ;
reg [2:0] n_reg , n_next ;
reg [7:0] b_reg , b_next ;



always@(posedge clk , posedge reset )
begin
	if ( reset )
	begin
		state_reg	<= idle ;
		s_reg 		<= 0 ;
		n_reg 		<= 0 ;
		b_reg 		<= 0 ;
	end
	
	else
	begin
		state_reg 	<= state_next ;
		s_reg 		<= s_next ;
		n_reg 		<= n_next ;
		b_reg 		<= b_next ;
	end
end	

// FSMD next-state logic
always @(*)
begin
	state_next	= state_reg ;
	//rx_done_tick = 1'b0 ;
	s_next 		= s_reg ;
	n_next 		= n_reg ;
	b_next		= b_reg ;
	
	case ( state_reg )
		idle :
				begin
					if (!rx)
					begin
						state_next = start ;
						rx_done_tick = 1'b0;
						s_next = 0 ;
					end
				end
				
		start :
				begin
					if (s_tick)
						if (s_reg == 7)
						begin
							state_next = data ;
							s_next = 0 ;
							n_next = 0 ;
						end

					else
						s_next = s_reg + 1'b1 ;
				end		

		data :
				begin
					if (s_tick)
						if (s_reg == 15)
						begin
							s_next = 0 ;
							b_next = {rx , b_reg[7:1]} ;
						
							if (n_reg == (DBIT-1))
								state_next = stop ;
							else
								n_next = n_reg + 1'b1 ;
						end
						
					else
						s_next = s_reg + 1'b1 ;
				end		
		
		stop :
				begin
					if (s_tick)
						if (s_reg == (SB_TICK-1))
						begin
							state_next = idle ;
							rx_done_tick = 1'b1 ;
						end
			
					else
						s_next = s_reg + 1'b1;
				end
	endcase

end

// o u t p u t
assign dout = b_reg ;

endmodule

