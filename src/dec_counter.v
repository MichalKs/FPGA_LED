
//=======================================================
//  Decimal counter module with carry
//=======================================================

module dec_counter (
  clk,
  rst_n,
  ena,
  c_out,
  q
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

  input         clk;
  input         rst_n;
  input         ena;
  // decimal carry output
  output        c_out;
  output [3:0]  q;

//=======================================================
//  REG/WIRE declarations
//=======================================================  

  wire            c_out;
  wire    [3:0]   q;
  reg     [3:0]   cnt;

//=======================================================
//  Structural coding
//=======================================================  
  
  assign q = cnt;
  
  always @ ( posedge clk or negedge rst_n )
  begin: cnt_proc
    if ( !rst_n ) 
    begin: q_out_proc
      cnt <= 4'b0000;
    end
    else if ( ena == 1'b1 )
    begin
      if ( cnt == 4'd9 ) 
      begin
        cnt <= 4'b0000;
      end
      else
      begin
        cnt <= cnt + 4'b0001;
      end
    end
  end
  
  assign c_out = ( cnt==4'd9 && ena==1'b1 ) ? 1'b1 : 1'b0;
  
  /*always @(posedge clk or negedge rst_n)
  begin: c_out_proc
    if (cnt==4'd9 && ena==1)
    begin
      c_out<=1;
    end
    else
    begin
      c_out<=0;
    end
  end*/
  
endmodule
