#ifndef __QAM64__P4
#define __QAM64__P4

#include"snaps.p4"
//
//
control QAM64Mapper(inout ns_headers hdr, inout meta_data meta)
{
    CreateRegisterMap(6)
    NET_MOD_PB_QAM64_CREATE_ACTION(0)
    NET_MOD_PB_QAM64_CREATE_ACTION(1)
    NET_MOD_PB_QAM64_CREATE_ACTION(2)
    NET_MOD_PB_QAM64_CREATE_ACTION(3)
//
#define GEN_ACTION(i)\
        action net##i(){\
        hdr.tmp_iq.s##i =  act6.execute((bit<32>)meta.current_payload_b);\
}\
//
#define CREATE_ACTION_BANK()\
        GEN_ACTION(0)       \
        GEN_ACTION(1)       \
        GEN_ACTION(2)       \
        GEN_ACTION(3)       \
        GEN_ACTION(4)       \
        GEN_ACTION(5)       \
        GEN_ACTION(6)       \
        GEN_ACTION(7)       \
// //

#define ACTION_LIST_ITEM(i) net##i
#define ACTION_ENTRY_ITEM(i) (i):net##i
//
#define ACTION_LIST_BANK()\
        ACTION_LIST_ITEM(0);\
        ACTION_LIST_ITEM(1);\
        ACTION_LIST_ITEM(2);\
        ACTION_LIST_ITEM(3);\
        ACTION_LIST_ITEM(4);\
        ACTION_LIST_ITEM(5);\
        ACTION_LIST_ITEM(6);\
        ACTION_LIST_ITEM(7);\
//
#define ACTION_ENTRY_BANK()\
        ACTION_ENTRY_ITEM(0);\
        ACTION_ENTRY_ITEM(1);\
        ACTION_ENTRY_ITEM(2);\
        ACTION_ENTRY_ITEM(3);\
        ACTION_ENTRY_ITEM(4);\
        ACTION_ENTRY_ITEM(5);\
        ACTION_ENTRY_ITEM(6);\
        ACTION_ENTRY_ITEM(7);\
//

    CREATE_ACTION_BANK()
    
    table QAM64_payload_sel_tbl
    {
        key = {
            hdr.circ.payload_hdr_index : ternary;
            hdr.circ.payload_b_index: ternary;
        }
        actions=
        {
            NET_MOD_PB_QAM64_ACTIONS_LIST(0)
            NET_MOD_PB_QAM64_ACTIONS_LIST(1)
            NET_MOD_PB_QAM64_ACTIONS_LIST(2)
            NET_MOD_PB_QAM64_ACTIONS_LIST(3)
            NoAction;
        }
        size = 128;
        const entries = 
        {
            NET_MOD_PB_QAM64_ENTRY_LIST(0)
            NET_MOD_PB_QAM64_ENTRY_LIST(1)
            NET_MOD_PB_QAM64_ENTRY_LIST(2)
            NET_MOD_PB_QAM64_ENTRY_LIST(3)
        }
        default_action = NoAction();
    }



    table QAM64_table 
    {
        key = {
            hdr.circ.iq_s_index : ternary;
        }
        actions = 
        {
            ACTION_LIST_BANK()
        }
        size = MOD_TABLE_SIZE;
        const entries = 
        {
            ACTION_ENTRY_BANK()
        }
    }

    apply{
        if(hdr.circ.index == 0)
        {
            hdr.circ.ttc = 192;
        }
        if( hdr.circ.payload_b_shift_cntr >= 6 || hdr.circ.payload_b_shift_cntr == 0)
        {
           
           hdr.circ.payload_b_shift_cntr = 0;
           QAM64_payload_sel_tbl.apply();
           hdr.circ.payload_b_index = hdr.circ.payload_b_index |+| 1;
        }
        if (  hdr.circ.payload_b_index  == PAYLOAD_HDR_B_COUNT)
        {
            hdr.circ.payload_hdr_index = hdr.circ.payload_hdr_index |+| 1;
            hdr.circ.payload_b_index = 0;
        }
        QAM64_table.apply();
        
    }

}

#endif
//