module spi_trx (
    input clk,

    input sck,
    output miso,
    input mosi,
    input ss,

    output rst_o,

    output [7:0] data_o,
    output ack_pop_o,

    input [7:0] data_i);

// detect sck posedge
reg [1:0] sck_hist_ff;
always @(posedge clk) begin
    sck_hist_ff <= {sck_hist_ff[0], sck};
end

// detect ss negedge
reg [1:0] ss_hist_ff;
always @(posedge clk) begin
    ss_hist_ff <= {ss_hist_ff[0], ss};
end
wire ss_negedge = ss_hist_ff[1:0] == 2'b10;
wire ss_enabled = ~ss_hist_ff[0];
wire sck_posedge = ss_enabled && sck_hist_ff[1:0] == 2'b01;
wire sck_negedge = ss_enabled && sck_hist_ff[1:0] == 2'b10;

assign rst_o = ss_negedge;

// mosi -> shiftreg_i
reg mosi_hist_ff;
always @(posedge clk) begin
    mosi_hist_ff <= mosi;
end

reg [7:0] shiftreg_i;
always @(posedge clk) begin
    if (sck_posedge)
        shiftreg_i <= {shiftreg_i[6:0], mosi_hist_ff};
end

// count 8 posedge -> posedge8_ff
reg posedge8_ff;
reg [2:0] posedge_counter;
always @(posedge clk) begin
    posedge8_ff <= 0;

    if(ss_negedge)
        posedge_counter <= 0;
    else if(sck_posedge) begin
        if(posedge_counter == 7) begin
            posedge8_ff <= 1;
        end

        posedge_counter <= posedge_counter + 1;
    end
end

// rx data -> {data_o, ack_pop_o}
reg ack_o_ff;
reg [7:0] data_o_ff;
always @(posedge clk) begin
    ack_o_ff <= 0;
    if(posedge8_ff) begin
        ack_o_ff <= 1;
        data_o_ff <= shiftreg_i;
    end
end
assign ack_pop_o = ack_o_ff;
assign data_o = data_o_ff;

// data_i -> tx data
reg [7:0] shiftreg_o;
always @(posedge clk) begin
    if (posedge8_ff || ss_negedge) begin
        $display("spi data tx: %x", data_i);
        shiftreg_o <= data_i;
    end else if(sck_negedge) begin
        shiftreg_o <= {shiftreg_o[6:0], 1'b0};
    end
end
assign miso = shiftreg_o[7];

endmodule
