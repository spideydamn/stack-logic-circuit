`define NOP 2'b00
`define PUSH 2'b01 
`define POP 2'b10
`define GET 2'b11


module stack_behaviour_normal(
    inout wire[3:0] IO_DATA,
     
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX
    ); 

    reg [3:0] array [4:0];
    reg [2:0] index;

    reg[2:0] temp_ind;
        
    reg if_output;

    reg [3:0] DATA_in;
    reg [3:0] DATA_out;

    integer i;

    assign DATA_in = IO_DATA;
    assign IO_DATA = (if_output == 1 && CLK == 1) ? DATA_out : 4'bz;

    initial begin
        for (i = 0; i < 5; ++i) begin
            array[i] = 4'b0;
        end
        index = 4;
    end

    always @(posedge RESET) begin
        for (i = 0; i < 5; ++i) begin
            array[i] = 4'b0;
        end
        index = 4;
    end   

    always @(posedge CLK) begin
        if (RESET == 0) begin
            case (COMMAND)
                    `PUSH:  begin
                                index = (index + 1) % 5;
                                array[index] = DATA_in;

                                if_output = 0;
                            end

                    `POP:   begin
                                DATA_out = array[index];
                            
                                if (index == 0) begin
                                    index = 4;
                                end else begin
                                    index = index - 1;
                                end

                                if_output = 1;
                            end

                    `GET:   begin
                                temp_ind = index;
                                for (i = 0; i < INDEX; ++i) begin
                                    temp_ind -= 1;
                                    if (temp_ind == 7) begin
                                        temp_ind = 4;
                                    end
                                end
                                DATA_out = array[temp_ind];

                                if_output = 1;
                            end
                    `NOP: begin
                        if_output = 0;
                    end
                    endcase
                end 
    end
endmodule