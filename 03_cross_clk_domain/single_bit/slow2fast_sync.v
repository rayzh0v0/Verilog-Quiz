module slow2fast_sync (
  input  wire clk_fast,
  input  wire rst_n,
  input  wire data_in,
  output reg  data_out
);

reg [2:0] sync_fast;

// Synchronization chain
always @(posedge clk_fast or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    sync_fast <= 3'b0;
  end else begin
    sync_fast <= {sync_fast[1:0], data_in};
  end
end

// Edge detection
always @(posedge clk_fast or negedge rst_n) begin
  if (rst_n == 1'b0) begin
    data_out <= 1'b0;
  end else begin
    data_out <= sync_fast[2] && !sync_fast[1];
  end
end

endmodule