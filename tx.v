/************************************************************************************
*     The UART design files are owned and controlled by Eleptic Technologies    	*
*	  and must be used only for laboratory experiments for the course "Digital   	*
*     Logic Design" offered in Habib University. It is not allowed to edit these 	*
*	  files without prior permission from Eleptic Technologies. Furthermore, the 	*
*	  design files can only be used with the Eleptic Technologies devices and/or 	*
*	  software. Use with non-Eleptic devices or softwares is strictly prohibited 	*
*     and immediately terminates your license.                                 		*
*                                                              		                *
*	  File Name:	tx.v															*
*	  Developer:	Hasan Baig														*
*	  Vendor: 		Eleptic Technologies											*
*	  Date:			October 03, 2019.												*
*																					*
*     (c) Copyright 2019-2020 Eleptic Technologies,                                 *
*     All rights reserved.                                          	            *
************************************************************************************/


module tx
(
	input 		clk, 
	input 		reset ,
	input 		tx_start, 
	input 		s_tick ,
	input [7:0] din ,
	
	output reg	tx_done_tick ,
	output wire tx
);

parameter DBIT = 8 , 	// # data bits
SB_TICK = 16 ;			// # ticks for stop bits

// symbolic state declaration
localparam [1:0]
idle 	= 2'b00,
start 	= 2'b01,
data 	= 2'b10,
stop 	= 2'b11;

// signal declaration
reg [1:0]	state_reg , state_next ;
reg [3:0]	s_reg, s_next ;
reg [2:0]	n_reg , n_next ;
reg [7:0]	b_reg , b_next ;
reg 		tx_reg , tx_next ;
reg			s, count;

// FSMD state & data registers
always @ ( posedge clk , posedge reset )
begin
	if ( reset )
	begin
		state_reg	<= idle ;
		s_reg 		<= 0 ;
		n_reg 		<= 0 ;
		b_reg 		<= 0 ;
		tx_reg 		<= 1'b1 ;
	end
	
	else
	begin
		state_reg	<= state_next ;
		s_reg 		<= s_next ;
		n_reg 		<= n_next ;
		b_reg 		<= b_next ;
		tx_reg 		<= tx_next ;
	end
end
// FSMD next-state logic & functional units

always @ ( posedge clk , posedge reset )
begin
	if	(reset)
	begin
		s		<=	1'b0;	
		count	<=	1'b0;
	end
	
	else 
	begin	
		if (tx_start)
		begin
			if(count == 1'b0)
			begin
				s		<=	1'b1;	
				count	<=	1'b1;
			end
			
			else
				s		<=	1'b0;
		end
	
		else
		begin
			count	<=	1'b0;
			s		<=	1'b0;
		end
	end
end

always @(*)
begin
	state_next		= state_reg ;
	tx_done_tick	= 1'b0;
	s_next			= s_reg ;
	n_next 			= n_reg ;
	b_next 			= b_reg ;
	tx_next 		= tx_reg ;

	case ( state_reg )
		idle :
				begin
					tx_next = 1'b1 ;
					if (s)
					begin
						state_next = start ;
						s_next = 0 ;
						b_next = din;
					end
				end

		start :
				begin
					tx_next = 1'b0 ;
					if ( s_tick )
						if ( s_reg == 15 )
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
					tx_next = b_reg [0] ;
					if ( s_tick )
						if ( s_reg == 15 )
						begin
							s_next = 0 ;
							b_next = b_reg >> 1 ;
							if (n_reg == (DBIT-1))
								state_next = stop ;
							else
								n_next = n_reg + 1'b1;
						end
						else
							s_next = s_reg + 1'b1 ;
				end
		
		stop :
				begin
					tx_next = 1'b1 ;
					if ( s_tick )
						if (s_reg == (SB_TICK - 1 ))
						begin
							state_next = idle ;
							tx_done_tick = 1'b1 ;
						end
					else
					s_next = s_reg + 1'b1;
				end

	endcase

end

//output
assign tx = tx_reg ;

endmodule

