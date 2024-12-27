module vending_machine_tb;
    reg clk;                    
    reg rst;                   
    reg [3:0] coin;            
    reg [1:0] select;           
    wire deliver_A, deliver_B, deliver_C, deliver_D;
    wire [3:0] change;         

    vending_machine_4_products_rtl dut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .select(select),
        .deliver_A(deliver_A),
        .deliver_B(deliver_B),
        .deliver_C(deliver_C),
        .deliver_D(deliver_D),
        .change(change)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    
    initial begin
      
        $monitor("Time: %d, Reset: %b, Coin: %d, Select: %b, Deliver A: %b, Deliver B: %b, Deliver C: %b, Deliver D: %b, Change: %d",
                 $time, rst, coin, select, deliver_A, deliver_B, deliver_C, deliver_D, change);


        rst = 1;
        coin = 0;
        select = 0;

        // Apply reset
        #10 rst = 0;

        // Test case 1: Insert coins and buy Product A (Price_A = 15)
        #10 coin = 4'd5;         
        #10 coin = 4'd10;        
        #10 select = 2'b00;      
        #20 coin = 0;            

        // Test case 2: Insert coins and buy Product B (Price_B = 20)
        #30 coin = 4'd10;      
        #10 coin = 4'd10;       
        #10 select = 2'b01;      
        #20 coin = 0;           

        // Test case 3: Overpay for Product C (Price_C = 25)
        #30 coin = 4'd10;        
        #10 coin = 4'd10;       
        #10 coin = 4'd10;       
        #10 select = 2'b10;     
        #20 coin = 0;            

        // Test case 4: Exact payment for Product D (Price_D = 30)
        #30 coin = 4'd10;  
        #10 coin = 4'd10;     
        #10 coin = 4'd10;        
        #10 select = 2'b11;     
        #20 coin = 0;           

     
        #30 rst = 1;            
        #10 rst = 0;


        #50 $finish;
    end

endmodule

