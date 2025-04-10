`timescale 1ns / 1ps

module top (
    input wire clk,        // Main clock input
    input wire rst_n,      // Active-low reset signal
    output wire clk_div3,  // Clock divided by 3
    output wire clk_div5   // Clock divided by 5
);

// ========== 3-division begin ==========
reg [1:0] count3;          // 2-bit counter for divide-by-3 (values 0-2)
reg clk_div3_pos;          // Positive edge generated clock
reg clk_div3_neg;          // Negative edge generated clock

// Counter logic 
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
        count3 <= 2'b0;
    end
    else begin
        if(count3 == 2'd2)
            count3 <= 2'b0;
        else
            count3 <= count3 + 1'b1;
    end
end

// Positive edge clock generation
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        clk_div3_pos <= 1'b0;
    end
    else begin
        clk_div3_pos <= (count3 == 2'd0) ? 1'b1 : 1'b0;
    end
end

// Negative edge clock generation 
always @(negedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        clk_div3_neg <= 1'b0;
    end
    else begin
        clk_div3_neg <= clk_div3_pos;
    end
end

// Combine both edges to get 50% duty cycle
assign clk_div3 = clk_div3_pos | clk_div3_neg;
// ========== 3-division end ==========

// ========== 5-division begin ==========
reg [2:0] count5;          // 3-bit counter for divide-by-5 (values 0-4)
reg clk_div5_pos;          // Positive edge generated clock
reg clk_div5_neg;          // Negative edge generated clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
        count5 <= 3'd0;
    end
    else begin
        if(count5 == 3'd4)
            count5 <= 3'd0;
        else
            count5 <= count5 + 1'b1; 
    end
end

// Positive edge clock generation
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
        clk_div5_pos <= 1'b0;
    end
    else begin
        clk_div5_pos <= (count5 < 3'd2) ? 1'b1 : 1'b0;
    end
end

// Negative edge clock generation
always @(negedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin 
        clk_div5_neg <= 1'b0;
    end
    else begin
        clk_div5_neg <= clk_div5_pos;
    end
end

// Combine both edges to get 50% duty cycle
assign clk_div5 = clk_div5_pos | clk_div5_neg;
// ========== 5-division end ==========

endmodule