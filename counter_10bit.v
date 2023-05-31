module dut_counter_10bit(
	input clk,
	input rstn,
	input load,
	input [9:0] load_count_value,
	output reg [9:0] count_out
);

	always@(posedge clk) begin
		if(!rstn)
			count_out <= 0;
		else if(load)
			count_out <= load_count_value;
	//BUG	else if(count_out == 10'd654)
	//		count_out <= count_out + 2;
		else
			count_out <= count_out + 1;
	end
endmodule
