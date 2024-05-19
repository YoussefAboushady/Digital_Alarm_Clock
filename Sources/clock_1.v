//MODULE FOR DIGITAL ALARM CLOCK

module clock_1(
    //module inputs
    input clk,
    input reset,
    input enable,
    input [4:0] press,  //input of pressing each push button
    
    //module outputs
    output [6:0] segments,
    output [3:0] anode_active,
    output [15:12] leds,
    output reg led0,
    output decimal
    );
    
wire clk_count, clk_adjust; //2 clocks: 1 Hz and 200 Hz
wire [1:0] sel; //select digit to be displayed
reg [3:0] num;  //value to be displayed on 7-segment
wire [19:0] count;  //clock time
wire [19:7] alarm;  //alarm time

wire [4:0] signal;  //output signal of each push button 

reg [2:0] state, next_state;

parameter [2:0] Clock=3'd0, Alarm=3'd1, TimeHour=3'd2, TimeMinutes=3'd3, AlarmHour=3'd4, AlarmMinutes=3'd5;   //state encoding 

wire en_min1, en_min10; //wires to enable counters

//registers to enable different adjust modes
reg enable_seconds, up, down, input_clk, enable_adjust_clock_hours, enable_adjust_clock_mins, enable_adjust_Alarm_hours, enable_adjust_Alarm_mins;

//clock dividers (1 Hz, 200 Hz)
clockdivider #(250000) clk_for_count (.clk(clk), .reset(reset), .clk_out(clk_count)); // 1 Hz 
clockdivider #(250000) clk_for_adjust (.clk(clk), .reset(reset), .clk_out(clk_adjust)); // 200 Hz

//detect button pressing
Pushbutton_Detector det_up (.X(press[0]), .clk(clk_adjust) , .reset(reset), .Z(signal[0])); //BTNU
Pushbutton_Detector det_down (.X(press[2]), .clk(clk_adjust) , .reset(reset), .Z(signal[2])); //BTND

Pushbutton_Detector det_center (.X(press[4]), .clk(clk_adjust) , .reset(reset), .Z(signal[4])); //BTNC

Pushbutton_Detector det_right (.X(press[1]), .clk(clk_adjust) , .reset(reset), .Z(signal[1])); //BTNR 
Pushbutton_Detector det_left (.X(press[3]), .clk(clk_adjust) , .reset(reset), .Z(signal[3])); //BTNL

//TIME ADJUSTMENT

//seconds ones
binary_counter #(4,10) time_sec_1(.clk(clk_count),.reset(reset),.enable(enable_seconds),.up(up),.down(down),.count(count[3:0]));
wire rst;
assign rst =  count[10:7]==9 & count[13:11]==5 &count[17:14]==3 &count[19:18]==2;

