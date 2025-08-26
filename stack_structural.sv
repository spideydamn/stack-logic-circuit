module stack_structural_normal(
   inout wire[3:0] IO_DATA, 
   
   input wire RESET, 
   input wire CLK, 
   input wire[1:0] COMMAND,
   input wire[2:0] INDEX
   ); 

   stack stack_(
      .IO_DATA(IO_DATA), .RESET(RESET), .CLK(CLK), .COMMAND(COMMAND), .INDEX(INDEX)
   );

endmodule



   /*******************************************************************************
   ** Gates                                                                      **
   *******************************************************************************/

module NOT_GATE(
   input wire input_,

   output wire result 
   );

   not(result, input_);

endmodule

module NOT_GATE_4_INPUTS(
   input wire input_[3:0],

   input wire result[3:0]
   );

   not(result[0], input_[0]);
   not(result[1], input_[1]);
   not(result[2], input_[2]);
   not(result[3], input_[3]);

endmodule


module AND_GATE(
   input wire input1,
   input wire input2,

   output wire result 
   );

   and(result, input1, input2);

endmodule

module AND_GATE_3_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,

   output wire result 
   );
   
   wire and_inputs_1_2;

   AND_GATE and_gate_1(input1, input2, and_inputs_1_2);
   AND_GATE and_gate_2(and_inputs_1_2, input3, result);

endmodule

module AND_GATE_4_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,
   input wire input4,

   output wire result 
   );
   
   wire and_inputs_1_2_3;

   AND_GATE_3_INPUTS and_gate_3_inputs(input1, input2, input3, and_inputs_1_2_3);
   AND_GATE and_gate(and_inputs_1_2_3, input4, result);

endmodule

module AND_GATE_5_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,
   input wire input4,
   input wire input5,

   output wire result 
   );

   wire and_inputs_1_2;
   wire and_inputs_3_4_5;

   AND_GATE and_gate_1(input1, input2, and_inputs_1_2);
   AND_GATE_3_INPUTS and_gate_3_inputs_(input3, input4, input5, and_inputs_3_4_5);
   AND_GATE and_gate_2(and_inputs_1_2, and_inputs_3_4_5, result);

endmodule

module NAND_GATE_3_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,

   output wire result 
   );

   wire and_inputs_1_2_3;

   AND_GATE_3_INPUTS and_gate_3_inputs(input1, input2, input3, and_inputs_1_2_3);

   NOT_GATE not_gate(and_inputs_1_2_3, result);

endmodule


module OR_GATE(
   input wire input1,
   input wire input2,

   output wire result 
   );

   or(result, input1, input2);

endmodule

module OR_GATE_3_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,

   output wire result 
   );

   wire or_inputs_1_2;

   OR_GATE or_gate_1(input1, input2, or_inputs_1_2);
   OR_GATE or_gate_2(or_inputs_1_2, input3, result);

endmodule

module OR_GATE_5_INPUTS(
   input wire input1,
   input wire input2,
   input wire input3,
   input wire input4,
   input wire input5,

   output wire result 
   );

   wire or_inputs_1_2;
   wire or_inputs_3_4_5;

   OR_GATE or_gate_1(input1, input2, or_inputs_1_2);
   OR_GATE_3_INPUTS or_gate_3_inputs_(input3, input4, input5, or_inputs_3_4_5);
   OR_GATE or_gate_2(or_inputs_1_2, or_inputs_3_4_5, result);

endmodule



   /*******************************************************************************
   ** DECODERS                                                                   **
   *******************************************************************************/

module decoder_2( 
   input wire A,

   output wire Z1,
   output wire Z0 
   );

   assign Z1 = A;

   NOT_GATE not_gate(A, Z0);

endmodule


module decoder_4(
   input wire S1,
   input wire S0,

   output wire Z3,
   output wire Z2,
   output wire Z1,
   output wire Z0 
   );

   wire decoder_2_1_z0;
   wire decoder_2_1_z1;

   wire decoder_2_2_z0;
   wire decoder_2_2_z1;


   decoder_2 decoder_2_1 (
      .A(S1),
      .Z0(decoder_2_1_z0), .Z1(decoder_2_1_z1));

   decoder_2 decoder_2_2 (
      .A(S0),
      .Z0(decoder_2_2_z0), .Z1(decoder_2_2_z1)
      );

   AND_GATE and_gate_3(
      decoder_2_1_z1, decoder_2_2_z1,
      Z3
      );

   AND_GATE and_gate_2(
      decoder_2_1_z1, decoder_2_2_z0,
      Z2
      );

   AND_GATE and_gate_1(
      decoder_2_1_z0, decoder_2_2_z1,
      Z1
      );

   AND_GATE and_gate_0(
      decoder_2_1_z0, decoder_2_2_z0,
      Z0
      );

