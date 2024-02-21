#ifndef __snaps__p4

#define __snaps__p4

#define CreateRegisterMap(m) \ 
Register<iq_t, _ >( (1 << m) ) SMAP##m;\
RegisterAction<iq_t, _, iq_t>(SMAP##m) act##m ={\
 void apply( inout iq_t value, out iq_t rv)\
 {\
    rv = value;\
 }\
 \
 };\
//
// hdr.circ.current_payload_b =  hdr.circ.current_payload_b >> m;
#define NET_MOD_IQ(m, b, i) \
action net##m##i##b() \
{\
        hdr.IQ##b.setValid();\
        hdr.IQ##b.s##i = act##m.execute((bit<32>)hdr.circ.current_payload_b[m-1:0]);\
        hdr.circ.current_payload_b =  hdr.circ.current_payload_b >> m;\
}\
//


#define NET_MOD_IQ_BPSK(b, s)      NET_MOD_IQ(1, b, s)
#define NET_MOD_IQ_QPSK(b, s)      NET_MOD_IQ(2, b, s)
#define NET_MOD_IQ_QAM16(b,s)      NET_MOD_IQ(4, b, s)
#define NET_MOD_IQ_QAM64(b,s)      NET_MOD_IQ(6, b, s)
#define NET_MOD_IQ_QAM256(b,s)     NET_MOD_IQ(8, b, s)

#define NET_MOD_IQ_BANK_DEFINE_ACTIONS(b, x) \
        NET_MOD_IQ_##x(b, 0) \
        NET_MOD_IQ_##x(b, 1) \
        NET_MOD_IQ_##x(b, 2) \
        NET_MOD_IQ_##x(b, 3) \
        NET_MOD_IQ_##x(b, 4) \
        NET_MOD_IQ_##x(b, 5) \
        NET_MOD_IQ_##x(b, 6) \
        NET_MOD_IQ_##x(b, 7) \
//


// A single Action item
#define NET_MOD_IQ_ACTION_BPSK(b, s)       net1##s##b
#define NET_MOD_IQ_ACTION_QPSK(b, s)       net2##s##b
#define NET_MOD_IQ_ACTION_QAM16(b, s)      net4##s##b
#define NET_MOD_IQ_ACTION_QAM64(b, s)      net6##s##b
#define NET_MOD_IQ_ACTION_QAM256(b, s)     net8##s##b
// A single Entry Item
#define NET_MOD_IQ_ENTRY_BPSK(b,s)     (b,s):net1##s##b()
#define NET_MOD_IQ_ENTRY_QPSK(b,s)     (b,s):net2##s##b()
#define NET_MOD_IQ_ENTRY_QAM16(b,s)    (b,s):net4##s##b()
#define NET_MOD_IQ_ENTRY_QAM64(b,s)    (b,s):net6##s##b()
#define NET_MOD_IQ_ENTRY_QAM256(b,s)   (b,s):net8##s##b()


// Generic ACTIONS LIST
#define NET_MOD_IQ_ACTIONS_LIST(b, x)\
        NET_MOD_IQ_ACTION_##x(b, 0);\
        NET_MOD_IQ_ACTION_##x(b, 1);\
        NET_MOD_IQ_ACTION_##x(b, 2);\
        NET_MOD_IQ_ACTION_##x(b, 3);\
        NET_MOD_IQ_ACTION_##x(b, 4);\
        NET_MOD_IQ_ACTION_##x(b, 5);\
        NET_MOD_IQ_ACTION_##x(b, 6);\
        NET_MOD_IQ_ACTION_##x(b, 7);\


// Generic ENTRIES list
#define NET_MOD_IQ_ENTRY_LIST(b, x)\
        NET_MOD_IQ_ENTRY_##x(b, 0); \
        NET_MOD_IQ_ENTRY_##x(b, 1); \
        NET_MOD_IQ_ENTRY_##x(b, 2); \
        NET_MOD_IQ_ENTRY_##x(b, 3); \
        NET_MOD_IQ_ENTRY_##x(b, 4); \
        NET_MOD_IQ_ENTRY_##x(b, 5); \
        NET_MOD_IQ_ENTRY_##x(b, 6); \
        NET_MOD_IQ_ENTRY_##x(b, 7); \
//
//
// payload b slect pbs
// b : is the payload hdr select 
// i : is the b_i selector 
#define NET_MOD_PB_SELECT(x, i) \
action pbs##i##x() \
{\
    hdr.circ.current_payload_b = hdr.payload##x.b##i;\
}\
//
#define NET_MOD_PB_CREATE_ACTION(b)\
        NET_MOD_PB_SELECT(b, 0) \
        NET_MOD_PB_SELECT(b, 1) \
        NET_MOD_PB_SELECT(b, 2) \
        NET_MOD_PB_SELECT(b, 3) \
        NET_MOD_PB_SELECT(b, 4) \
        NET_MOD_PB_SELECT(b, 5) \
        NET_MOD_PB_SELECT(b, 6) \
        NET_MOD_PB_SELECT(b, 7) \
//
#define NET_MOD_PB_ACTION(b,i) pbs##i##b
#define NET_MOD_PB_ENTRY(b,i)  (b, i):pbs##i##b
//
#define NET_MOD_PB_ACTIONS_LIST(b)\
        NET_MOD_PB_ACTION(b, 0);\
        NET_MOD_PB_ACTION(b, 1);\
        NET_MOD_PB_ACTION(b, 2);\
        NET_MOD_PB_ACTION(b, 3);\
        NET_MOD_PB_ACTION(b, 4);\
        NET_MOD_PB_ACTION(b, 5);\
        NET_MOD_PB_ACTION(b, 6);\
        NET_MOD_PB_ACTION(b, 7);\
//

#define NET_MOD_PB_ENTRY_LIST(b)\
        NET_MOD_PB_ENTRY(b, 0);\
        NET_MOD_PB_ENTRY(b, 1);\
        NET_MOD_PB_ENTRY(b, 2);\
        NET_MOD_PB_ENTRY(b, 3);\
        NET_MOD_PB_ENTRY(b, 4);\
        NET_MOD_PB_ENTRY(b, 5);\
        NET_MOD_PB_ENTRY(b, 6);\
        NET_MOD_PB_ENTRY(b, 7);\
//
// IQ Selector , this will push the value to the hdr.IQx = hdr.tmp_iq;




#endif