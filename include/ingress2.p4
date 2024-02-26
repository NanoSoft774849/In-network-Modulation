#ifndef __ingress__p4
#define __ingress__p4

//#include"headers.p4"
#include"forwarder.p4"
//#include"Slicer.p4"
//#include"SMap.p4"
#include"PayloadSelector.p4"
#include"snaps.p4"
#include"BPSK.p4"
#include"QPSK.p4"
#include"QAM16.p4"
#include"QAM64.p4"
#include"QAM256.p4"
//#include"Validator.p4"



control Ingress(
    /* User */
    inout ns_headers                       hdr,
    inout meta_data                        meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_t               ig_intr_md,
    in    ingress_intrinsic_metadata_from_parser_t   ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t        ig_tm_md)
    {

        
       Forwarder() nexthop;
        action decrement_ttc()
        {
            hdr.circ.ttc = hdr.circ.ttc |-| hdr.circ.bps;
            //hdr.circ.index = hdr.circ.index |+| 1;
            // this will be incremented every time, and reset if the we move to another bank
            hdr.circ.payload_b_shift_cntr = hdr.circ.payload_b_shift_cntr |+| hdr.mod.bps;
            // // will be incremented when the payload_b_index reach PAYLOAD_HDR_B_COUNT
            // hdr.circ.payload_hdr_shift_cntr = hdr.circ.payload_hdr_shift_cntr |+| 
            hdr.circ.iq_s_index = hdr.circ.iq_s_index |+| 1;
            // for the purpose of QAM64 .. setting ttc to 192..
            hdr.circ.index = hdr.circ.index |+| 1;

        }
        action increment_iq_hdr_index()
        {
            // this will be used to move to another hdr.IQ##i
            hdr.circ.iq_hdr_index = hdr.circ.iq_hdr_index |+| 1;
            // after we reaches the 
            hdr.circ.iq_s_index = 0;
            // this will put the value of hdr.tmp_iq to the hdr.IQ of hdr.circ.iq_hdr_index.
            // In the parser this may remove the value of PHV error occured when using actions..
            // therefore, we move this to the parser which makes it possible
            hdr.circ.iq_hdr_end = 1;
            //hdr.mod.mhl = hdr.mod.mhl |+| 1;
        }
        action increment_payload_B_index()
        {
            // this will be used to move to another hdr.payload##i.b##k
            // will be incremented when the payload_b_shift_cntr reach PAYLOAD_BITS_PER_B
            // if( hdr.circ.payload_b_shift_cntr == PAYLOAD_BITS_PER_B)
            // {
            //     hdr.circ.payload_b_index = hdr.circ.payload_b_index |+| 1;
            //     hdr.circ.payload_b_shift_cntr = 0;
            // }
        }
        action increment_payload_hdr_index()
        {
            // this will be used to move to another hdr.payload##i
            // this will be incremented when the payload_b_index reaches PAYLOAD_HDR_B_COUNT
            // when it reaches new bank then reset the 
            // if( hdr.circ.payload_b_shift_cntr == PAYLOAD_BITS_PER_B)
            // {
            //     hdr.circ.payload_b_index = hdr.circ.payload_b_index |+| 1;
            //     hdr.circ.payload_b_shift_cntr = 0;
            // }
            // if (  hdr.circ.payload_b_index  == PAYLOAD_HDR_B_COUNT-1)
            // {
            //     hdr.circ.payload_hdr_index = hdr.circ.payload_hdr_index |+| 1;
            //     hdr.circ.payload_b_index = 0;
            // }
        }
        // table tbl_payload_hdr_index_cntr 
        // {
        //     key = {
        //             hdr.circ.payload_b_index : ternary;
        //     }
        //     actions =
        //     {
        //         increment_payload_hdr_index;
        //         NoAction;
        //     }
        //     const entries = 
        //     {
        //         (PAYLOAD_HDR_B_COUNT-1) : increment_payload_hdr_index();
        //         (_):NoAction();
        //     }
        //     size = 2;
        // }

        // table tbl_payload_B_index_cntr 
        // {
        //     key = { hdr.circ.payload_b_shift_cntr : ternary; }
        //     actions = {
        //         increment_payload_B_index;
        //         NoAction;
        //     }
        //     const entries = 
        //     {
        //         (PAYLOAD_BITS_PER_B): increment_payload_B_index();
        //         (_):NoAction();
        //     }
        //     size = 2;
        // }
        
        // when should we move to another hdr.IQ##i
        table tbl_IQ_hdr_index_cntr 
        {
            key = { hdr.circ.iq_s_index : ternary; }
            actions = {
                increment_iq_hdr_index;
                NoAction;
            }
            const entries = 
            {
                (IQ_HDR_S_COUNT): increment_iq_hdr_index();
                (_):NoAction();
            }
            size = 2;
        }

        

        action finish()
        {
            //hdr.symbols.s63 = (symbol_t) hdr.circ.index;
            hdr.circ.setInvalid();

            hdr.mod.ec = 1w0;
        }
    
        action recirculate()
        {
            //port = {1: 452, 2: 324, 3: 448, 4: 196, 5: 192, 6: 64, 7: 68}
            hdr.mod.ec = 1w1;
            ig_tm_md.ucast_egress_port = NET_MOD_RECIRCULATION_PORT;
            ig_tm_md.bypass_egress = 1w1;
            ig_dprsr_md.drop_ctl[0:0] = 0;
        }
        
        action initialize()
        {
            hdr.circ.setValid();
            hdr.circ.ttc = (ttc_t) (hs_IQ_count);
            hdr.circ.index = 0;
            hdr.circ.iq_s_index = 0;
            hdr.circ.iq_hdr_index = 0;
            hdr.circ.payload_hdr_index = 0;
            hdr.circ.payload_b_index = 0;
            hdr.circ.payload_b_shift_cntr = 0;
            hdr.circ.bps = (ttc_t) hdr.mod.bps;
            // we don't need to initialize this here since we done this down..
            //hdr.circ.current_payload_b = hdr.payload0.b0;
            // hdr.circ.log2M = hdr.mod.bps; // bits per symbol/
            hdr.mod.ec = 1w1;
            recirculate();
        }
        action reset_enable_circ()
        {
            hdr.mod.ec = 1w0;
        }
        action disable_circ()
        {
            hdr.circ.setInvalid();
            hdr.mod.ec = 1w0;
        }
        
        // In the begining a packet will arrive that carries a modulation header. 
        // extract the number of bits per symbol ...
        // also the recirculation header is invalid in the begining so initialize the recirculation header
        // and enable the recirculation..
        table init_tbl 
        {
            key = { hdr.circ.isValid(): exact;
            hdr.mod.ec : exact;
            }
            actions= 
            {
                initialize;
                recirculate;
                disable_circ;
                reset_enable_circ;
            }
            size = 4;
            const entries = {
                (true, 1w1): recirculate();
                (true, 1w0): disable_circ();
                (false, 1w1): reset_enable_circ();
                (false, 1w0): initialize();
            }
        }
        
        
        table circ_table 
        {
            key = {
                    hdr.circ.isValid():exact;
                    hdr.circ.ttc : ternary;
                    }
            actions = 
            {
                decrement_ttc;
                finish;
                disable_circ;
                NoAction;

            }
            size = 20;
            const entries = 
            {
                (false, _) : disable_circ();
                (true, 0) : finish();
                (true, _) : decrement_ttc();
            }
        }
        
       
        bool enable_circ = false;

        BPSKMapper() BPSK;
        QPSKMapper() QPSK;
        QAM16Mapper() QAM16;
        QAM64Mapper() QAM64;
        QAM256Mapper() QAM256;
        payloadSelector() PayloadSelector;
        bool done  = false;

       // when you have a single table you can't access multiple register Action Tables...
       bit<8> modulus = 0;
       
       apply{
            if( hdr.circ.iq_hdr_index == IQ_HDRS_COUNT-1)
            {
                finish();
                done = true;
            }

           if(hdr.mod.isValid() && !done)
           {
              hdr.tmp_iq.setValid();
              hdr.circ.iq_hdr_end = 0;
              init_tbl.apply();
              // Due to QAM64, there will be 2 extra bits instead of 16 there wil be 18.. therefore should >=
              if( hdr.mod.bps != 6)
              {
                // in QAM64 , this procedure has been moved to the QAM64 .. itself..
                if( hdr.circ.payload_b_shift_cntr >= PAYLOAD_BITS_PER_B || hdr.circ.payload_b_shift_cntr == 0)
                {

                    hdr.circ.payload_b_shift_cntr = 0;
                    PayloadSelector.apply(hdr);
                    hdr.circ.payload_b_index = hdr.circ.payload_b_index |+| 1;
                }
                if (  hdr.circ.payload_b_index  == PAYLOAD_HDR_B_COUNT)
                {
                    hdr.circ.payload_hdr_index = hdr.circ.payload_hdr_index |+| 1;
                    hdr.circ.payload_b_index = 0;
                }
              }
    
            // Modulation....
               if(hdr.mod.bps == 1)
               {
                   BPSK.apply(hdr, meta);
                   enable_circ = true;
               }
               else if( hdr.mod.bps == 2)
               {
                   QPSK.apply(hdr, meta);
                   enable_circ = true;
               }
               else if(hdr.mod.bps == 4)
               {
                   QAM16.apply(hdr, meta);
                    enable_circ = true;
               }
               else if(hdr.mod.bps == 6)
               {
                   QAM64.apply(hdr, meta);
                   enable_circ = true;
                //if( hdr.circ.ttc == 2)  enable_circ = false; // because 2 bits remains for 64.. 128 % 6 = 2;
               }
              else if(hdr.mod.bps == 8)
               {
                   QAM256.apply(hdr, meta);
                   enable_circ = true;
               }
              else;

               if( enable_circ )
               {
                   circ_table.apply();
                   tbl_IQ_hdr_index_cntr.apply();
               }
               else 
               {
                   finish();
               }
           }
           if(hdr.mod.ec== 1w0) 
           {
               hdr.circ.setInvalid();
               hdr.tmp_iq.setInvalid(); // reset tmp//
               //hdr.bit_banks.setInvalid();
               nexthop.apply(hdr, meta, ig_intr_md, ig_prsr_md, ig_dprsr_md, ig_tm_md);

           }
       }
         
    }

  


control IngressDeparser(packet_out pkt,
    /* User */
    inout ns_headers                       hdr,
    in    meta_data                      meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md)
{
    Checksum() ipv4_checksum;
    apply {

        hdr.ipv4.hdr_checksum = ipv4_checksum.update({
                hdr.ipv4.version,
                hdr.ipv4.ihl,
                hdr.ipv4.diffserv,
                hdr.ipv4.total_len,
                hdr.ipv4.identification,
                hdr.ipv4.flags,
                hdr.ipv4.frag_offset,
                hdr.ipv4.ttl,
                hdr.ipv4.protocol,
                hdr.ipv4.src_addr,
                hdr.ipv4.dst_addr
                /* Adding hdr.ipv4_options.data results in an error */
            });
        pkt.emit(hdr);
    }
}

#endif