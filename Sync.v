module Q2(
  input  signal,
  input  clock,
  output  signal1
);

  reg dff1; 
  reg dff2; 
  
  always @(posedge clock) begin
    dff1 <= signal;
    dff2 <= dff1;
  end

  assign signal1 = dff2; 

endmodule