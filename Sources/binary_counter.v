//MODULE FOR COUNTER USED TO COUNT AND ADJUST TIME/ALARM

module binary_counter#(parameter x = 4, n = 12) //x: number of bits, n: maximum limit of counter (counter is mod n)
(input clk, reset, enable,  up, down, output reg [x-1:0]count);

    always @(posedge clk, posedge reset) begin
     if (reset == 1)
     count <= 0; //reset count
     else 
     if(enable)  
         if(up==1) begin    //increment counter
             if(count==n-1)
             count<=0;
             else 
             count<=count+1;
         end
         
         else if(down==1) begin //decrement counter
             if(count==0)
             count<=n-1;
             else 
             count<=count-1;
         end
    else 
        count <= count; //keep count as it is
    end
   
endmodule
