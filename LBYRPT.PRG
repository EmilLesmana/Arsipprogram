Function Lbyrpt()
LOCAL TGLAWAL,TGLAKHIR,I,BR,NO,MJUM,MKODE
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,1)
 NEXT
BUKABYR()
SELE pUT
SET RELATION TO KODELGN INTO LGN
SELE TRPT

SET ORDER TO 2
SET COLOR TO GR+/B,W/R
@3,15 SAY ' TANGGAL : '
@3,35 SAY '  SAMPAI '
@3,45 SAY ' TANGGAL : '
@5,15 SAY 'KODE LGN : '
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
MKODE:=SPACE(3)
@5,26 GET MKODE PICT '@!'
READ
   IF !CARITGL(TGLAWAL)
      KOMENTAR(1,' DATA TIDAK DITEMUKAN ..... ')
      CLOSE ALL
      Return (nil)
   ENDIF

COPY TO SEM.DBF WHILE TGLBYR<=TGLAKHIR
USE SEM NEW
SET RELATION TO FAKTUR INTO PUT
IF MKODE#''
  SET FILTER TO PUT->KODELGN=MKODE
ENDIF
DBGOTOP()
      TE=' LAPORAN DATA PEMBAYARAN PIUTANG LANGGANAN '

SET COLOR TO GR+/B
@1,15 SAY TE

ER:=.N.
SET COLOR TO W/R,N*/G
@11,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ


SET COLOR TO
CLEAR
IF .NOT. ER
DECLARE TPL[9],APICT[9],AJUD[9]

   DBGOTOP()
    TPL[1] = 'FAKTUR'
    TPL[2] = 'tGLOUT'
    TPL[3] = 'LGN->NAMA'
    TPL[4] = 'TGLBYR'
    TPL[5] = 'BANK'
    TPL[6] = 'GIRO'
    TPL[7] = 'TUNAI'

    APICT[1]='@!'
    APICT[2]='@D'
    APICT[3]='@!'
    APICT[4]='@D'
    APICT[5]='@!'
    APICT[6]='@E 99,999,999,999'
    APICT[7]='@E 99,999,999,999'

    AJUD[1]='NOMOR; FAKTUR '
    AJUD[2]='TANGGAL;NOTA'
    AJUD[3]='DEBITUR'
    AJUD[4]='TANGGAL;BAYAR'
    AJUD[5]='KETERANGAN'
    AJUD[6]='NILAI GIRO'
    AJUD[7]='NILAI TUNAI'

    SET COLOR TO W/N
    FOR I=0 TO 23
      @I,0 SAY REPLI(CHR(178),79)
    NEXT
    SET COLOR TO GR+/B
     @1,15 SAY TE
     @2,20 SAY ' PERIODE :'
    SET COLOR TO W/R
     @2,COL()+2 SAY TGLAWAL
    SET COLOR TO GR+/B
     @2,COL()+2 SAY '-'
    SET COLOR TO W/R
     @2,COL()+2 SAY TGLAKHIR
    DO SBOX WITH 4,4,21,76,'GR+/B,W/R'
    DBEDIT(5,5,20,75,TPL,'FUNGSI',APICT,AJUD)
    Return (nil)
ENDIF
       IF !CEKPRINT()
          CLOSE ALL
          Return (nil)
       ENDIF
       ?? CHR(15)
       @1,15 SAY TE
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '----------------------------------------------------------------------------------------------------'
@5,1 SAY '| NO FAKTUR| TGL NOTA |        DEBITUR          | TGL BYR  |  KETERANGAN   |NILAI GIRO |NILAI TUNAI|'
@6,1 SAY '----------------------------------------------------------------------------------------------------'

   BR:=7
   MJUM:=0
 DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+Padr(FAKTUR,10)+'|'+tran(tGLOUT,'@d')+'|'+lgn->NAMA
   @br,pcol() say '|'+tran(TGLBYR,'@d')+'|'+BANK+'|'
   @BR,pcol() SAY TRAN(GIRO,'@E 999,999,999')+'|'+TRAN(TUNAI,'@E 999,999,999')+'|'
   IF BR=55
@BR+1,1 SAY '----------------------------------------------------------------------------------------------------'
     @BR+2,1 SAY ''
     SETPRC(0,0)
     SET PRINT OFF
     SET DEVICE TO SCREEN
     KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
     IF !CEKPRINT()
        ?? CHR(18)
        CLOSE ALL
        Return (nil)
     ENDIF
      BR:=6
          ?? chr(15)
           @1,15 SAY TE
           @3,20 SAY ' PERIODE :'
           @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '----------------------------------------------------------------------------------------------------'
@5,1 SAY '| NO FAKTUR| TGL NOTA |        DEBITUR          | TGL BYR  |  KETERANGAN   |NILAI GIRO |NILAI TUNAI|'
@6,1 SAY '----------------------------------------------------------------------------------------------------'
       ENDIF
        BR++
        SKIP
    ENDDO
@BR,1 SAY '----------------------------------------------------------------------------------------------------'
        @BR+2,1 SAY ''
        ?? CHR(18)
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
Return (nil)
