#ifndef __Validator__P4
#define __Validator__P4
// helppful for parser
// hdr.IQ##m.s1 = hdr.tmp_iq.s1;\
//     hdr.IQ##m.s2 = hdr.tmp_iq.s2;\
//     hdr.IQ##m.s3 = hdr.tmp_iq.s3;\
//     hdr.IQ##m.s4 = hdr.tmp_iq.s4;\
//     hdr.IQ##m.s5 = hdr.tmp_iq.s5;\
//     hdr.IQ##m.s6 = hdr.tmp_iq.s6;\
//     hdr.IQ##m.s7 = hdr.tmp_iq.s7;\
//
//    hdr.IQ##m.s2 = hdr.tmp_iq.s2;\
//   hdr.IQ##m.s3 = hdr.tmp_iq.s3;\


#define Validate(m) \
action valid##m(){\
    hdr.IQ##m.setValid();\
    hdr.IQ##m.s0 = hdr.tmp_iq.s0;\
    hdr.IQ##m.s1 = hdr.tmp_iq.s1;\
    hdr.IQ##m.s2 = hdr.tmp_iq.s2;\
    hdr.IQ##m.s3 = hdr.tmp_iq.s3;\
}\

control validator(inout ns_headers hdr)
{
    Validate(0)
    Validate(1)
    Validate(2)
    Validate(3)
    Validate(4)
    Validate(5)
    Validate(6)
    Validate(7)

    

    table valid_table 
    {
        key = { hdr.circ.iq_hdr_index : ternary;}
        actions={
            valid0;
            valid1;
            valid2;
            valid3;
            valid4;
            valid5;
            valid6;
            valid7;
            NoAction;
        }
        const entries = 
        {
            (0):valid0();
            (1):valid1();
            (2):valid2();
            (3):valid3();
            (4):valid4();
            (5):valid5();
            (6):valid6();
            (7):valid7();
        }
        default_action = NoAction();
        size = 64;
    }
    apply{
        valid_table.apply();
    }

}

#endif