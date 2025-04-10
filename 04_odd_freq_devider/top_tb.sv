//~ `New testbench
`timescale  1ns / 1ps
module top_tb;

// top Parameters
parameter PERIOD  = 10; // 100Mhz = 10ns


// top Inputs
reg   clk                                  = 1 ;
reg   rst_n                                = 0 ;

// top Outputs
wire  clk_div3                             ;
wire  clk_div5                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

// Monitor signals
// initial begin
//     $timeformat(-9, 0, "ns", 6);
//     $monitor("At %t: clk=%b clk_div3=%b clk_div5=%b", $time, clk, clk_div3, clk_div5);
// end

// ========== Checker for 3-division begin ==========
logic [31:0] clk3_high_cnt = 0;
logic [31:0] clk3_period = 0;


// 3-division get edge time
always @(posedge clk_div3 or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        clk3_high_cnt <= 0;
    end
    else if (clk_div3 == 1'b1) begin
        clk3_high_cnt <= $time;
	end
    else begin
		clk3_high_cnt <= clk3_high_cnt;
    end
end

// 3-division period checker
always @(posedge clk_div3 or negedge rst_n) begin
	if (rst_n == 1'b0) begin
        clk3_period <= 0;
    end
    else if (clk3_high_cnt != 0) begin
		if ($time - clk3_high_cnt != 30) begin
			$error("3-div clock period error! Expected 30ns, got %0dns", $time - clk3_high_cnt);
			test_failed();
			$fatal(1);
		end
	end
end

// 3-division duty checker
always @(negedge clk_div3) begin
	if (clk3_high_cnt != 0) begin
		if ($time - clk3_high_cnt != 15) begin
			$error("3-div high time error! Expected 15ns, got %0dns", $time - clk3_high_cnt);
			test_failed();
			$fatal(1);
		end
	end
end

// ========== Checker for 3-division end ==========



// ========== Checker for 5division begin ==========
logic [31:0] clk5_high_cnt = 0;
logic [31:0] clk5_period = 0;


// 5-division get edge time
always @(posedge clk_div5 or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        clk5_high_cnt <= 0;
    end
    else if (clk_div5 == 1'b1) begin
        clk5_high_cnt <= $time;
	end
    else begin
		clk5_high_cnt <= clk5_high_cnt;
    end
end

// 5-division period checker
always @(posedge clk_div5) begin
	if (clk5_high_cnt != 0) begin
		if ($time - clk5_high_cnt != 50) begin
			$error("5-div clock period error! Expected 50ns, got %0dns", $time - clk5_high_cnt);
			test_failed();
			$fatal(1);
		end
	end
end

// 5-division duty checker
always @(negedge clk_div5) begin
	if (clk5_high_cnt != 0) begin
		if ($time - clk5_high_cnt != 25) begin
			$error("5-div high time error! Expected 25ns, got %0dns", $time - clk5_high_cnt);
			test_failed();
			$fatal(1);
		end
	end
end
// ========== Checker for 3-division end ==========


top  u_top (
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .clk_div3                ( clk_div3   ),
    .clk_div5                ( clk_div5   )
);


// Main test logic
initial begin
	#2;
	#(PERIOD*2) rst_n  =  1;
	
	$display("Run for 1000ns");
	#1000;

	$display("");
	$display("All tests passed!");
    $display(" ____   _    ____ ____  ");
    $display("|  _ \\ / \\  / ___/ ___| ");
    $display("| |_) / _ \\ \\___ \\___ \\ ");
    $display("|  __/ ___ \\ ___) |__) |");
    $display("|_| /_/   \\_\\____/____/ ");
	
	$finish;
end

task test_failed;
    begin
        $display(" _____     _ _ ");
        $display("|  ___|_ _(_) |");
        $display("| |_ / _` | | |");
        $display("|  _| (_| | | |");
        $display("|_|  \\__,_|_|_|");
    end
endtask

initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
end


endmodule