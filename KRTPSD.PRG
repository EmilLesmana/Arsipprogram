Function Krtpsd()
LOCAL I,TGLAWAL,TGLAKHIR,BR,NO,ER,MTGLAWAL,MKOD,JUMIN,JUMOUT,TOT
SET COLOR TO
 FOR I:=1 TO 80
     SCROLL(,,,,,-1)
 NEXT
BUKA1()
USE TROUT.dtr INDEX TGLOUTX.ELX new
USE LGN.dmt INDEX LGN.MLX NEW
Use put.dtr index noput.elx new
USE REKAP.tmp INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW

sele rekap
dele all
pack

SET COLOR TO GR+/B
@2,10 SAY ' KARTU PERSEDIAAN BARANG '
@3,15 SAY ' TANGGAL : '
@3,35 SAY '  SAMPAI '
@3,45 SAY ' TANGGAL : '
@5,15 SAY ' KODE BARANG : '
TGLAWAL:=CTOD(' - - ')
TGLAKHIR:=CTOD(' - - ')
@3,26 GET TGLAWAL
READ
MTGLAWAL:=TGLAWAL

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

DO WHILE .T.
MKOD:=SPACE(10)
SET COLOR TO W/R,W/R
@5,29 GET MKOD PICT '@!'
READ
IF MKOD=''
  SET COLOR TO
  CLOSE ALL
  CLEAR
  Return (nil)
ENDIF
SELE STK
IF !cari(15,mkod)
   @15,1
   LOOP
ELSE
   MNAMA:=STK->NAMA
   MMIN:=MIN
   SELE REKAP
   APPEND BLANK
   REPLACE CATAT WITH 'SALDO AWAL ',TGL1 WITH TGLAWAL,HARGA3 WITH STK->QTT
   EXIT
 ENDIF
ENDDO
SELE REKAP

         TUNGGU(10,' PROSES PEMASUKAN BARANG ')
MTGLAWAL:=TGLAWAL
TGLAWAL:=MTGLAWAL
SELE HT
SET RELATION TO KODPMSK INTO PMSK
SELE Trstk
SET ORDER TO 2
SET RELATION TO nobpb INTO Ht
IF CARITGL(TGLAWAL)
   DO WHILE TGLIN<=TGLAKHIR .and. .not. eof()
      SELE REKAP
      IF Trstk->KODBRG=MKOD
         APPEND BLANK
         REPLACE CATAT WITH PMSK->NAMA,HARGA1 WITH Trstk->QTT,;
                 TGL1 WITH Trstk->TGLIN,HARGA3 WITH HARGa3-Trstk->QTT
      ENDIF
      SELE Trstk
      SKIP
   ENDDO
ENDIF

         TUNGGU(10,' PROSES PENYESUAIAN STOK   ')

TGLAWAL:=MTGLAWAL
 SELE TRSS
IF CARITGL(TGLAWAL)
   DO WHILE TGLSS<=TGLAKHIR .and. .not. eof()
         SELE REKAP
      IF TRSS->STATUS=='INSTK'
         IF TRSS->KODBRG=MKOD
            APPEND BLANK
            REPLACE CATAT WITH 'PENAMBAHAN STOK',HARGA1 WITH TRSS->QTT,;
                 TGL1 WITH TRSS->TGLSS,HARGA3 WITH HARGA3-TRSS->QTT
         ENDIF
      ELSE
         IF TRSS->KODBRG=MKOD
            APPEND BLANK
            REPLACE CATAT WITH 'PENGURANGAN STOK',HARGA2 WITH TRSS->QTT,;
                 TGL1 WITH TRSS->TGLSS,HARGA3 WITH HARGA3+TRSS->QTT
         ENDIF
      ENDIF
      SELE TRSS
      SKIP
   ENDDO
ENDIF

         TUNGGU(10,' PROSES PENGELUARAN BARANG   ')
sele put
set relation to kodelgn into Lgn
SELE Trout
TGLAWAL:=MTGLAWAL
SET RELATION TO Faktur INTO Put
IF CARITGL(TGLAWAL)
   DO WHILE TGLOUT<=TGLAKHIR .and. .not. eof()
      SELE REKAP
      IF Trout->KODBRG=MKOD
         APPEND BLANK
         REPLACE CATAT WITH LGN->NAMA,HARGA2 WITH Trout->QTT,;
                 TGL1 WITH Trout->TGLOUT,HARGA3 WITH HARGA3+Trout->QTT
      ENDIF
      SELE Trout
      SKIP
   ENDDO
