
//=======================================================
//  Generic pulse generator.
//  It holds clk_out active for only 1 clock cycle,
//  which means that the derived clock signal does not 
//  have a 50% duty cycle.
//=======================================================

module pulse_gen (
  clk,
  rst_n,
  clk_out
);

//=======================================================
//  PARAMETER declarations
//=======================================================
  
  // div=(clk_freq)/(2*clk_out_freq)
  parameter div   = 32'd50000000;
  // width of the counter
  parameter width = 32;

//=======================================================
//  PORT declarations
//=======================================================

  input             clk;
  input             rst_n;
  // divided clock output
  output            clk_out;
  
//=======================================================
//  REG/WIRE declarations
//=======================================================  
  reg               clk_out;
  reg [width-1:0]   cnt;

//=======================================================
//  Structural coding
//=======================================================  

  always @ ( posedge clk or negedge rst_n )
  begin: cnt_proc
    if ( !rst_n )    
    begin
      cnt <= 1'b0;
    end      
    else  
    begin
      if ( cnt == div )
      begin
        cnt <= 1'b0;
      end
      else
      begin
        cnt <= cnt + 1'b1;
      end            
    end    
  end
  
  always @ ( posedge clk or negedge rst_n )
  begin: clk_out_proc
    if ( !rst_n )
    begin
      clk_out <= 1'b0;
    end      
    else  
    begin
      if (cnt == div)
      begin
        clk_out <= 1'b1;
      end
      else
      begin
        clk_out <= 1'b0;
      end
    end
  end
  
endmodule
