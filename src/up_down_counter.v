
//=======================================================
//  Generic up-down counter module
//=======================================================

module up_down_counter (
  clk,
  rst_n,
  ena,
  q
);

//=======================================================
//  PARAMETER declarations
//=======================================================

  parameter width = 8;

//=======================================================
//  PORT declarations
//=======================================================

  input                 clk;
  input                 rst_n;
  input                 ena;
  output  [width-1:0]   q;
  
//=======================================================
//  REG/WIRE declarations
//=======================================================  

  wire      [width-1:0]   q;
  reg       [width-1:0]   cnt;
  // up=1 => counting up, up=0 => counting down
  reg                     up;

//=======================================================
//  Structural coding
//=======================================================  
  
  assign q = cnt;
  
  always @ ( posedge clk or negedge rst_n )
  begin: cnt_proc
    if ( !rst_n ) 
    begin
      cnt <= 1'b0;
    end 
    else if ( ena )
    begin
      if (up == 1'b1 )
      begin
        cnt <= cnt + 1'b1;
      end
      else
      begin
        cnt <= cnt - 1'b1;
      end
    end
  end
  
  always @ ( posedge clk or negedge rst_n )
  begin: up_down_proc
    if ( !rst_n ) 
    begin
      up <= 1'b1;
    end 
    else if ( ena )
    begin
      if ( cnt == 2**width - 2)
      begin
        up <= 1'b0; // count down
      end
      else if ( cnt == 1'b1 )
      begin
        up <= 1'b1; // count up
      end
    end
  end  
  
endmodule
