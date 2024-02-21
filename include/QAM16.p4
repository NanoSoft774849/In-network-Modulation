#ifndef __QAM16__P4
#define __QAM16__P4

#include"snaps.p4"


control QAM16Mapper(inout ns_headers hdr, inout meta_data meta)
{
    CreateRegisterMap(4)
#define GEN_ACTION(i)\
        action net4##i(){\
        hdr.tmp_iq.s##i = act4.execute((bit<32>)hdr.circ.current_payload_b[3:0]);\
        hdr.circ.current_payload_b =  hdr.circ.current_payload_b >> 4;}\
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

#define ACTION_LIST_ITEM(i) net4##i
#define ACTION_ENTRY_ITEM(i) (i):net4##i
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
    



    table QAM16_table 
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
        QAM16_table.apply();
    }

}

#endif



