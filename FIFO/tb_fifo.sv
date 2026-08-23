module tb_fifo;

parameter DEPTH = 16;
parameter DATA_WIDTH = 8;
parameter PTR_SIZE = 4;

reg clk;
reg reset;
reg write_en;
reg read_en;
reg [DATA_WIDTH-1:0] data_in;

wire [DATA_WIDTH-1:0] data_out;
wire empty;
wire full;

fifo f1 (clk,reset,write_en,read_en,data_in,data_out,empty,full);

always #5 clk = ~clk;

integer i;

initial begin

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    #10;
    reset = 0;

    $display("\nWriting Data");

    for(i=1;i<=5;i=i+1)
    begin
        @(posedge clk);
        write_en = 1;
        read_en  = 0;
        data_in  = i*10;
    end

    @(posedge clk);
    write_en = 0;

    $display("\nReading Data");

    for(i=1;i<=5;i=i+1)
    begin
        @(posedge clk);
        write_en = 0;
        read_en  = 1;
    end

    @(posedge clk);
    read_en = 0;

    $display("\nFill FIFO");

    for(i=0;i<DEPTH;i=i+1)
    begin
        @(posedge clk);
        write_en = 1;
        data_in = i;
    end

    @(posedge clk);
    write_en = 0;

    $display("\nEmpty FIFO");

    for(i=0;i<DEPTH;i=i+1)
    begin
        @(posedge clk);
        read_en = 1;
    end

    @(posedge clk);
    read_en = 0;

    #20;
    $finish;

end

initial
begin
    $monitor("Time=%0t Reset=%b Write=%b Read=%b Din=%0d Dout=%0d Empty=%b Full=%b",$time, reset, write_en, read_en, data_in,data_out, empty, full);
end

initial
begin
  $dumpfile("dump.vcd");
  $dumpvars(0,tb_fifo);
end

endmodule
