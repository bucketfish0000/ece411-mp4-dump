module cache_datapath #(
            parameter       s_offset = 5,
            parameter       s_index  = 4,
            parameter       s_tag    = 32 - s_offset - s_index,
            parameter       s_mask   = 2**s_offset,
            parameter       s_line   = 8*s_mask,
            parameter       num_sets = 2**s_index
)(
    input logic clk,
    input logic rst,

    //cpu
    input logic [31:0] address,
    input logic [31:0] wmask,
    input logic [255:0] cpu_data_write,
    output logic [255:0] cpu_data_read,
    
    //mem
    input logic [255:0] mem_data_read,
    output logic [255:0] mem_data_write,
    output logic [31:0] pmem_address,

    //control inputs
        //-stuff
    input logic[1:0] dirty_op, //00,11:idle, 01:mark dirty, 10: mark clean
    input logic[1:0] valid_op, //00,11:idle, 01:mark valid, 10: mark invalid
    input logic plru_update,
        //muxes
    input logic[1:0] dataweb_mux,
    input logic tagweb_mux,
    input logic datain_mux,
    input logic dataout_sel_mux,
    input logic dirty_way_mux,
    input logic pmem_address_mux,
    input logic data_wmask_mux,

    //control outputs
    output logic cache_hit,
    output logic cache_dirty

    //test
);

/*
                           _
                        _ooOoo_
                       o8888888o
                       88" . "88
                       (| -_- |)
                       O\  =  /O
                    ____/`---'\____
                  .'  \\|     |//  `.
                 /  \\|||  :  |||//  \
                /  _||||| -:- |||||_  \
                |   | \\\  -  /'| |   |
                | \_|  `\`---'//  |_/ |
                \  .-\__ `-. -'__/-.  /
              ___`. .'  /--.--\  `. .'___
           ."" '<  `.___\_<|>_/___.' _> \"".
          | | :  `- \`. ;`. _/; .'/ /  .' ; |
          \  \ `-.   \_\_`. _.'_/_/  -' _.' /
===========`-.`___`-.__\ \___  /__.-'_.'_.-'================
*/

//////var declare//////
    //gen
    logic   [255:0]     data_i;
    logic   [22:0]      tag_i;
    logic   [255:0]     data_out;
    logic   [255:0]     data_o      [4];
    logic   [22:0]      tag_o       [4];
    logic   [22:0]      tag;
    logic   [3:0]       set;
    logic   [4:0]       offset;
    logic   [31:0]      pmem_addr;

    //web masks
    logic   [3:0]       tag_web;
    logic   [3:0]       data_web;
    logic   [31:0]      data_wmask;
    //lookup output
    logic hit;
    logic [3:0] hitmap;
    logic [1:0] hitnum; //translated hitnumber, only valid when hit == 1
    
    //dataout select
    logic [1:0] dout_sel;
    //plru output
    logic [3:0] plrumap;
    logic [1:0] plrunum;

    //dirty
    logic dirty_out;
    logic [1:0]dirty_way;
    
    //valid
    logic [3:0] valid_out;
    
//////assignment//////
    //hardwire both of these two, control if to load separately with control machine to specify their r/w op.
    assign cpu_data_read = data_out;
    assign mem_data_write = data_out;

    assign tag = address[31:9];
    assign set = address[8:5];
    assign offset = address[4:0];

    assign tag_i = tag;

    assign cache_hit = hit;
    assign cache_dirty = dirty_out;
    assign pmem_address = pmem_addr;
    //assign plru_num = plrunum;
//////modules//////
    genvar i;
    generate 
        for (i = 0; i < 4; i++) 
        begin : arrays
            mp3_data_array data_array (
                .clk0       (~clk),
                .csb0       (1'b0),
                .web0       (data_web[i]),
                .wmask0     (data_wmask),
                .addr0      (set),
                .din0       (data_i),
                .dout0      (data_o[i])
            );
            mp3_tag_array tag_array (
                .clk0(clk),
                .csb0(1'b0),
                .web0(tag_web[i]),
                .addr0(set),
                .din0(tag_i),
                .dout0(tag_o[i])
            );
        end 

    endgenerate

    //TODO: specify dirty, valid array way select logics
    dirty #(.s_index(4),.w_index(2)) 
        dirty_arr
            (.clk(clk),.rst(rst),.operation(dirty_op),.set_sel(set),.way_sel(dirty_way),.dirty_out(dirty_out));

    valid #(.s_index(4),.w_index(2))
        valid_arr
            (.clk(clk),.rst(rst),.operation(valid_op),.set_sel(set),.way_sel(plrunum),.valid_out(valid_out));

    PLRU_4_way #(.s_index(4))
        plru
            (.clk(clk), .rst(rst),.update(plru_update),.hit_map(hitmap),.set_sel(set),.plru_number(plrunum),.plru_map(plrumap));


//////comb logics//////
always_comb begin
    // for (int i = 0; i < 4; i++) begin
    //     hitmap[i] = (valid_out[i] && (tag_o[i]==tag));
    // end
    hitmap[0] = (valid_out[0] && (tag_o[0]==tag));
    hitmap[1] = (valid_out[1] && (tag_o[1]==tag));
    hitmap[2] = (valid_out[2] && (tag_o[2]==tag));
    hitmap[3] = (valid_out[3] && (tag_o[3]==tag));
    hit=|hitmap;
    unique case(hitmap)
        4'b0001: hitnum = 2'b00;
        4'b0010: hitnum = 2'b01;
        4'b0100: hitnum = 2'b10;
        4'b1000: hitnum = 2'b11;
        default: hitnum = 2'b00;
    endcase

    //muxes
    unique case(dataweb_mux)
        2'b00: data_web = 4'b1111; //idle, read hit, writeback: all read
        2'b01: data_web = ~hitmap; //write hit, enable hit location write
        2'b10: data_web = ~plrumap; //allocate, enable plru location write (after wb complete)
        default: data_web = 4'b1111;
    endcase
    unique case(data_wmask_mux)
        1'b0: data_wmask = 32'hffffffff;
        1'b1: data_wmask = wmask;
        default: data_wmask = 32'hffffffff;
    endcase
    unique case(dirty_way_mux)
        1'b0: dirty_way = hitnum;
        1'b1: dirty_way = plrunum;
        default: dirty_way = hitnum;
    endcase
    unique case(tagweb_mux)
        1'b0: tag_web = 4'b1111; //idle, read hit, .., all read
        1'b1: tag_web = ~plrumap; 
        default: tag_web = 4'b1111;
    endcase
    unique case(datain_mux)
        1'b0: data_i = cpu_data_write; //write hit, din from cpu
        1'b1: data_i = mem_data_read; //allocate, din from mem
        default:;
    endcase
    unique case(dataout_sel_mux)
        1'b0: dout_sel = hitnum; //read hit, select dout to be hitnum
        1'b1: dout_sel = plrunum; //miss writeback, select dout to plru location
        default:;
    endcase
    unique case(pmem_address_mux)
        1'b0: pmem_addr = {address[31:5],5'b0};
        1'b1: pmem_addr = {tag_o[plrunum],set,5'b00000};
        default:;
    endcase
    //output sel
    data_out = data_o[dout_sel];
end

endmodule : cache_datapath