ENDIF

         TUNGGU(10,' PROSES REKAPITULASI STOK   ')
SELE REKAP
SET ORDER TO 3
DBGOTOP()
JUMIN:=0
JUMOUT:=0
DO WHILE .NOT. EOF()
   JUMIN+=HARGA1
   JUMOUT+=HARGA2
   SKIP
ENDDO

SEEK MTGLAWAL
REPLACE HARGA3 WITH HARGA3-JUMIN+JUMOUT
 TOT:=HARGA3
DO WHILE .NOT. EOF()
   REPLACE HARGA3 WITH TOT+HARGA1-HARGA2
   TOT:=HARGA3
   SKIP
ENDDO
set color to
@10,0

GO TOP

SET COLOR TO
CLEAR

ER:=.N.
SET COLOR TO W/R,N*/G
@1,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ

DECLARE TPL[8],APICT[8],AJUD[8]
  IF .NOT. ER
    TPL[1] = 'TGL1'
    TPL[2] = 'CATAT'
    TPL[3] = 'HARGA1'
    TPL[4] = 'HARGA2'
    TPL[5] = 'HARGA3'

    APICT[1]='@D'
    APICT[2]='@!'
    APICT[3]='@E 9,999'
    APICT[4]='@E 9,999'
    APICT[5]='@E 99,999'

    AJUD[1]=' TANGGAL '
    AJUD[2]='KETERANGAN'
    AJUD[3]='MASUK'
    AJUD[4]='KELUAR'
    AJUD[5]='S.AKHIR'

    SET COLOR TO W/N
    @0,0,24,80 BOX REPLI(CHR(178),9)

    SET COLOR TO GR+/B
    @2,22 SAY ' KARTU PERSEDIAAN '
    @3,20 SAY ' PERIODE :'
    SET COLOR TO W/R
    @3,COL()+2 SAY MTGLAWAL
    SET COLOR TO GR+/B
    @3,COL()+2 SAY '-'
    SET COLOR TO W/R
    @3,COL()+2 SAY TGLAKHIR
    SET COLOR TO GR+/B
    @4,5 SAY 'NAMA BARANG :'
    SET COLOR TO W/R
    @4,20 SAY MNAMA
    SET COLOR TO GR+/B
    @5,5 SAY 'S. MINIMUM :'
    SET COLOR TO W/R
    @5,18 SAY MMIN PICT '@E 9,999'

    DO SBOX WITH 6,4,21,76,'GR+/B,W/R'
    DBEDIT(7,5,20,75,TPL,'FUNGSI',APICT,AJUD)
    Return (nil)

  ELSE
      IF !CEKPRINT()
         CLOSE ALL
         Return (nil)
      ENDIF
       @2,22 SAY ' KARTU PERSEDIAAN BARANG '
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(MTGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
       @4,2 SAY 'NAMA BARANG :'
       @4,16 SAY MNAMA
       @5,2 SAY 'S. MINIMUM :'
       @5,14 SAY MMIN PICT '@E 9,999'
@6,1 SAY '------------------------------------------------------------'
@7,1 SAY '| TANGGAL  |  KETERANGAN             |MASUK |KELUAR|S.AKHIR|'
@8,1 SAY '------------------------------------------------------------'
   BR:=9
DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+TRAN(TGL1,'@D')+'|'+CATAT+'|'+TRAN(HARGA1,'@E 99,999')+'|'
   @BR,PCOL() SAY TRAN(HARGA2,'@E 99,999')+'|'+TRAN(HARGA3,'@E 999,999')+'|'
   IF BR=60
@BR,1 SAY '------------------------------------------------------------'
      @BR+2,1 SAY ''
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      SET COLOR TO W*/R
      KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
      @1,0
      IF !CEKPRINT()
         CLOSE ALL
         Return (nil)
      ENDIF
       @2,22 SAY ' KARTU PERSEDIAAN BARANG '
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(MTGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
       @4,2 SAY 'NAMA BARANG :'
       @4,16 SAY MNAMA
       @5,2 SAY 'S. MINIMUM :'
       @5,14 SAY MMIN PICT '@E 9,999'
@6,1 SAY '------------------------------------------------------------'
@7,1 SAY '| TANGGAL  |  KETERANGAN             |MASUK |KELUAR|S.AKHIR|'
@8,1 SAY '------------------------------------------------------------'
      BR:=8
   ENDIF
        BR++
        SKIP
    ENDDO
@BR,1 SAY '------------------------------------------------------------'
        @BR+1,1 SAY ''
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
  ENDIF
Return Nil