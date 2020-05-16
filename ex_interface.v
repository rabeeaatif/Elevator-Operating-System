module ex_interface
(
input [7:0] data_from_SW,
input [7:0] data_from_exHW,
output [7:0] data_to_SW,
output [7:0] data_to_exHW
);
wire a_less_b, a_equal_b, a_greater_b;

assign data_to_SW = data_from_exHW;
comparator compare(.A(data_from_exHw[1:0]), .B(data_from_SW[1:0]), .A_less_B(a_less_b), 
.A_equal_B(a_equal_b), .A_greater_B(a_greater_b) )
if(a_less_b)
 assign data_to_exHw = 8b'00000001;
if(a_greater_b)
 assign data_to_exHw = 8b'00000000;


endmodule

