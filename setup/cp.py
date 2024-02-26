
from functools import partial
import Smaps
import os

P4 = bfrt.NanoMod.pipe;

bfrt_info = bfrt.info;

M2 = P4.Ingress.BPSK.SMAP1
M4 = P4.Ingress.QPSK.SMAP2
M16 = P4.Ingress.QAM16.SMAP4
M64 = P4.Ingress.QAM64.SMAP6
M256 = P4.Ingress.QAM256.SMAP8




def clear_table(table):
    table.clear();



#smap = pipe.Ingress.constellation_register;
# _bytes = [0x00, 0xA1, 0xB2, 0xC3, 0xD4, 0xE5, 0xF6, 0x87]
# 0x0 -> 0x0a, 0x0 -> 0x0a 
# 0x0a = 
#
#
#
#
#
#
#
#
#
#
def addSymbol(reg, index, value):
    reg.add(REGISTER_INDEX=index, f1=value)

def graycode(i):
    return i

def main():
    #clear_table(tab4)
    M = 2
    for i in range(0, M):
        addSymbol(M2, i, graycode(i))

    M = 4
    for i in range(0, M):
        addSymbol(M4, i, graycode(i))
    

    M = 16
    for i in range(0, M):
        addSymbol(M16, i, graycode(i))

    


    M = 64
    for i in range(0, M):
        addSymbol(M64, i , graycode(i))

    
    M = 256
    for i in range(0, M):
        addSymbol(M256, i, graycode(i))

    

    
    
    bfrt.complete_operations()


def main2():
    #clear_table(tab4)
    path = os.getcwd()
    print( path)
    bpsk = Smaps.SMAPx("BPSK").GetSmap()
    M = 2
    for i in range(0, M):
        addSymbol(M2, i, bpsk[i])

    M = 4
    qpsk = Smaps.SMAPx("QPSK").GetSmap()

    for i in range(0, M):
        addSymbol(M4, i, qpsk[i])
    

    M = 16
    qam16 = Smaps.SMAPx("QAM16").GetSmap()

    for i in range(0, M):
        addSymbol(M16, i, qam16[i])

    


    M = 64
    qam64 = Smaps.SMAPx("QAM64").GetSmap()

    for i in range(0, M):
        addSymbol(M64, i , qam64[i])

    
    M = 256
    qam256 = Smaps.SMAPx("QAM256").GetSmap()

    for i in range(0, M):
        addSymbol(M256, i, qam256[i])

    

    
    
    bfrt.complete_operations()

if __name__=="__main__":
    main()


