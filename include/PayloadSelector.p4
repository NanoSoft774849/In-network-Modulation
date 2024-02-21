#ifndef __PAYLOAD_SELECTOR_P4
#define __PAYLOAD_SELECTOR_P4

#include"snaps.p4"

control payloadSelector(inout ns_headers hdr)
{
    NET_MOD_PB_CREATE_ACTION(0)
    

    table payload_selector_tbl 
    {
        key = { hdr.circ.payload_hdr_index : ternary;
                hdr.circ.payload_b_index : ternary; }

        actions = 
        {
            NET_MOD_PB_ACTIONS_LIST(0)
            NoAction;

        }
        size = 256;
        const entries = 
        {
            NET_MOD_PB_ENTRY_LIST(0)
        }
        default_action = NoAction();
    }
    apply{
        payload_selector_tbl.apply();
    }

}


#endif
