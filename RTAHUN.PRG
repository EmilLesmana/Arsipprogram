close all
use trout.dtr
do while .not. Eof()
 if RIGHT(DTOC(tglout),4)='1900'
    CBLN=SUBSTR(DTOC(TGLOUT),4,2)
    CTGL=SUBSTR(DTOC(TGLOUT),1,2)
    CTHN=RIGHT(DTOC(TGLOUT),4)
    GAB=CBLN+'/'+CTGL+'/'+'2000'
    rEPLACE TGLOUT WITH CTOD(GAB)
 endif
 SKIP
enddo
wait
