module tb;
  reg clk_fast;
  reg clk_slow;
  reg rst_n;

  // Clock generation
  initial begin
    clk_fast = 0;
    forever #5 clk_fast = ~clk_fast; // 100MHz
  end

  initial begin
    clk_slow = 0;
    forever #15 clk_slow = ~clk_slow; // ~33.3MHz
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // DUT instances
  reg  data_fast;
  wire data_slow;
  fast2slow_sync u_fast_to_slow (
    .clk_fast(clk_fast),
    .clk_slow(clk_slow),
    .rst_n(rst_n),
    .data_in(data_fast),
    .data_out(data_slow)
  );

  reg  data_slow_in;
  wire data_fast_out;
  slow2fast_sync u_slow_to_fast (
    .clk_fast(clk_fast),
    .rst_n(rst_n),
    .data_in(data_slow_in),
    .data_out(data_fast_out)
  );

  // Test procedure
  initial begin
    data_fast = 0;
    data_slow_in = 0;

    // Reset phase
    #20;

    // Test fast-to-slow
    $display("\nTesting Fast-to-Slow...");
    @(posedge clk_fast);
    data_fast <= 1;
    @(posedge clk_fast);
    data_fast <= 0;

    fork
      begin
        wait(data_slow === 1'b1);
        $display("Pulse successfully transferred to slow domain!");
        repeat(2) @(posedge clk_slow);
        if (!data_slow) $display("Fast-to-Slow test PASSED");
        else $display("Fast-to-Slow test FAILED");
      end
      begin
        #500;
        $display("Fast-to-Slow test TIMEOUT");
		test_fail();
        $finish;
      end
    join_any

    // Test slow-to-fast
    $display("\nTesting Slow-to-Fast...");
    @(posedge clk_slow);
    data_slow_in <= 1;
    @(posedge clk_slow);
    data_slow_in <= 0;

    fork
      begin
        wait(data_fast_out === 1'b1);
        $display("Pulse successfully transferred to fast domain!");
        repeat(2) @(posedge clk_fast);
        if (!data_fast_out) $display("Slow-to-Fast test PASSED");
        else $display("Slow-to-Fast test FAILED");
      end
      begin
        #500;
        $display("Slow-to-Fast test TIMEOUT");
		test_fail();
        $finish;
      end
    join_any

	test_pass();
    $finish;
  end

  // Waveform dumping
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

task test_pass;
    begin
		$display(" ____   _    ____ ____  ");
		$display("|  _ \\ / \\  / ___/ ___| ");
		$display("| |_) / _ \\ \\___ \\___ \\ ");
		$display("|  __/ ___ \\ ___) |__) |");
		$display("|_| /_/   \\_\\____/____/ ");
	end
endtask

task test_fail;
    begin
        $display(" _____     _ _ ");
        $display("|  ___|_ _(_) |");
        $display("| |_ / _` | | |");
        $display("|  _| (_| | | |");
        $display("|_|  \\__,_|_|_|");
    end
endtask
endmodule