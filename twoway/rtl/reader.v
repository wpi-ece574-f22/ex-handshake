module reader( 
	       input wire 	clk,
	       input wire 	reset,
	       input wire [7:0] a,
	       input wire 	req,
	       output wire 	ack);
   
   localparam S00 = 1, S01 = 2, S11 = 3, S10 = 4;
   
   reg [2:0] 			rstate, rstate_next;
   reg [7:0] 			r, r_next;
   
   always @(posedge clk, posedge reset)
     if (reset)
       begin
	  r <= 8'b0;
	  rstate <= S00;
       end
     else
       begin
	  r <= r_next;
	  rstate <= rstate_next;
       end
   
   reg ackvar;
   
   assign ack = ackvar;
   
   always @(*)
     begin
	rstate_next = rstate;
	
	case (rstate)
	  S00:
	    begin
	       ackvar = 1'b0;	       
	       if (req)
		 rstate_next = S01;
	    end
	  
	  S01:
	    begin
	       ackvar = 1'b0;
	       rstate_next = S11;
	    end
	  
	  S11:
	    begin
	       ackvar = 1'b1;
	       if (req)
		 r_next = a;
	       if (!req)
		 rstate_next = S10;
	    end
	  
	  S10:
	    begin
	       ackvar = 1'b1;
	       rstate_next = S00;
	    end

	  default:
	    rstate_next = S00;
	endcase
	
     end
   
endmodule
