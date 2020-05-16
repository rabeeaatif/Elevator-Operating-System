/************************************************************************************
*     The UART design files are owned and controlled by Eleptic Technologies    	*
*	  and must be used only for laboratory experiments for the course "Digital   	*
*     Logic Design" offered in Habib University. It is not allowed to edit these 	*
*	  files without prior permission from Eleptic Technologies. Furthermore, the 	*
*	  design files can only be used with the Eleptic Technologies devices and/or 	*
*	  software. Use with non-Eleptic devices or softwares is strictly prohibited 	*
*     and immediately terminates your license.                                 		*
*                                                              		                *
*	  File Name:	mod_m_counter.v													*
*	  Developer:	Hasan Baig														*
*	  Vendor: 		Eleptic Technologies											*
*	  Date:			October 03, 2019.												*
*																					*
*     (c) Copyright 2019-2020 Eleptic Technologies,                                 *
*     All rights reserved.                                          	            *
************************************************************************************/

module mod_m_counter
#( parameter 	M=65, 	// mod-M // changing to 65 from 123
				N=8 	 // no of data bits  
)

(
	input	clk, 
	input	reset,
	output 	s_tick
);



// signal declaration

reg 	[N-1:0] r_reg;
wire 	[N-1:0] r_next ;

// body

always @ ( posedge clk , posedge reset)
begin
	if (reset)
		r_reg <= 0 ;
	else
		r_reg <= r_next;
end

// next-state logic
assign r_next = (r_reg == (M-1)) ? 0 : r_reg + 1'b1;

// output logic
//assign q = r_reg;
assign s_tick = (r_reg == (M-1)) ?  1'b1 : 1'b0;

endmodule


