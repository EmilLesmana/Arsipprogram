Function Lbyrht()
LOCAL ER,I,TGLAWAL,TGLAKHIR,BR,NO
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT

BUKABYR()
SELE Ht
Set Relation to Kodpmsk into Pmsk
SELE TRHT
SET ORDER TO 2

SET COLOR TO GR+/B
@3,15 SAY ' TANGGAL : '
@3,35 SAY '  SAMPAIÿ'
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
  TGLAKHIR:=DATE()
  @3,56 SAY TGLAKHIR
ENDIF
   IF !CARITGL(TGLAWAL)
      KOMENTAR(15,' DATA TIDAK DITEMUKAN ....... ')
      CLOSE ALL
      Return (nil)
  ENDIF
COPY TO SEM.DBF WHILE TGLBYR<=TGLAKHIR
USE SEM NEW

MKOD:=SPACE(3)
SET COLOR TO GR+/B,W/R
@7,20 SAY ' PEMASOK : ' GET MKOD PICT '@!'
READ
TE=' LAPORAN DATA PEMBAYARAN HUTANG PERUSAHAAN '

IF MKOD=''
   SET FILTER TO TGLBYR>=TGLAWAL .AND. TGLBYR<=TGLAKHIR
   DBGOTOP()
ELSE
   SET FILTER TO TGLBYR>=TGLAWAL .AND. TGLBYR<=TGLAKHIR .AND. PMS=MKOD
   DBGOTOP()
ENDIF
SET RELATION TO NOBPB INTO HT
SET COLOR TO GR+/B
@1,15 SAY TE

ER:=.N.
SET COLOR TO W/R,N*/G
@11,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ


SET COLOR TO
CLEAR

DECLARE TPL[10],APICT[10],AJUD[10]
IF .NOT. ER
   DBGOTOP()
    TPL[1] = 'NOBPB'
    TPL[2] = 'HT->TGLin'
    TPL[3] = 'PMSK->NAMA'
    TPL[4] = 'TGLBYR'
    TPL[5] = 'BANK'
    TPL[6] = 'GIRO'
    TPL[7] = 'TUNAI'

    APICT[1]='@!'
    APICT[2]='@D'
    APICT[3]='@!'
    APICT[4]='@D'
    APICT[5]='@!'
    APICT[6]='@e 99,999,999,999'
    APICT[7]='@e 99,999,999,999'

    AJUD[1]='NOMOR; BPB '
    AJUD[2]='TANGGAL;NOTA'
    AJUD[3]=' PEMASOK '
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

  ELSE
      IF !CEKPRINT()
         ?? CHR(18)
         CLOSE ALL
         Return (nil)
      ENDIF
       ?? CHR(15)
       @1,15 SAY TE
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '----------------------------------------------------------------------------------------------------'
@5,1 SAY '| NO BPB   | TGL NOTA |      PEMASOK            | TGL BYR  |  KETERANGAN   |NILAI GIRO |NILAI TUNAI|'
@6,1 SAY '----------------------------------------------------------------------------------------------------'

   BR:=7
   MJUM:=0
DO WHILE .NOT. EOF()
@BR,1 SAY '|'+padr(NOBPB,10)+'|'+tran(HT->TGLIN,'@d')+'|'+PMSK->NAMA+;
          '|'+tran(TGLBYR,'@d')+'|'
@BR,pcol() SAY BANK+'|'+TRAN(GIRO,'@e 999,999,999')+'|'+TRAN(TUNAI,'@e 999,999,999')+'|'

IF BR=55
@BR+1,1 SAY '----------------------------------------------------------------------------------------------------'
     @BR+3,1 SAY ''
     SETPRC(0,0)
     SET PRINT OFF
     SET DEVICE TO SCREEN
     SET COLOR TO W*/R
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
@5,1 SAY '| NO BPB   | TGL NOTA |       PEMASOK           | TGL BYR  |  KETERANGAN   |NILAI GIRO |NILAI TUNAI|'
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
  ENDIF
Return (nil)