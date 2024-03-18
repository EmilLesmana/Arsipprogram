Function Krtut()
LOCAL I,MTOT,TOTJL,TOTBYR,TGLAWAL,TGLAKHIR,MKOD,TE,MFAKTUR,cNama
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
BUKA2()
USE REKAP.TMP INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW
SELE REKAP
DELE ALL
PACK

SET COLOR TO GR+/B,W/R
TE:=' KARTU PIUTANG LANGGANAN '
@5,17 SAY TE
MKOD:=SPACE(3)
@2,17 SAY 'KODE LANGGANAN : ' GET MKOD PICT '@!'
READ
if mkod=''
   SET COLOR TO
   CLEAR
   CLOSE ALL
   Return (nil)
ENDIF
SELE LGN
if .not.CARI(15,MKOD)
   @15,0
   CLOSE ALL
   Return (nil)
else
   cNama:=nama
ENDIF

SET COLOR TO GR+/B
@7,15 SAY ' TANGGAL : '
@7,35 SAY '  SAMPAI '
@7,45 SAY ' TANGGAL : '
TGLAWAL:=CTOD(' - - ')
TGLAKHIR:=CTOD(' - - ')
@7,26 GET TGLAWAL
READ

IF TGLAWAL=CTOD(' - - ')
  SET COLOR TO
  CLOSE ALL
  CLEAR
  Return (nil)
ENDIF

@7,56 GET TGLAKHIR
READ

IF TGLAKHIR=CTOD(' - - ')
  TGLAKHIR=DATE()
  @7,56 SAY TGLAKHIR
ENDIF

