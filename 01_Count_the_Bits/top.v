`timescale  1ns / 1ps
module top (
	input [31:0] data,
	output wire [5:0] result
);

wire [1:0] stage0 [0:15];
wire [2:0] stage1 [0:7];
wire [3:0] stage2 [0:3];
wire [4:0] stage3 [0:1];

genvar i;
// stage0
generate
	for(i=0; i<16; i=i+1) begin
		assign stage0[i] = data[i*2+1] + data[i*2];
	end
endgenerate

// stage1
generate
	for(i=0; i<8; i=i+1) begin
		assign stage1[i] = stage0[i*2+1] +stage0[i*2];
	end
endgenerate

// stage2
generate
	for(i=0; i<4; i=i+1) begin
		assign stage2[i] = stage1[i*2+1] +stage1[i*2];
	end
endgenerate

// stage3
generate
	for(i=0; i<2; i=i+1) begin
		assign stage3[i] = stage2[i*2+1] +stage2[i*2];
	end
endgenerate

assign result = stage3[0] + stage3[1];
	
endmodule

