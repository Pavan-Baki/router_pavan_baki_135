/*module router_top(clk,rst,read_0,read_1,read_2,valid_0,valid_1,valid_2,busy,err,pkt_valid,data_in,data_out_0,data_out_1,data_out_2);
input clk,rst,read_0,read_1,read_2,pkt_valid;
input [7:0]data_in;
output valid_0,valid_1,valid_2,busy,err;
output [7:0]data_out_0;
output  [7:0] data_out_1;
output  [7:0]data_out_2;
wire soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2,empty_0,empty_1,empty_2,fifo_full,detec_add,ld_state,laf_state,fill_state,lfd_state,rst_int_reg,low_pkt_valid,write_enb_reg,parity_done;
wire [2:0]write_enb;
wire[7:0]d_in;


router_fifo FIFO_1(.clk(clk),.rst(rst),.sft_rst(soft_reset_0),.data_in(d_in),.data_out(data_out_0),.empty(empty_0),.full(full_0),.re(read_0),.we(write_enb[0]),.lfd_state(lfd_state));
router_fifo FIFO_2(.clk(clk),.rst(rst),.sft_rst(soft_reset_1),.data_in(d_in),.data_out(data_out_1),.empty(empty_1),.full(full_1),.re(read_1),.we(write_enb[1]),.lfd_state(lfd_state));
router_fifo FIFO_3(.clk(clk),.rst(rst),.sft_rst(soft_reset_2),.data_in(d_in),.data_out(data_out_2),.empty(empty_2),.full(full_2),.re(read_2),.we(write_enb[2]),.lfd_state(lfd_state));

router_sync Synchronizer(.detec_add(detec_add),.clk(clk),.rst(rst),.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2),.full_0(full_0),.full_1(full_1),.full_2(full_2),.read_0(read_0),.read_1(read_1),.read_2(read_2),.valid_0(valid_0),.valid_1(valid_1),.valid_2(valid_2),.fifo_full(fifo_full),.soft_rst_0(soft_reset_0),.soft_rst_1(soft_reset_1),.soft_rst_2(soft_reset_2),.write_enb(write_enb),.data_in(data_in[1:0]),.write_en_reg(write_enb_reg));

router_fsm FSM(.clk(clk),.rst(rst),.data_in(data_in[1:0]),.parity_done(parity_done),.pkt_valid(pkt_valid),.soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2),.low_pkt_valid(low_pkt_valid),.fifo_full(fifo_full),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),.detect_add(detec_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg),.lfd_state(lfd_state),.busy(busy));

router_reg Register(.data_in(data_in),.clk(clk),.rst(rst),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),.detec_add(detec_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.pkt_valid(pkt_valid),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.err(err),.dout(d_in));


endmodule*/
module router_1x3(clock , resetn , read_enb_0 , read_enb_1 , read_enb_2 , data_in , pkt_valid , data_out_0 , data_out_1 , data_out_2 , valid_out_0 , valid_out_1 , valid_out_2 , error , busy);

input clock , resetn , read_enb_0 , read_enb_1 , read_enb_2 , pkt_valid;
input [7:0] data_in;
output valid_out_0 , valid_out_1 , valid_out_2 , error , busy;
output [7:0] data_out_0 , data_out_1 , data_out_2;
wire parity_done, soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full ,low_pkt_valid , empty_0  , empty_1 , empty_2, detect_add , ld_state , laf_state, full_state , write_enb_reg , rst_int_reg , lfd_state;
wire [2:0] write_enb , full;
wire [7:0] dout;

router_fsm  RFS(clock , resetn , pkt_valid , busy , parity_done , data_in[1:0] , soft_reset_0 , soft_reset_1 , soft_reset_2 , fifo_full , low_pkt_valid , empty_0 , empty_1 , empty_2 , detect_add , ld_state , laf_state , full_state , write_enb_reg , rst_int_reg , lfd_state);

router_sync RSY(detect_add , data_in[1:0] , write_enb_reg , clock , resetn , valid_out_0 , valid_out_1 , valid_out_2 , read_enb_0 , read_enb_1 , read_enb_2 , write_enb , fifo_full , empty_0 , empty_1 , empty_2 , soft_reset_0 , soft_reset_1 , soft_reset_2 , full[0] , full[1] , full[2]);

router_reg RRG(clock , resetn , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , error , dout);

router_fifo FIF0(dout , resetn , clock , write_enb[0] , read_enb_0 , soft_reset_0 , lfd_state , empty_0 , full[0] , data_out_0);
router_fifo FIF1(dout , resetn , clock , write_enb[1] , read_enb_1 , soft_reset_1 , lfd_state , empty_1 , full[1] , data_out_1);
router_fifo FIF2(dout , resetn , clock , write_enb[2] , read_enb_2 , soft_reset_2 , lfd_state , empty_2 , full[2] , data_out_2);

endmodule


