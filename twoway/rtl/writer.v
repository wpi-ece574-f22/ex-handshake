module writer( 
	       input wire 	 clk,
	       input wire 	 reset,
	       output wire [7:0] q,
	       output wire 	 req,
	       input wire 	 ack);
   
   localparam S00 = 1, S01 = 2, S10 = 3, S11 = 4;
   
   reg [2:0] 			 wstate, wstate_next;
   reg [7:0] 			 d, d_next;
   
   always @(posedge clk, posedge reset)
     if (reset)
       begin
	  d <= 8'b0;
	  wstate <= S00;
       end
     else
       begin
	  d <= d_next;
	  wstate <= wstate_next;
       end
   
   reg reqvar;
   reg [7:0] qvar;
   
   assign q = qvar;
   assign req = reqvar;
   
   always @(*)
     begin
	qvar   = 8'b0;
	
	d_next = d + 1;
	wstate_next = wstate;
	
	case (wstate)
	  S00:
	    begin
	    reqvar = 1'b0;
	    if (($random & 63) > 48)
		 wstate_next = S01;
	    end
	  
	  S01:
	    begin
	       reqvar = 1'b1;
	       if (ack)
		    wstate_next = S11;
	    end
	  
	  S11:
	    begin
	       reqvar = 1'b1;
	       qvar = d;
	       wstate_next = S10;
	    end
	  
	  S10:
	    begin
	       reqvar = 1'b0;	       
	       if (!ack)
		 wstate_next = S00;
	    end

	  default:
	    wstate_next = S00;
	endcase
	
     end
   
endmodule
