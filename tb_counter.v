module testbench_10bit_counter;

	reg clk;
	reg rstn;
	reg load;
	reg [9:0] load_count_value;
	wire [9:0] count_out;
	integer error_count;
	reg [9:0] rand_count_value;
	integer total_incr_value;

	dut_counter_10bit dut_counter_10bit_inst(
		.clk(clk),
		.rstn(rstn),
		.load(load),
		.load_count_value(load_count_value),
		.count_out(count_out)
);
		
	always #5 clk = ~clk;

	initial begin
		clk = 1'b0;
		error_count = 0;
		repeat(10)
			begin
				rand_count_value = $urandom_range({10{1'b1}},0);
				total_incr_value = $urandom_range(100, 200);

				load_count(rand_count_value);
				check_count(rand_count_value, total_incr_value);
			end
		if(error_count == 0)
			$display("TEST PASSED");
     		else
			$display("TEST FAILED");
    		$finish;
	end
	
	task load_count(input [9:0] value);
	begin
		$display("load_count_value: %0d", value);
		@(posedge clk);
		load <= 1;
		load_count_value <= value;
		@(posedge clk);
		load <= 0;
		load_count_value <= 10'h0;
	end
	endtask

	task check_count(input [9:0] rand_count_value, input integer total_incr_value);
	begin
		reg [9:0] count_final;
		count_final = rand_count_value + total_incr_value;
		//$display("total_incr_value: %0h",total_incr_value);
		repeat(total_incr_value) begin
			@(posedge clk);
		end
		#1;
		if(count_out != count_final) begin
			$display("[%0tns] Error: Max count check: Expected count_out to be 0x%0d but found 0x%0d", $time, count_final, count_out);
			error_count = error_count + 1;
		end
	end
	endtask

endmodule