endmodule

module decoder_8( 
   input wire S2,
   input wire S1,
   input wire S0,

   output wire Z7,
   output wire Z6,
   output wire Z5,
   output wire Z4,
   output wire Z3,
   output wire Z2,
   output wire Z1,
   output wire Z0 
   );


   wire decoder_2_1_z0; 
   wire decoder_2_1_z1;
   wire decoder_4_1_z0;
   wire decoder_4_1_z1;
   wire decoder_4_1_z2;
   wire decoder_4_1_z3;
   wire decoder_4_2_z0;
   wire decoder_4_2_z1;
   wire decoder_4_2_z2;
   wire decoder_4_2_z3;

   decoder_2 decoder_2_1 (
      .A(S2),
      .Z0(decoder_2_1_z0), .Z1(decoder_2_1_z1)
      );

   decoder_4 decoder_4_1 (
      .S0(S0), .S1(S1),
      .Z0(decoder_4_1_z0), .Z1(decoder_4_1_z1), .Z2(decoder_4_1_z2), .Z3(decoder_4_1_z3)
      );

   decoder_4 decoder_4_2 (
      .S0(S0), .S1(S1),
      .Z0(decoder_4_2_z0), .Z1(decoder_4_2_z1), .Z2(decoder_4_2_z2), .Z3(decoder_4_2_z3)
      );


   AND_GATE and_gate_7(
      decoder_2_1_z1, decoder_4_1_z3,
      Z7
      );

   AND_GATE and_gate_6(
      decoder_2_1_z1, decoder_4_1_z2,
      Z6
      );

   AND_GATE and_gate_5(
      decoder_2_1_z1, decoder_4_1_z1,
      Z5
      );

   AND_GATE and_gate_4(
      decoder_2_1_z1, decoder_4_1_z0,
      Z4
      );
      
   AND_GATE and_gate_3(
      decoder_2_1_z0, decoder_4_2_z3,
      Z3
      );

   AND_GATE and_gate_2(
      decoder_2_1_z0, decoder_4_2_z2,
      Z2
      );

   AND_GATE and_gate_1(
      decoder_2_1_z0, decoder_4_2_z1,
      Z1
      );

   AND_GATE and_gate_0(
      decoder_2_1_z0, decoder_4_2_z0,
      Z0
      );

endmodule



   /*******************************************************************************
   ** D TRIGGER                                                                  **
   *******************************************************************************/

module D_trigger(
   input wire SET,
   input wire D,               
   input wire C,
   input wire RESET,

   output wire Q,
   output wire NOT_Q
   );

   wire NOT_RESET;
   wire NOT_SET;
   wire NOT_D;


   wire nand_gate_3_inputs_1_output;
   wire nand_gate_3_inputs_2_output;


   NOT_GATE not_gate_1(RESET, NOT_RESET);
   NOT_GATE not_gate_2(SET, NOT_SET);
   NOT_GATE not_gate_3(D, NOT_D);

   NAND_GATE_3_INPUTS nand_gate_3_inputs_1(
      D, C, NOT_RESET, 
      nand_gate_3_inputs_1_output
      );

   NAND_GATE_3_INPUTS nand_gate_3_inputs_2(
      NOT_SET, NOT_D, C, 
      nand_gate_3_inputs_2_output
      );

   NAND_GATE_3_INPUTS nand_gate_3_inputs_3(
      NOT_SET, nand_gate_3_inputs_1_output, NOT_Q, 
      Q
      );

   NAND_GATE_3_INPUTS nand_gate_3_inputs_4(
      Q, nand_gate_3_inputs_2_output, NOT_RESET, 
      NOT_Q
      );


endmodule



   /*******************************************************************************
   ** DYNAMIC D TRIGGER                                                          **
   *******************************************************************************/

