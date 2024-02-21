
from functools import partial

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


if __name__=="__main__":
    main()


