module tbhandshake();

	reg clk;

	always
	begin
	clk = 0;
	#5;
	clk = 1;
	#5;
	end

	reg reset;
	wire [7:0] data;
	wire sync;

	writer dut1(.clk(clk), .reset(reset), .q(data), .sync(sync));
	reader dut2(.clk(clk), .reset(reset), .a(data), .sync(sync));

	initial
	  begin
             $dumpfile("trace.vcd");
             $dumpvars(0, tbhandshake);
	     
	     reset = 1'b1;
	     repeat (3) @(posedge clk);
	     reset = 1'b0;
	     repeat (1000) @(posedge clk);
	     $finish;
	     
	end

endmodule