module dynamic_D_trigger(
   input wire SET,
   input wire D,
   input wire C,
   input wire RESET,
   
   output wire Q,
   output wire NOT_Q
   );

   wire NOT_C;

   NOT_GATE not_gate(C, NOT_C);


   D_trigger D_trigger_1(
      .SET(SET), .D(D), .C(C), .RESET(RESET),
      .Q(D_trigger_1_Q)
   );

   D_trigger D_trigger_2(
      .SET(SET), .D(D_trigger_1_Q), .C(NOT_C), .RESET(RESET),
      .Q(Q), .NOT_Q(NOT_Q)
   );

endmodule

   /*******************************************************************************
   ** INVERSE DYNAMIC D TRIGGER                                                  **
   *******************************************************************************/

module inverse_dynamic_D_trigger(
   input wire SET,
   input wire D,
   input wire C,
   input wire RESET,
   
   output wire Q,
   output wire NOT_Q
   );

   wire NOT_C;

   NOT_GATE not_gate(C, NOT_C);


   D_trigger D_trigger_1(
      .SET(SET), .D(D), .C(NOT_C), .RESET(RESET),
      .Q(D_trigger_1_Q)
   );

   D_trigger D_trigger_2(
      .SET(SET), .D(D_trigger_1_Q), .C(C), .RESET(RESET),
      .Q(Q), .NOT_Q(NOT_Q)
   );

endmodule



   /*******************************************************************************
   ** T TRIGGER                                                                  **
   *******************************************************************************/

module T_trigger( 
   input wire SET, 
   input wire T, 
   input wire RESET,

   output wire Q, 
   output wire NOT_Q);
   
   dynamic_D_trigger dynamic_D_trigger_(
      .SET(SET), .D(NOT_Q), .C(T), .RESET(RESET),
      .Q(Q), .NOT_Q(NOT_Q)
      );

endmodule



   /*******************************************************************************
   ** COUNTER                                                                    **
   *******************************************************************************/

