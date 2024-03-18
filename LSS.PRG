Function Lss()
LOCAL TGLAWAL,TGLAKHIR,BR,I,PIL,ER
SET COLOR TO
 FOR I:=1 TO 80
     SCROLL(,,,,,-1)
 NEXT
CLEAR
SELE A
USE TRSS.dtr INDEX TGLSSX.ELX
SELE B
USE STK.dmt INDEX STKX.mLX

SELE A
SET COLOR TO GR+/B
@3,15 SAY ' TANGGAL : '
@3,35 SAY '  SAMPAI '
@3,45 SAY ' TANGGAL : '
TGLAWAL:=CTOD(' - - ')
TGLAKHIR:=CTOD(' - - ')
@3,26 GET TGLAWAL
READ

IF TGLAWAL=CTOD(' - - ')
  SET COLOR TO
  CLOSE ALL
  CLEAR
  Return (nil)
ENDIF

@3,56 GET TGLAKHIR
READ

IF TGLAKHIR=CTOD(' - - ')
  TGLAKHIR=DATE()
  @3,56 SAY TGLAKHIR
ENDIF

 IF .NOT.CARITGL(TGLAWAL)
     KOMENTAR(15,' DATA TIDAK DITEMUKAN ....... ')
     CLOSE ALL
     Return (nil)
 ENDIF

COPY TO SEM.DBF WHILE TGLSS<=TGLAKHIR
SELE C
USE SEM

SELE C
DBGOTOP()
SET RELATION TO KODBRG INTO B

SET COLOR TO GR+/B,W/R
@5,1 PROMPT ' 1. PENAMBAHAN STOK BARANG  '
@7,1 PROMPT ' 2. PENGURANGAN STOK BARANG '
MENU TO PIL

DO CASE
  CASE PIL=1
   TE=' LAPORAN PENAMBAHAN STOK BARANG '
      SET FILTER TO TGLSS>=TGLAWAL .AND. TGLSS<=TGLAKHIR;
      .AND. STATUS='INSTK'
  CASE PIL=2
   TE=' LAPORAN PENGURANGAN STOK BARANG '
      SET FILTER TO TGLSS>=TGLAWAL .AND. TGLSS<=TGLAKHIR ;
      .AND. STATUS='OTSTK'
ENDCASE

SET COLOR TO GR+/B
@1,15 SAY TE

ER:=.N.
SET COLOR TO W/R,N*/G
@11,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ


DBGOTOP()
SET COLOR TO
CLEAR

DECLARE TPL[9],APICT[9],AJUD[9]

  IF .NOT. ER
    TPL[1] = 'BUKTI'
    TPL[2] = 'TGLSS'
    TPL[3] = 'B->NAMA'
    TPL[4] = 'QTT'
    TPL[5] = 'HARGA'
    TPL[6] = 'KET'

    APICT[1]='@!'
    APICT[2]='@D'
    APICT[3]='@!'
    APICT[4]='@E 999,999'
    APICT[5]='@E 99,999,999'
    APICT[6] = '@!'

    AJUD[1]='NO BUKTI'
    AJUD[2]='TANGGAL'
    AJUD[3]='NAMA BARANG'
    AJUD[4]=' QUANTITY '
    AJUD[5]=' HARGA '
    AJUD[6] = ' KETERANGAN '

    SET COLOR TO W/N
    FOR I=0 TO 23
      @I,0 SAY REPLI(CHR(178),79)
    NEXT
    SET COLOR TO GR+/B
    @2,15 SAY TE
    @3,20 SAY ' PERIODE :'
    SET COLOR TO W/R
    @3,COL()+2 SAY TGLAWAL
    SET COLOR TO GR+/B
    @3,COL()+2 SAY '-'
    SET COLOR TO W/R
    @3,COL()+2 SAY TGLAKHIR
    DO SBOX WITH 5,4,21,76,'GR+/B,W/R'
    DBEDIT(6,5,20,75,TPL,'FUNGSI',APICT,AJUD)
    Return (nil)

  ELSE
      IF !CEKPRINT()
         CLOSE ALL
         CLEAR
         Return (nil)
      ENDIF
       @1,15 SAY TE
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '--------------------------------------------------------------------------'
@5,1 SAY '|NO BUK| TANGGAL  |    NAMA BARANG      |  QTT  | HARGA  |  KETERANGAN   |'
@6,1 SAY '--------------------------------------------------------------------------'
   BR:=7
   DO WHILE .NOT. EOF()
     @BR,1 SAY '|'+PADR(BUKTI,6)+'|'+TRAN(TGLSS,'@D')
     @BR,PCOL() SAY '|'+PADR(B->NAMA,21)+'|'+TRAN(QTT,'@E 999,999')
     @BR,pcol() SAY '|'+TRAN(HARGA,'@E 9999,999')+'|'+PADC(KET,15)+'|'
     IF BR=60
@BR+1,1 SAY '--------------------------------------------------------------------------'
      @BR+2,1 SAY ''
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
      IF !CEKPRINT()
         CLOSE ALL
         CLEAR
         Return (nil)
      ENDIF
      BR:=6
      @1,15 SAY TE
      @3,20 SAY ' PERIODE :'
      @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '--------------------------------------------------------------------------'
@5,1 SAY '|NO BUK| TANGGAL  |    NAMA BARANG      |  QTT  | HARGA  |  KETERANGAN   |'
@6,1 SAY '--------------------------------------------------------------------------'
       ENDIF
        BR++
        SKIP
ENDDO
@BR,1 SAY '--------------------------------------------------------------------------'
        @BR+1,1 SAY ''
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
  ENDIF
Return Nil