MTGLAWAL:=TGLAWAL
SELE REKAP
APPEND BLANK
REPLACE TGL1 WITH MTGLAWAL,CATAT WITH 'SALDO AWAL ',HARGA3 WITH LGN->TOTALUT
Sele Put
set Relation to kodelgn into lgn
SELE Trout
SET ORDER TO 2
SET RELATION TO KODBRG INTO STK,to Faktur into put
IF CARITGL(TGLAWAL)
   DO WHILE TGLOUT<=TGLAKHIR .AND. .NOT. EOF()
      IF put->KODELGN=MKOD
         MFAKTUR:=FAKTUR
         DO WHILE MFAKTUR=FAKTUR
            SELE REKAP
            APPEND BLANK
            REPLACE TGL1 WITH Trout->TGLOUT,KODE1 WITH str(Trout->FAKTUR),;
        CATAT WITH (If(Trout->kodbrg#'003       ',STK->NAMA,Trout->mobil)),;
              HARGA1 WITH (Trout->QTT*Trout->HARGA)
            SELE Trout
            SKIP
         ENDDO
         SKIP -1
         IF Put->tunai>0
            SELE REKAP
            APPEND BLANK
            REPLACE TGL1 WITH Trout->TGLOUT,KODE1 WITH str(Trout->FAKTUR),;
                    CATAT WITH 'PEMBAYARAN  ',HARGA2 WITH Put->Tunai
         ENDIF
      ENDIF
      SELE Trout
      SKIP
   ENDDO
ENDIF

TGLAWAL:=MTGLAWAL
SELE TRPT
IF CARITGL(TGLAWAL)
   DO WHILE TGLBYR<=TGLAKHIR .AND. .NOT. EOF()
      IF KODELGN=MKOD
            SELE REKAP
            APPEND BLANK
            REPLACE TGL1 WITH TRPT->TGLBYR,KODE1 WITH str(TRPT->FAKTUR),;
              CATAT WITH 'PEMBAYARAN',HARGA2 WITH (TRPT->GIRO+TRPT->TUNAI)
      ENDIF
      SELE TRPT
      SKIP
   ENDDO
ENDIF

SELE REKAP
SET ORDER TO 3
DBGOTOP()
TOTJL:=0
TOTBYR:=0
DO WHILE .NOT. EOF()
   TOTJL+=HARGA1
   TOTBYR+=HARGA2
   SKIP
ENDDO
DBGOTOP()
REPLACE HARGA3 WITH HARGA3+TOTBYR-TOTJL

MTOT:=HARGA3
DO WHILE .NOT. EOF()
   REPLACE HARGA3 WITH MTOT+HARGA1-HARGA2
   MTOT:=HARGA3
   SKIP
ENDDO

SET COLOR TO
CLEAR
ER:=.N.
SET COLOR TO W/R,N*/G
@1,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ
SET COLOR TO
CLEAR
DBGOTOP()
IF .NOT. ER
   SET COLOR TO W/N
   @0,0,24,80 BOX REPLI(CHR(178),9)

   SET COLOR TO GR+/B
   @2,22 SAY TE
   @3,20 SAY ' PERIODE :'
   SET COLOR TO W/R
   @3,COL()+2 SAY MTGLAWAL
   SET COLOR TO GR+/B
   @3,COL()+2 SAY '-'
   SET COLOR TO W/R
   @3,COL()+2 SAY TGLAKHIR
   @4,2 SAY ' Pelanggan : '+cNAMA
   @23,27 SAY TOTJL PICT '@E 99,999,999,999.99'
   @23,42 SAY TOTBYR PICT '@E 99,999,999,999.99'
    DECLARE TPL[6],APICT[6],AJUD[6]
    TPL[1] = 'TGL1'
    TPL[2] = 'kODE1'
    TPL[3] = 'CATAT'
    TPL[4] = 'HARGA1'
    TPL[5] = 'HARGA2'
    TPL[6] = 'HARGA3'
    APICT[1]='@D'
    APICT[2]='@!'
    APICT[3]='@!'
    APICT[4]='@E 99,999,999,999'
    APICT[5]='@E 99,999,999,999'
    APICT[6]='@E 99,999,999,999'
    AJUD[1]='TANGGAL'
    AJUD[2]='NO FAKTUR'
    AJUD[3]=' KETERANGAN '
    AJUD[4]=' DEBET '
    AJUD[5]=' KREDIT '
    AJUD[6]=' SALDO '
   DO SBOX WITH 5,4,21,76,'GR+/B,W/R'
   DBEDIT(6,5,20,75,TPL,'FUNGSI',APICT,AJUD)
   Return (nil)
ELSE
   IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
   ENDIF
       @1,15 SAY TE
       @2,20 SAY ' PERIODE :'
       @2,31 SAY Tran(MTGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
       @3,2 SAY 'Pelanggan :'+cNAMA
@4,1 SAY '---------------------------------------------------------------------------------'
@5,1 SAY '| TANGGAL  |FAKTUR|       KETERANGAN        |    DEBET  |   KREDIT  |   SALDO   |'
@6,1 SAY '---------------------------------------------------------------------------------'
BR:=7;TOTJL:=0;TOTBYR:=0
DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+TRAN(TGL1,'@D')+'|'+Padr(Kode1,6)+'|'+CATAT+'|'
   @BR,PCOL() SAY TRAN(HARGA1,'@E 999,999,999')+'|'+TRAN(HARGA2,'@E 999,999,999')
   @BR,PCOL() SAY '|'+TRAN(HARGA3,'@E 999,999,999')+'|'
   TOTJL+=HARGA1
   TOTBYR+=HARGA2

   IF BR=55
@BR,1 SAY '---------------------------------------------------------------------------------'
@BR+1,44 SAY TOTJL PICT '@E 999,999,999'
@BR+1,56 SAY TOTBYR PICT '@E 999,999,999'
     @BR+2,1 SAY ''
     SETPRC(0,0)
     SET PRINT OFF
     SET DEVICE TO SCREEN
     KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
   IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
   ENDIF
       @1,15 SAY TE
       @2,20 SAY ' PERIODE :'
       @2,31 SAY Tran(MTGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
       @3,2 SAY 'Pelanggan :'+cNAMA
@4,1 SAY '---------------------------------------------------------------------------------'
@5,1 SAY '| TANGGAL  |FAKTUR|       KETERANGAN        |    DEBET  |   KREDIT  |   SALDO   |'
@6,1 SAY '---------------------------------------------------------------------------------'
      BR:=6
   ENDIF
   BR++
   SKIP
ENDDO
@BR,1 SAY '---------------------------------------------------------------------------------'
@BR+1,44 SAY TOTJL PICT '@E 999,999,999'
@BR+1,56 SAY TOTBYR PICT '@E 999,999,999'
        @BR+2,1 SAY ''
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
ENDIF
Return nil