module counter_mod5(
   input wire C,
   input wire dec_inc,
   input wire RESET,

   output wire Q2,
   output wire Q1,
   output wire Q0
   );

   wire decoder_2_Z1;
   wire decoder_2_Z0;
   
   wire NOT_Q1;
   wire NOT_Q0;
   wire NOT_Q2;

   wire and_gate_3_inputs_1_output;
   wire and_gate_3_inputs_2_output;

   wire and_gate_1_output;
   wire and_gate_2_output;

   wire or_gate_1_output;
   wire or_gate_2_output;

   wire and_gate_3_inputs_output;

   wire and_gate_4_inputs_1_output;
   wire and_gate_4_inputs_2_output;

   wire RESET_Q0;
   wire RESET_Q1;

   wire SET_Q2;

   decoder_2 decoder_2_(
      .A(dec_inc),
      .Z1(decoder_2_Z1), .Z0(decoder_2_Z0)
   );


   T_trigger T_trigger_1(
      .SET(and_gate_4_inputs_2_output), .T(C), .RESET(RESET_Q0),
      .Q(Q0), .NOT_Q(NOT_Q0)
   );

   T_trigger T_trigger_2(
      .SET(1'b0), .T(or_gate_1_output), .RESET(RESET_Q1),
      .Q(Q1), .NOT_Q(NOT_Q1)
   );

   T_trigger T_trigger_3(
      .SET(SET_Q2), .T(and_gate_3_inputs_output), .RESET(and_gate_4_inputs_1_output),
      .Q(Q2), .NOT_Q(NOT_Q2)
   );


   AND_GATE_3_INPUTS and_gate_3_inputs_1(
      decoder_2_Z1, C, Q0,
      and_gate_3_inputs_1_output
   );
   AND_GATE_3_INPUTS and_gate_3_inputs_2(
      NOT_Q0, C, decoder_2_Z0,
      and_gate_3_inputs_2_output
   );
   OR_GATE or_gate_1(
      and_gate_3_inputs_1_output, and_gate_3_inputs_2_output,
      or_gate_1_output
   );


   AND_GATE and_gate_1(
      decoder_2_Z1, Q1,
      and_gate_1_output
   );
   AND_GATE and_gate_2(
      NOT_Q1, decoder_2_Z0,
      and_gate_2_output
   );
   OR_GATE or_gate_2(
      and_gate_1_output, and_gate_2_output,
      or_gate_2_output
   );


   AND_GATE_3_INPUTS and_gate_3_inputs_(
      C, or_gate_1_output, or_gate_2_output,
      and_gate_3_inputs_output
   );



   AND_GATE_4_INPUTS and_gate_4_inputs_1(
      decoder_2_Z1, Q0, NOT_Q1, Q2,
      and_gate_4_inputs_1_output
   );

   AND_GATE_4_INPUTS and_gate_5_inputs_2(
      decoder_2_Z0, Q0, Q1, Q2,
      and_gate_4_inputs_2_output
   );


   OR_GATE_3_INPUTS RESET_Q0_gate(
      and_gate_4_inputs_1_output, RESET, and_gate_4_inputs_2_output,
      RESET_Q0
   );

   OR_GATE RESET_Q1_gate(
      RESET, and_gate_4_inputs_2_output,
      RESET_Q1
   );


   OR_GATE SET_Q2_gate_(
      and_gate_4_inputs_2_output, RESET,
      SET_Q2
   );
   
endmodule



   /*******************************************************************************
   ** D REGISTER 4BIT                                                            **
   *******************************************************************************/

module D_register_4(
    input wire SET,
    input wire D3,
    input wire D2,
    input wire D1,
    input wire D0,
    input wire C,
    input wire RESET,
    
    output wire Q3,
    output wire Q2,
    output wire Q1,
    output wire Q0
    );


    D_trigger D_trigger_1(
        .C(C),
        .D(D3),
        .NOT_Q(),
        .Q(Q3),
        .RESET(RESET),
        .SET(SET)
        );

    D_trigger D_trigger_2(
        .C(C),
        .D(D2),
        .NOT_Q(),
        .Q(Q2),
        .RESET(RESET),
        .SET(SET)
        );

    D_trigger D_trigger_3(
        .C(C),
        .D(D1),
        .NOT_Q(),
        .Q(Q1),
        .RESET(RESET),
        .SET(SET)
        );

    D_trigger D_trigger_4(
        .C(C),
        .D(D0),
        .NOT_Q(),
        .Q(Q0),
        .RESET(RESET),
        .SET(SET)
        );

endmodule



   /*******************************************************************************
   ** DYNAMIC D REGISTER 4BIT                                                    **
   *******************************************************************************/

module dynamic_D_register_4(
    input wire SET,
    input wire D3,
    input wire D2,
    input wire D1,
    input wire D0,
    input wire C,
    input wire RESET,
    
    output wire Q3,
    output wire Q2,
    output wire Q1,
    output wire Q0
    );


    inverse_dynamic_D_trigger inverse_dynamic_D_trigger_1(
        .C(C),
        .D(D3),
        .NOT_Q(),
        .Q(Q3),
        .RESET(RESET),
        .SET(SET)
        );

    inverse_dynamic_D_trigger inverse_dynamic_D_trigger_2(
        .C(C),
        .D(D2),
        .NOT_Q(),
        .Q(Q2),
        .RESET(RESET),
        .SET(SET)
        );

    inverse_dynamic_D_trigger inverse_dynamic_D_trigger_3(
        .C(C),
        .D(D1),
        .NOT_Q(),
        .Q(Q1),
        .RESET(RESET),
        .SET(SET)
        );

    inverse_dynamic_D_trigger inverse_dynamic_D_trigger_4(
        .C(C),
        .D(D0),
        .NOT_Q(),
        .Q(Q0),
        .RESET(RESET),
        .SET(SET)
        );

endmodule



   /*******************************************************************************
   ** OUTPUT TIME OF CELL                                                        **
   *******************************************************************************/

module output_time_of_d(
   input wire ind1,
   input wire Z1,
   input wire ind2,
   input wire Z2,
   input wire ind3,
   input wire Z3,
   input wire ind4,
   input wire Z4,
   input wire ind5,
   input wire Z5,
   input wire get,
   input wire pop,

   output wire d_output_time
);

   wire ind1_and_Z1;
   wire ind2_and_Z2;
   wire ind3_and_Z3;
   wire ind4_and_Z4;
   wire ind5_and_Z5;
   wire get_output;
   wire get_time_and_output;
   wire Z5_pop_time;

   AND_GATE ind1_and_Z1_gate(
      ind1, Z1,
      ind1_and_Z1
   );
   AND_GATE ind2_and_Z2_gate(
      ind2, Z2,
      ind2_and_Z2
   );
   AND_GATE ind3_and_Z3_gate(
      ind3, Z3,
      ind3_and_Z3
   );
   AND_GATE ind4_and_Z4_gate(
      ind4, Z4,
      ind4_and_Z4
   );
   AND_GATE ind5_and_Z5_gate(
      ind5, Z5,
      ind5_and_Z5
   );

   OR_GATE_5_INPUTS get_output_gate(
      ind1_and_Z1, ind2_and_Z2, ind3_and_Z3, ind4_and_Z4, ind5_and_Z5,
      get_output
   );

   AND_GATE get_and_output_d_gate(
      get_output, get,
      get_and_output_d
   );

   AND_GATE pop_and_Z5_gate(
      Z5, pop,
      pop_and_Z5
   );

   OR_GATE d_output_time_gate(
      get_and_output_d, pop_and_Z5,
      d_output_time
   );   

endmodule



   /*******************************************************************************
   ** OUTPUT TIME AND OUTPUT OF CELL                                             **
   *******************************************************************************/

module output_d(
   input wire output_time_of_d,
   input wire[3:0] d,

   output wire[3:0] output_d
);

   AND_GATE and_gate_1(
      output_time_of_d, d[3],
      output_d[3]
   );

   AND_GATE and_gate_2(
      output_time_of_d, d[2],
      output_d[2]
   );

   AND_GATE and_gate_3(
      output_time_of_d, d[1],
      output_d[1]
   );

   AND_GATE and_gate_4(
      output_time_of_d, d[0],
      output_d[0]
   );

endmodule

   /*******************************************************************************
   ** STACK                                                                      **
   *******************************************************************************/

module stack(
   inout wire[3:0] IO_DATA, 
   
   input wire RESET, 
   input wire CLK, 
   input wire[1:0] COMMAND,
   input wire[2:0] INDEX
   ); 

   wire[3:0] DATA_in;
   wire[3:0] DATA_out;



   //------------------------------------PARSING------------------------------------

   // command parsing

   wire decode_get;
   wire decode_pop;
   wire decode_push;
   wire decode_nop;

   wire get;
   wire pop;
   wire push;
   wire nop;
   
   wire NOT_CLK;
   NOT_GATE not_clk_gate(
      CLK, 
      NOT_CLK
   );

   decoder_4 decoder_4_(
      .S1(COMMAND[1]), .S0(COMMAND[0]),
      .Z3(decode_get), .Z2(decode_pop), .Z1(decode_push), .Z0(decode_nop)
   );

   D_register_4 d_register_4_ (
      .SET(1'b0), .D3(decode_get), .D2(decode_pop), .D1(decode_push), .D0(decode_nop), .C(NOT_CLK), .RESET(RESET),
      .Q3(get), .Q2(pop), .Q1(push), .Q0(nop)
   );

   // CLK parsing

   wire push_time;
   wire push_pop_time;
   wire get_pop_time;

   wire push_or_pop;
   wire get_or_pop;

   AND_GATE and_push_time(
      CLK, push,
      push_time
   );


   OR_GATE pop_or_push_gate(
      push, pop,
      push_or_pop
   );
   AND_GATE and_push_pop_time(
      CLK, push_or_pop,
      push_pop_time
   );


   OR_GATE get_or_pop_gate(
      get, pop,
      get_or_pop
   );

   AND_GATE and_get_pop_time(
      CLK, get_or_pop,
      get_pop_time
   );

   

   // counter parsing

   wire Q2;
   wire Q1;
   wire Q0;

   counter_mod5 counter(
      .C(push_pop_time), .dec_inc(push), .RESET(RESET),
      .Q2(Q2), .Q1(Q1), .Q0(Q0)
   );

   wire Z4;
   wire Z3;
   wire Z2;
   wire Z1;
   wire Z0;

   decoder_8 decoder_8_1(
      .S2(Q2), .S1(Q1), .S0(Q0),
      .Z7(), .Z6(), .Z5(), .Z4(Z4), .Z3(Z3), .Z2(Z2), .Z1(Z1), .Z0(Z0)
   );

   // index parsing

   wire ind7;
   wire ind6;
   wire ind5;
   wire ind4;
   wire ind3;
   wire ind2;
   wire ind1;
   wire ind0;

   decoder_8 decoder_8_2(
      .S2(INDEX[2]), .S1(INDEX[1]), .S0(INDEX[0]),
      .Z7(ind7), .Z6(ind6), .Z5(ind5), .Z4(ind4), .Z3(ind3), .Z2(ind2), .Z1(ind1), .Z0(ind0)
   );



   //------------------------------------MEMORY------------------------------------

   wire push_time_Z4;
   wire push_time_Z3;
   wire push_time_Z2;
   wire push_time_Z1;
   wire push_time_Z0;

   AND_GATE push_time_and_Z4(
      push_time, Z4,
      push_time_Z4
   );
   AND_GATE push_time_and_Z3(
      push_time, Z3,
      push_time_Z3
   );
   AND_GATE push_time_and_Z2(
      push_time, Z2,
      push_time_Z2
   );
   AND_GATE push_time_and_Z1(
      push_time, Z1,
      push_time_Z1
   );
   AND_GATE push_time_and_Z0(
      push_time, Z0,
      push_time_Z0
   );

   wire[3:0] d4;
   wire[3:0] d3;
   wire[3:0] d2;
   wire[3:0] d1;
   wire[3:0] d0;

   dynamic_D_register_4 dynamic_D_register_4_d4(
      .SET(1'b0), .D3(DATA_in[3]), .D2(DATA_in[2]), .D1(DATA_in[1]), .D0(DATA_in[0]), .C(push_time_Z3), .RESET(RESET),
      .Q3(d4[3]), .Q2(d4[2]), .Q1(d4[1]), .Q0(d4[0])
   );

   dynamic_D_register_4 dynamic_D_register_4_d3(
      .SET(1'b0), .D3(DATA_in[3]), .D2(DATA_in[2]), .D1(DATA_in[1]), .D0(DATA_in[0]), .C(push_time_Z2), .RESET(RESET),
      .Q3(d3[3]), .Q2(d3[2]), .Q1(d3[1]), .Q0(d3[0])
   );

   dynamic_D_register_4 dynamic_D_register_4_d2(
      .SET(1'b0), .D3(DATA_in[3]), .D2(DATA_in[2]), .D1(DATA_in[1]), .D0(DATA_in[0]), .C(push_time_Z1), .RESET(RESET),
      .Q3(d2[3]), .Q2(d2[2]), .Q1(d2[1]), .Q0(d2[0])
   );

   dynamic_D_register_4 dynamic_D_register_4_d1(
      .SET(1'b0), .D3(DATA_in[3]), .D2(DATA_in[2]), .D1(DATA_in[1]), .D0(DATA_in[0]), .C(push_time_Z0), .RESET(RESET),
      .Q3(d1[3]), .Q2(d1[2]), .Q1(d1[1]), .Q0(d1[0])
   );
   dynamic_D_register_4 dynamic_D_register_4_d0(
      .SET(1'b0), .D3(DATA_in[3]), .D2(DATA_in[2]), .D1(DATA_in[1]), .D0(DATA_in[0]), .C(push_time_Z4), .RESET(RESET),
      .Q3(d0[3]), .Q2(d0[2]), .Q1(d0[1]), .Q0(d0[0])
   );



   //---------------------------------OUTPUT-PARSER---------------------------------

   wire ind_2or7;
   wire ind_1or6;
   wire ind_0or5;

   OR_GATE ind2_or_ind7(
      ind2, ind7,
      ind_2or7
   );
   OR_GATE ind1_or_ind6(
      ind1, ind6,
      ind_1or6
   );
   OR_GATE ind0_or_ind5(
      ind0, ind5,
      ind_0or5
   );

   // output of cell d4

   wire d4_output_time;

   output_time_of_d output_time_of_d4(
   .ind1(ind4), .Z1(Z3),
   .ind2(ind3), .Z2(Z2),
   .ind3(ind_2or7), .Z3(Z1),
   .ind4(ind_1or6), .Z4(Z0),
   .ind5(ind_0or5), .Z5(Z4),
   .get(get), .pop(pop),

   .d_output_time(d4_output_time)
   );

   // output of cell d3

   wire d3_output_time;

   output_time_of_d output_time_of_d3(
   .ind1(ind4), .Z1(Z2),
   .ind2(ind3), .Z2(Z1),
   .ind3(ind_2or7), .Z3(Z0),
   .ind4(ind_1or6), .Z4(Z4),
   .ind5(ind_0or5), .Z5(Z3),
   .get(get), .pop(pop),

   .d_output_time(d3_output_time)
   );
   
   // output of cell d2

   wire d2_output_time;

   output_time_of_d output_time_of_d2(
   .ind1(ind4), .Z1(Z1),
   .ind2(ind3), .Z2(Z0),
   .ind3(ind_2or7), .Z3(Z4),
   .ind4(ind_1or6), .Z4(Z3),
   .ind5(ind_0or5), .Z5(Z2),
   .get(get), .pop(pop),

   .d_output_time(d2_output_time)
   );
   
   // output of cell d1

   wire d1_output_time;

   output_time_of_d output_time_of_d1(
   .ind1(ind4), .Z1(Z0),
   .ind2(ind3), .Z2(Z4),
   .ind3(ind_2or7), .Z3(Z3),
   .ind4(ind_1or6), .Z4(Z2),
   .ind5(ind_0or5), .Z5(Z1),
   .get(get), .pop(pop),

   .d_output_time(d1_output_time)
   );
   
   // output of cell d0

   wire d0_output_time;

   output_time_of_d output_time_of_d0(
   .ind1(ind4), .Z1(Z4),
   .ind2(ind3), .Z2(Z3),
   .ind3(ind_2or7), .Z3(Z2),
   .ind4(ind_1or6), .Z4(Z1),
   .ind5(ind_0or5), .Z5(Z0),
   .get(get), .pop(pop),

   .d_output_time(d0_output_time)
   );
   
   

   //---------------------------------OUTPUT-MEMORY---------------------------------

   wire[3:0] output_d4;
   wire[3:0] output_d3;
   wire[3:0] output_d2;
   wire[3:0] output_d1;
   wire[3:0] output_d0;

   output_d output_d4_(
      .output_time_of_d(d4_output_time), .d(d4),
      .output_d(output_d4)
   );

   output_d output_d3_(
      .output_time_of_d(d3_output_time), .d(d3),
      .output_d(output_d3)
   );

   output_d output_d2_(
      .output_time_of_d(d2_output_time), .d(d2),
      .output_d(output_d2)
   );

   output_d output_d1_(
      .output_time_of_d(d1_output_time), .d(d1),
      .output_d(output_d1)
   );

   output_d output_d0_(
      .output_time_of_d(d0_output_time), .d(d0),
      .output_d(output_d0)
   );


   wire register_d3;
   wire register_d2;
   wire register_d1;
   wire register_d0;

   OR_GATE_5_INPUTS register_d3_gate(
      output_d4[3], output_d3[3], output_d2[3], output_d1[3], output_d0[3], 
      register_d3
   );

   OR_GATE_5_INPUTS register_d2_gate(
      output_d4[2], output_d3[2], output_d2[2], output_d1[2], output_d0[2], 
      register_d2
   );

   OR_GATE_5_INPUTS register_d1_gate(
      output_d4[1], output_d3[1], output_d2[1], output_d1[1], output_d0[1], 
      register_d1
   );

   OR_GATE_5_INPUTS register_d0_gate(
      output_d4[0], output_d3[0], output_d2[0], output_d1[0], output_d0[0], 
      register_d0
   );

   dynamic_D_register_4 dynamic_d_register_4_output(
      .SET(1'b0), .D3(register_d3), .D2(register_d2), .D1(register_d1), .D0(register_d0), .C(get_pop_time), .RESET(RESET),
      .Q3(DATA_out[3]), .Q2(DATA_out[2]), .Q1(DATA_out[1]), .Q0(DATA_out[0])
   );

   //-------------------------------------IN-OUT-------------------------------------

   assign DATA_in = IO_DATA;

   nmos(IO_DATA[3], DATA_out[3], get_pop_time);
   nmos(IO_DATA[2], DATA_out[2], get_pop_time);
   nmos(IO_DATA[1], DATA_out[1], get_pop_time);
   nmos(IO_DATA[0], DATA_out[0], get_pop_time);

endmodule