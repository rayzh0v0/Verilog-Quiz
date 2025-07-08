module top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4  // depth is 2^ADDR_WIDTH
)(
    // Write ports
    input  wire                  wr_clk,
    input  wire                  wr_rst,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,

    // Read ports
    input  wire                  rd_clk,
    input  wire                  rd_rst,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty
);

localparam PTR_WIDTH = ADDR_WIDTH + 1;

// RAM
reg [DATA_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];

// Pointer and synconizer
reg [PTR_WIDTH-1:0] wr_ptr;
reg [PTR_WIDTH-1:0] rd_ptr;
reg [PTR_WIDTH-1:0] wr_ptr_sync, rd_ptr_sync;

wire [PTR_WIDTH-1:0] wr_ptr_gray, rd_ptr_gray;

// Gray code transform
assign wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1);
assign rd_ptr_gray = rd_ptr ^ (rd_ptr >> 1);

// Write pointer logic
always @(posedge wr_clk or posedge wr_rst) begin
    if (wr_rst) begin
        wr_ptr <= 0;
    end else if (wr_en && !full) begin
        wr_ptr <= wr_ptr + 1;
        mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
    end
end

// Read pointer logic
always @(posedge rd_clk or posedge rd_rst) begin
    if (rd_rst) begin
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        rd_ptr <= rd_ptr + 1;
    end
end

assign rd_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

// syncronizer (wr => rd)
always @(posedge rd_clk) begin
    wr_ptr_sync <= wr_ptr_gray;
    rd_ptr_sync <= wr_ptr_sync;
end

// syncronizer (rd => wr)
always @(posedge wr_clk) begin
    rd_ptr_sync <= rd_ptr_gray;
    wr_ptr_sync <= rd_ptr_sync;
end


// wire [PTR_WIDTH-1:0] wr_ptr_sync_bin = rd_ptr_sync ^ (rd_ptr_sync >> 1);
// wire [PTR_WIDTH-1:0] rd_ptr_sync_bin = wr_ptr_sync ^ (wr_ptr_sync >> 1);

assign full  = (wr_ptr_gray == {~rd_ptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                   rd_ptr_sync[PTR_WIDTH-3:0]});

assign empty = (rd_ptr_gray == wr_ptr_sync);


endmodule