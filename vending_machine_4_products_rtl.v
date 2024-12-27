module vending_machine_4_products_rtl(
    input clk,             
    input rst,          
    input [3:0] coin,     
    input [1:0] select,   
    output reg deliver_A,
    output reg deliver_B, 
    output reg deliver_C,
    output reg deliver_D,
    output reg [3:0] change
);

    // Product prices
    localparam Price_A = 15;
    localparam Price_B = 20;
    localparam Price_C = 25;
    localparam Price_D = 30;

    // State definitions
    parameter Idle = 2'b00;        // s0 state
    parameter Collect = 2'b01;     // s1 state
    parameter Product = 2'b10;     // s2 state

    reg [1:0] current_state, next_state; // State variables
    reg [5:0] balance; // Tracks the current balance

    // State Transition Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= Idle;
            balance <= 0;
        end else begin
            current_state <= next_state;
            // Update balance in sequential logic
            if (current_state == Collect) begin
                if (coin == 4'd5 || coin == 4'd10)
                    balance <= balance + coin;
            end else if (current_state == Product) begin
                // Reset balance after dispensing product
                balance <= 0;
            end
        end
    end

    // Next State and Output Logic
    always @(*) begin
        // Default outputs
        deliver_A = 0;
        deliver_B = 0;
        deliver_C = 0;
        deliver_D = 0;
        change = 0;
        next_state = current_state;

        case (current_state)
            Idle: begin
                if (coin == 4'd5 || coin == 4'd10) begin
                    next_state = Collect;
                end
            end
            Collect: begin
                // Check if balance is sufficient for the selected product
                case (select)
                    2'b00: if (balance >= Price_A) next_state = Product;
                    2'b01: if (balance >= Price_B) next_state = Product;
                    2'b10: if (balance >= Price_C) next_state = Product;
                    2'b11: if (balance >= Price_D) next_state = Product;
                endcase
            end
            Product: begin
                case (select)
                    2'b00: deliver_A = 1;
                    2'b01: deliver_B = 1;
                    2'b10: deliver_C = 1;
                    2'b11: deliver_D = 1;
                endcase

                // Calculate and return change
                case (select)
                    2'b00: if (balance > Price_A) change = balance - Price_A;
                    2'b01: if (balance > Price_B) change = balance - Price_B;
                    2'b10: if (balance > Price_C) change = balance - Price_C;
                    2'b11: if (balance > Price_D) change = balance - Price_D;
                endcase

                // Return to Idle after dispensing product
                next_state = Idle;
            end
        endcase
    end
endmodule
