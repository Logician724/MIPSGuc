module IF_Sel_TB();

reg [31:0] MUX_OPT_0, MUX_OPT_1;
reg MEM_WRITE;
wire [31:0] NEXT_INS_ADR, CUR_INS;

IF_Sel IF_Sel_Module(
    MUX_OPT_0,
    MUX_OPT_1,
    MEM_WRITE,
    NEXT_INS_ADR,
    CUR_INS
);

initial
    $monitor("time=%d, MUX_OPT_0=%d, MUX_OPT_1=%d, MEM_WRITE=%d, NEXT_INS_ADR=%d, CUR_INS=%d",
    $time, MUX_OPT_0,
    MUX_OPT_1,
    MEM_WRITE,
    NEXT_INS_ADR,
    CUR_INS
);

initial
begin
    #50 MEM_WRITE = 0;
    #50 MUX_OPT_0 = 50;
    #50 MUX_OPT_1 = 100;
    #50 MEM_WRITE = 1;
        $finish;
end

endmodule