module top();

reg CLOCK_50;

SingleCycleProcessor2 processor(
	.clock(CLOCK_50)
);

endmodule 