//seconds tens
assign en_clk_sec10 =enable_seconds ? (count[3:0]==4'd9): 0;
binary_counter #(3,6) time_sec_10(.clk(clk_count),.reset(reset|rst),.enable(en_clk_sec10),.up(up),.down(down),.count(count[6:4]));

//minutes ones
assign en_clk_min1 =enable_seconds ? (count[6:4]==3'd5)&&(count[3:0]==4'd9) : enable_adjust_clock_mins;
binary_counter #(4,10) time_min_1(.clk(clk_count),.reset(reset|rst),.enable(en_clk_min1),.up(up),.down(down),.count(count[10:7]));

//minutes tens
wire enable_clk_sec0 ;
 assign enablesec0_mins_tens=  enable_adjust_clock_mins ?  up : (down ? reset : led0);
assign en_min10 = enable_seconds ? (count[10:7]==4'd9)&(count[6:4]==3'd5)&(count[3:0]==4'd9) :(enable_adjust_clock_mins ?  (up ? count[10:7]==9 :  (down?(count[10:7] == 0):0)) : 0);
binary_counter #(3,6) time_min_10(.clk(clk_count),.reset(reset|rst),.enable(en_min10),.up(up),.down(down),.count(count[13:11]));

//hours ones
assign en_clk_h1 = enable_seconds ? (count[13:11]==3'd5)&(count[10:7]==4'd9)& (count[6:4]==3'd5) & (count[3:0]==4'd9) : enable_adjust_clock_hours;
binary_counter #(4,10) time_hour_1(.clk(clk_count),.reset(reset|rst),.enable(en_clk_h1),.up(up),.down(down),.count(count[17:14]));

//hours tens
assign en_clk_h10 =enable_seconds ? ((count[17:14]==4'd3)&(count[13:11]==3'd5)&(count[10:7]==4'd9)& (count[6:4]==3'd5) & (count[3:0]==4'd9)&& enable_seconds) :(enable_adjust_clock_hours ? (up ? count[17:14]==9:down?  ~(count[17:14] == 0 & count[19:18] == 0)&count[17:14] == 0  : 0): 0);
binary_counter #(2,3) time_hour_10(.clk(clk_count),.reset(reset|rst),.enable(en_clk_h10),.up(up),.down(down),.count(count[19:18]));

///////////////////////////////////////////////////////////////////////////////////////////////////

//ALARM ADJUSTMENT 

//minutes ones
assign en_alarm_min1 = enable_adjust_Alarm_mins;
binary_counter #(4,10) alarm_min_1(.clk(clk_count),.reset(reset|rst),.enable(en_alarm_min1),.up(up),.down(down),.count(alarm[10:7]));

//minutes tens
//wire enablesec0 ;
// assign enablesec0_mins_tens=  enable_adjust_Alarm_mins ?  up : (down ? reset : led0);
assign en_alarm_min10 = enable_adjust_Alarm_mins ?  (up ? alarm[10:7]==9 :  (down?(alarm[10:7] == 0):0)) : 0;
binary_counter #(3,6) alarm_min_10(.clk(clk_count),.reset(reset|rst),.enable(en_alarm_min10),.up(up),.down(down),.count(alarm[13:11]));

//hours ones
assign en_alarm_h1 = enable_adjust_Alarm_hours;
binary_counter #(4,10) alarm_hour_1(.clk(clk_count),.reset(reset|rst),.enable(en_alarm_h1),.up(up),.down(down),.count(alarm[17:14]));

//hours tens
assign en_alarm_h10 =enable_adjust_Alarm_hours ? (up ? alarm[17:14]==9:down?  ~(alarm[17:14] == 0 & alarm[19:18] == 0)&alarm[17:14] == 0  : 0): 0;
binary_counter #(2,3) alarm_hour_10(.clk(clk_count),.reset(reset|rst),.enable(en_alarm_h10),.up(up),.down(down),.count(alarm[19:18]));

//7-segment display
binary_counter #(2, 4) digit_select (.clk(clk_adjust), .reset(reset), .enable(1'b1),.up(1'b1),.down(1'b0), .count(sel));
BCD bcd (.num(num), .enable(enable_seconds), .sel(sel), .segments(segments), .anode_active(anode_active), .decimal(decimal),.clk(clk_count));

//choose what to show on 7-segment display
always @(*) begin
    if(~((state==AlarmHour) | (state==AlarmMinutes))) begin
        case (sel)
            2'b00: num = count[10:7];
            2'b01: num = {1'b0, count[13:11]};
            2'b10: num = count[17:14];
            2'b11: num = {2'b00, count[19:18]};
        endcase        
    end
   
end

//next state generation
always @ (*) begin
    case(state)
        Clock: begin
            if(count == alarm) begin
               led0 = 0;
               enable_seconds = 1;
               next_state = Alarm;     
               up=1;
               down=0;        
               input_clk = clk_count;   
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;             
            end
           
            if(signal[4]) begin
               led0 = 0;
               enable_seconds = 0;
               next_state = TimeHour;
               up=1;
               down=0;         
               input_clk = clk_adjust; 
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                       
                                                     
            end
            
            else begin 
               led0 = 0;
               enable_seconds = 1;
               next_state = Clock;
               up=1;
               down=0;     
               input_clk = clk_count;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;  
                                                            
            end
        end
            
        Alarm: begin
            enable_seconds = 1;
            if(signal[0] | signal[1] | signal[2] | signal[3] | signal[4]) begin 
                led0 = ~led0;
                enable_seconds = 1; 
                next_state = Clock;
                up=1;
                down=0; 
               input_clk = clk_count;   
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                     
            end
            else begin   
                led0 = ~led0;
                enable_seconds = 1; 
                next_state = Alarm;
                up=1;
                down=0;     
                input_clk = clk_count;  
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                             
            end
        end
            
        TimeHour: begin
            if(signal[0]) begin // up
                led0 = 1;
                next_state = TimeHour;
                enable_seconds = 0;
                up=1;
                down=0;
               input_clk = clk_adjust;  
               enable_adjust_clock_hours = 1;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                      
            end 
            
            else if(signal[2]) begin // down
                led0 = 1;
                next_state = TimeHour;
                enable_seconds = 0;
                up=0;
                down=1;
               input_clk = clk_adjust;
               enable_adjust_clock_hours = 1;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                        
            end 
            
            else if(signal[1]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = TimeMinutes;
                up=1;
                down=0;     
               input_clk = clk_adjust;    
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                            
            end
            
            else if(signal[4]) begin   
                led0 = 1;
                enable_seconds = 0; 
                next_state = Clock;
                up=1;
                down=0;                 
                input_clk = clk_count;   
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                                    
            end
            else begin   
                led0 = 1;
                enable_seconds = 0; 
                next_state = TimeHour;  
                up=1;
                down=0;      
               input_clk = clk_adjust;    
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                                                    
            end
        end
        
        TimeMinutes: begin
            enable_seconds = 0;
            if(signal[0]) begin
                led0 = 1;
                enable_seconds = 0;
                up=1;
                down=0;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 1;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                 
            end 
            
            else if(signal[2]) begin
                led0 = 1;
                enable_seconds = 0;
                up=0;
                down=1;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 1;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                 
            end 
            
            else if(signal[1]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = AlarmHour;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                 
            end
            
            else if(signal[3]) begin 
                led0 = 1;
                enable_seconds = 0; 
                next_state = TimeHour;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
                   
            else if(signal[4]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = Clock;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;                 
            end
            
            else begin   
                led0 = 1;
                enable_seconds = 0; 
                next_state = TimeMinutes; 
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
        end

        AlarmHour: begin
            enable_seconds = 0;
            if(signal[0]) begin
                led0 = 1;
                enable_seconds = 0;
                up=1;
                down=0;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 1;
               enable_adjust_Alarm_mins = 0; 
            end 
            
            else if(signal[2]) begin
                led0 = 1;
                enable_seconds = 0;
                up=0;
                down=1;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 1;
               enable_adjust_Alarm_mins = 0; 
            end 
            
            else if(signal[1]) begin
                led0 = 1;
                enable_seconds = 0; 
                next_state = AlarmMinutes;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
            
            else if(signal[3]) begin 
            led0 = 1;
            enable_seconds = 0; 
            next_state = TimeMinutes;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0;             
            end
            
            else if(signal[4]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = Clock;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
            
            else begin   
                led0 = 1;
                enable_seconds = 0; 
                next_state = AlarmHour; 
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
        end

        AlarmMinutes: begin
            enable_seconds = 0;
            if(signal[0]) begin
                led0 = 1;
                enable_seconds = 0;
                up=1;
                down=0;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 1; 
            end 
            
            else if(signal[2]) begin
                led0 = 1;
                enable_seconds = 0;
                up=0;
                down=1;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 1; 
            end 
            
            else if(signal[3]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = AlarmHour;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
            
            else if(signal[4]) begin  
                led0 = 1;
                enable_seconds = 0; 
                next_state = Clock;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
            
            else begin   
                led0 = 1;
                enable_seconds = 0; 
                next_state = AlarmMinutes;
               enable_adjust_clock_hours = 0;
               enable_adjust_clock_mins = 0;
               enable_adjust_Alarm_hours= 0;
               enable_adjust_Alarm_mins = 0; 
            end
        end 
        
        default: next_state = Clock;    
    endcase

end

//state register
always @ (posedge clk_adjust or posedge reset) begin
    if(reset)   state <= Clock;
    else    state <= next_state;
end

//display leds
assign leds[15] = (state==TimeHour);
assign leds[14] = (state==TimeMinutes);
assign leds[13] = (state==AlarmHour);
assign leds[12] = (state==AlarmMinutes);

endmodule
