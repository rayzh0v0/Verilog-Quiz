// 测试程序（tb_async_fifo.sv）
`timescale 1ns/1ps

module top_tb;

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;
parameter DEPTH = 2**ADDR_WIDTH;

logic wr_clk = 0;
logic rd_clk = 0;
logic wr_rst = 0;
logic rd_rst = 0;
logic wr_en;
logic [DATA_WIDTH-1:0] wr_data;
logic full;
logic rd_en;
logic [DATA_WIDTH-1:0] rd_data;
logic empty;

async_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) dut (.*);

// 时钟生成
always #5 wr_clk = ~wr_clk;  // 100MHz
always #10 rd_clk = ~rd_clk; // 50MHz

// 测试数据生成
logic [DATA_WIDTH-1:0] test_data[$];
logic [DATA_WIDTH-1:0] received_data[$];

// 主测试程序
initial begin
    // 复位
    wr_rst = 1; rd_rst = 1;
    #20;
    wr_rst = 0; rd_rst = 0;
    #10;
    
    fork
        write_process();
        read_process();
    join
    
    verify_data();
    $display("Test completed");
    $finish;
end

// 写进程
task write_process;
    automatic int write_count = 0;
    while(write_count < 2*DEPTH) begin
        @(negedge wr_clk);
        wr_en = ($urandom_range(0,3) > 0) && !full;
        if(wr_en && !full) begin
            wr_data = $urandom();
            test_data.push_back(wr_data);
            write_count++;
        end
    end
    #100;
endtask

// 读进程
task read_process;
    automatic int read_count = 0;
    while(read_count < 2*DEPTH) begin
        @(negedge rd_clk);
        rd_en = ($urandom_range(0,3) > 0) && !empty;
        if(rd_en && !empty) begin
            received_data.push_back(rd_data);
            read_count++;
        end
    end
endtask

// 数据校验
task verify_data;
    if(test_data.size() != received_data.size()) begin
        $error("Data size mismatch! Sent: %0d, Received: %0d", 
              test_data.size(), received_data.size());
        return;
    end
    
    foreach(test_data[i]) begin
        if(test_data[i] !== received_data[i]) begin
            $error("Data mismatch at index %0d: Sent 0x%h, Received 0x%h",
                  i, test_data[i], received_data[i]);
            return;
        end
    end
    $display("All data verified successfully!");
endtask

// 监控
always @(posedge wr_clk) begin
    if(wr_en && !full) begin
        $display("[%0t] WR: 0x%h", $time, wr_data);
    end
end

always @(posedge rd_clk) begin
    if(rd_en && !empty) begin
        $display("[%0t] RD: 0x%h", $time, rd_data);
    end
end

endmodule