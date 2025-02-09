module I2C(
    input SDA,
    input SCL,
    input reset,
    output reg [7:0] R1 = 8'b00110100,
    output reg [7:0] R2 = 8'b10100011,
    output reg R_W,
    output reg [7:0] data,
    output reg [6:0] ads
);
    
    
    parameter Idle = 5'b00000,
              S1   = 5'b00001,
              S2   = 5'b00010,
              S3   = 5'b00011,
              S4   = 5'b00100,
              S5   = 5'b00101,
              S6   = 5'b00110,
              S7   = 5'b00111,
              RW   = 5'b01000,
              Ack1 = 5'b01001,
              D0   = 5'b01010,
              D1   = 5'b01011,
              D2   = 5'b01100,
              D3   = 5'b01101,
              D4   = 5'b01110,
              D5   = 5'b01111,
              D6   = 5'b10000,
              D7   = 5'b10001,
              Ack2 = 5'b10010;

    reg [4:0] state = Idle;
    reg [4:0] next_state = Idle;

    always @(posedge SCL or posedge reset) begin
        if (reset) begin
            state <= Idle;
            ads <= 7'b0;
            data <= 8'b0;
            R_W <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            Idle : next_state = (SDA == 0 && SCL == 1) ? S1 : Idle;
            S1   : begin 
                       next_state = S2;
                       ads = {ads[5:0], SDA}; // Shift left and append SDA
                       ads = ads << 1;
                   end
            S2   : begin 
                       next_state = S3;
                       ads = {ads[5:0], SDA};
                       ads = ads << 1;
                   end
            S3   : begin 
                       next_state = S4;
                       ads = {ads[5:0], SDA};
                       ads = ads << 1;
                   end
            S4   : begin 
                       next_state = S5;
                       ads = {ads[5:0], SDA};
                       ads = ads << 1;
                   end
            S5   : begin 
                       next_state = S6;
                       ads = {ads[5:0], SDA};
                       ads = ads << 1;
                   end
            S6   : begin 
                       next_state = S7;
                       ads = {ads[5:0], SDA};
                       ads = ads << 1;
                   end
            S7   : begin 
                       next_state = RW;
                       ads = {ads[5:0], SDA};
                   end
            RW   : begin 
                       next_state = Ack1;
                       R_W = SDA;
                   end
            Ack1 : next_state = (SDA == 0) ? D0 : Idle;
            D0   : begin 
                       next_state = D1;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D1   : begin 
                       next_state = D2;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D2   : begin 
                       next_state = D3;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D3   : begin 
                       next_state = D4;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D4   : begin 
                       next_state = D5;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D5   : begin 
                       next_state = D6;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D6   : begin 
                       next_state = D7;
                       data = {data[6:0], SDA};
                       data = data << 1;
                   end
            D7   : begin 
                       next_state = Ack2;
                       data = {data[6:0], SDA};
                   end
            Ack2 : next_state = (SDA == 0) ? Idle : D0;
            default : next_state = Idle;
        endcase
    end

    always @(*) begin
        if (R_W == 1'b0) begin
            if (ads == 7'b1000101) begin
                R2 = data;
            end
        end
    end

endmodule
