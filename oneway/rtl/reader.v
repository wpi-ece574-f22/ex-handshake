module reader( 
	       input wire 	clk,
	       input wire 	reset,
	       input wire [7:0] a,
	       input wire 	sync);
   
   localparam S0 = 0, S1 = 1;
   
   reg [1:0] 			state, state_next;
   reg [7:0] 			r, r_next;
   
   always @(posedge clk, posedge reset)
     if (reset)
       begin
	  r <= 8'b0;
	  state <= S0;
       end
     else
       begin
	  r <= r_next;
	  state <= state_next;
       end
   
   always @(*)
     begin
	state_next = state;
	
	case (state)
	  S0:
	    if (sync)
	      begin
		 r_next = a;
		 state_next = S1;
	      end
	  
	  S1:
	    if (!sync)
	      begin
		 state_next = S0;
	      end
	  
	  default:
	    state_next = S0;

	endcase
	
     end
   
endmodule
