#ifndef __QAM64__P4
#define __QAM64__P4

#include"snaps.p4"
// Let us assume we have 16-bit per payload b
// b0 -> you will take 6 bits , 6 , 4 ( 6, 6, 4) - ( 2, 6, 6, 2), ( 4, 6, 6) - ( 2, 6, 6, 2 ), ( 4, 6, 6)

// You need to change this..
control QAM64Mapper(inout ns_headers hdr, inout meta_data meta)
{
    CreateRegisterMap(6)
    // for ( 6, 6, 4 )
    // action act664()
    // {
            // take six bits in the first stage 
    // }
#define GEN_ACTION(i)\
        action net6##i(){\
        hdr.tmp_iq.s##i = act6.execute((bit<32>)hdr.circ.current_payload_b[5:0]);\
        hdr.circ.current_payload_b =  hdr.circ.current_payload_b >> 6;}\
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

#define ACTION_LIST_ITEM(i) net6##i
#define ACTION_ENTRY_ITEM(i) (i):net6##i
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
    



    table QAM64_table 
    {
        key = {
            hdr.circ.iq_s_index : exact;
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
        QAM64_table.apply();
    }

}

#endif



