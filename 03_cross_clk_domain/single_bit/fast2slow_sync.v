module fast2slow_sync (
  input  wire clk_fast,
  input  wire clk_slow,
  input  wire rst_n,
  input  wire data_in,
  output reg  data_out
);

reg toggle_fast;
reg [2:0] sync_slow;

// Fast domain: Toggle on input pulse
always @(posedge clk_fast or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    toggle_fast <= 1'b0;
  end else if (data_in) begin
    toggle_fast <= ~toggle_fast;
  end
  else begin
    toggle_fast <= toggle_fast;
  end
end

// Slow domain: Synchronize toggle signal
always @(posedge clk_slow or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    sync_slow <= 3'b0;
  end else begin
    sync_slow <= {sync_slow[1:0], toggle_fast};
  end
end

// Edge detection
always @(posedge clk_slow or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    data_out <= 1'b0;
  end else begin
    data_out <= (sync_slow[2] ^ sync_slow[1]);
  end
end

endmodule