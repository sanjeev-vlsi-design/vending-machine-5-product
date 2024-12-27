# vending-machine-5-product
INPUTS
1. clk: Clock signal that drives state transitions.
2. rst: Reset signal that initializes the machine to its default state (Idle).
3. coin [3:0]: Coin input to accept values 5 or 10.
4. select [1:0]: Product selection signal:
o 00 → Product A
o 01 → Product B
o 10 → Product C
o 11 → Product D
OUTPUTS
1. deliver_A, deliver_B, deliver_C, deliver_D: Signals to dispense the 
selected product. Only one of these will be set to 1 when dispensing.
2. change [3:0]: Outputs the change to be returned if the inserted coins 
exceed the product price.
INTERNAL PARAMETERS
1. Product Prices:
o Price_A = 15, Price_B = 20, Price_C = 25, Price_D = 30.
2. States:
o Idle (S0): Waiting for a coin.
o Collect (S1): Collecting coins and checking the balance.
o Product (S2): Dispensing the product and calculating change.
REGISTERS
1. current_state: Tracks the current state of the FSM.
2. next_state: Holds the next state value, determined by the state transition 
logic.
3. balance: A 6-bit register to accumulate the coin balance.
State Transition Logic
 always @(posedge clk or posedge rst) begin
 if (rst) begin
 current_state <= Idle;
 balance <= 0;
 end else begin
 current_state <= next_state;
 end
 end
• On every clock edge:
o If the reset (rst) is high:
▪ The machine goes to the Idle state.
▪ The balance is reset to 0.
o Otherwise:
▪ current_state is updated to the next_state.
Next State and Output Logic
 always @(*) begin
 // Default outputs
 deliver_A = 0;
 deliver_B = 0;
 deliver_C = 0;
 deliver_D = 0;
 change = 0;
 next_state = current_state;
• Initializes all outputs (dispense signals and change) to 0.
• By default, the FSM remains in the current state unless specific 
conditions are met.
State diagram:
State Behavior
Idle State
 Idle: begin
 if (coin == 4'd5 || coin == 4'd10) begin
 next_state = Collect;
 balance = balance + coin;
 end
 end
• The vending machine waits for a coin input (5 or 10 units).
• When a coin is inserted:
o The machine transitions to the Collect state.
o The balance is updated by adding the coin value.
2. Collect State
 Collect: begin
 if (coin == 4'd5 || coin == 4'd10) begin
 balance = balance + coin;
 end
 // Check if balance is sufficient for the selected product
 case (select)
 2'b00: if (balance >= Price_A) next_state = Product;
 2'b01: if (balance >= Price_B) next_state = Product;
 2'b10: if (balance >= Price_C) next_state = Product;
 2'b11: if (balance >= Price_D) next_state = Product;
 endcase
 end
• In this state:
o Coins continue to be accepted and added to the balance.
o The machine checks if the balance is sufficient for the selected 
product (select).
▪ If the balance is greater than or equal to the product price, it 
transitions to the Product state.
3. Product State
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
 // Reset balance and return to Idle
 balance = 0;
 next_state = Idle;
 end
• In this state:
o The selected product is dispensed by activating the corresponding 
deliver_X signal.
change = balance - Price_<Selected_Product>;
(only if balance exceeds the product price).
o After dispensing, the balance is reset to 0, and the machine 
transitions back to the Idle state
