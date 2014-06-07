
//=======================================================
//  Generic binary counter module
//=======================================================

module counter (

  //////////// CLOCK //////////
  clk,
  //////////// RESET (ACTIVE LOW) //////////  
  rst_n,
  //////////// ENABLE //////////  
  ena,
  //////////// COUNTER OUTPUT //////////
  q
);

//=======================================================
//  PARAMETER declarations
//=======================================================

  //////////// WIDTH OF COUNTER //////////
  parameter width = 8; 

//=======================================================
//  PORT declarations
//=======================================================

  //////////// CLOCK //////////
  input                 clk;
  //////////// RESET (ACTIVE LOW) //////////  
  input                 rst_n;
  //////////// ENABLE //////////  
  input                 ena;
  //////////// COUNTER OUTPUT //////////
  output  [width-1:0]   q;
  
//=======================================================
//  REG/WIRE declarations
//=======================================================  

  reg     [width-1:0]   q;

//=======================================================
//  Structural coding
//=======================================================  
  
  // Counter process
  always @ ( posedge clk or negedge rst_n )
  begin: q_out_proc
    if ( !rst_n ) 
    begin
      q <= 1'b0;
    end 
    else if ( ena )
    begin
      q <= q + 1'b1;
    end
  end
  
endmodule
