
//=======================================================
//  Main entity for LED blinking in Verilog
//  This project tests the outputs of different
//  counters with 8 LEDs.
//=======================================================

module FPGA_LED (

  //////////// CLOCK //////////
  CLOCK_50,
  //////////// LED //////////
  LED,
  //////////// KEY //////////
  KEY,
  //////////// SW //////////
  SW 
);

//=======================================================
//  PARAMETER declarations
//=======================================================



//=======================================================
//  PORT declarations
//=======================================================

  //////////// CLOCK //////////
  input           CLOCK_50;

  //////////// LED //////////
  output  [7:0]   LED;

  //////////// KEY //////////
  input   [1:0]   KEY;

  //////////// SW //////////
  input   [3:0]   SW;

//=======================================================
//  REG/WIRE declarations
//=======================================================

  wire rst_n;   // reset signal
  wire ena;     // enable signal
  wire clk;     // clock signal
  wire clk_1Hz; // LED blink clock signal
  wire c1_out;
  wire c2_out;
  wire [3:0] dec1_out;
  wire [3:0] dec2_out;
  wire [7:0] count1_out;
  wire [2:0] count2_out;
  wire [7:0] up_down1_out;
  wire [2:0] up_down2_out;
  wire [7:0] decoder1_out;
  wire [7:0] decoder2_out;

//=======================================================
//  Structural coding
//=======================================================

  // DE0-Nano board keys are active low.
  assign rst_n  = KEY[0];
  // We make ena active high (normally on).
  assign ena    = KEY[1];
  // 50 MHz clock for the DE0-Nano board
  assign clk    = CLOCK_50;

  // derive 1Hz frequency or other
  pulse_gen #(32'd25000000) pulse_gen1  (
    .clk      (clk),
    .rst_n    (rst_n),
    .clk_out  (clk_1Hz)
  );
  
  counter counter1 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (clk_1Hz),
    .q      (count1_out)
  );
  
  counter #(3) counter2 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (clk_1Hz),
    .q      (count2_out)
  );  
  
  dec_counter dec_counter1 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (clk_1Hz),
    .c_out  (c1_out),
    .q      (dec1_out)
  );

  dec_counter dec_counter2 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (c1_out),
    .c_out  (c2_out),
    .q      (dec2_out)
  );
  
  up_down_counter up_down1 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (clk_1Hz),
    .q      (up_down1_out)
  );
  
  // three bit up-down counter to drive LED decoder
  up_down_counter #(3) up_down2 (
    .clk    (clk),
    .rst_n  (rst_n),
    .ena    (clk_1Hz),
    .q      (up_down2_out)
  );
  
  decoder3x8 dec1 (
    .sel  (up_down2_out),
    .q    (decoder1_out)
  );

  decoder3x8 dec2 (
    .sel  (count2_out),
    .q    (decoder2_out)
  );
  
  assign LED = ( SW == 4'b0000 ) ? { dec2_out , dec1_out }:
               ( SW == 4'b0001 ) ? count1_out:
               ( SW == 4'b0010 ) ? up_down1_out:
               ( SW == 4'b0011 ) ? decoder1_out:
               ( SW == 4'b0100 ) ? decoder2_out:
               { SW , SW };
               
  //assign LED=enable?{SW,SW}:8'bzzzzzzzz;

endmodule
