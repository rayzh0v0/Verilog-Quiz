//~ `New testbench
`timescale  1ns / 1ps

module top_tb;

// top Parameters
parameter PERIOD  = 10;


// top Inputs
reg   [31:0]  data                         = 0 ;

// top Outputs
wire  [5:0]  result                        ;


top  u_top (
    .data                    ( data    [31:0] ),
    .result                  ( result  [5:0]  )
);

// Function to calculate expected result (reference model)
function automatic int count_ones(input logic [31:0] val);
	int cnt = 0;
	for (int i = 0; i < 32; i++) begin
		if (val[i]) cnt++;
	end
	return cnt;
endfunction

// Main test logic
initial begin
	// Fixed test cases
	$display("===== Fixed test cases =====");
	test_case(32'h00000000, 0);   // All 0s
	test_case(32'hFFFFFFFF, 32);   // All 1s
	test_case(32'hAAAAAAAA, 16);   // Alternating bits
	
	$display("");
	$display("===== Random test cases =====");
	// Random test cases (10 iterations)
	for (int i = 0; i < 10; i++) begin
		logic [31:0] rand_data;
		rand_data = $urandom();  // SystemVerilog random generation
		test_case(rand_data, count_ones(rand_data));
	end

	$display("");
	$display("All tests passed!");
    $display(" ____   _    ____ ____  ");
    $display("|  _ \\ / \\  / ___/ ___| ");
    $display("| |_) / _ \\ \\___ \\___ \\ ");
    $display("|  __/ ___ \\ ___) |__) |");
    $display("|_| /_/   \\_\\____/____/ ");
	
	$finish;
end

// Task to run a single test case
task test_case(input logic [31:0] test_data, input int expected_result);
	data = test_data;
	#10;  // Wait for propagation

	if (result !== expected_result) begin
		$error("Test failed! Data=%h, Expected=%0d, Got=%0d",
				test_data, expected_result, result);
		$finish;  // Halt on error
	end
	else begin
		$display("Test passed: Data=%h, 1's count=%0d",
					test_data, result);
	end
endtask

initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
end


endmodule