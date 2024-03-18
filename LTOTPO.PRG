Memvar getlist
Field Tglin,nobpb,Nama,Kodbrg,Kodelgn,tglabl,mukA,;
      mobil,qtt,harga,kode1,pms
Function Ltotpo()
* program LIHAT PABRIK
LOCAL I,BR,ER,TGLAWAL,TGLAKHIR,MPMS,HAL:=1,NO,CEK,MJUM,tabel,x
SETCOLOR('')
FOR I:=1 TO 25
    SCROLL(,,,,1)
NEXT

BUKA1()

USE REKAP INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW

ER:=.N.
 CLS
 SET COLOR TO GR,W/N
 @5,10 SAY 'ISI KODE PEMASOK '
 @6,10 SAY 'JIKA KODE DIKOSONGKAN SELURUH PEMASUKAN AKAN TAMPIL'
 @7,1 SAY '---------------------------------------------------------------------------'
TGLAWAL  := CTOD(' // ')
TGLAKHIR := CTOD(' // ')
MPMS:=SPACE(3)
@ 8,7 SAY '  TANGGAL : 'GET TGLAWAL
@ 8,28 SAY '   SAMPAI'
@ 8,38 SAY '   TANGGAL :'GET TGLAKHIR
READ
IF TGLAKHIR=CTOD(' / / ')
   TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @8,51 SAY TGLAKHIR
   SET COLOR TO GR+/B
ENDIF

@9,27 SAY 'PEMASOK' GET  MPMS PICT '@!'
READ

IF MPMS#''
   SELE PMSK
   IF !CARI(12,MPMS)
      CLOSE ALL
      Return (nil)
   ENDIF
ENDIF

SELE TRSTK
SET ORDER TO 3
IF !CARITGL(TGLAWAL)
   KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
    CLOSE ALL
    Return (nil)
ENDIF

TUNGGU(12,' TUNGGU PROSES ........ ')

SELE REKAP
DELETE ALL
PACK

SELE TRSTK
DO WHILE TGLIN<=TGLAKHIR .and. .not. eof()
   IF MPMS=''
      SELE REKAP
      SEEK TRSTK->KODBRG
      IF !FOUND()
         DBAPPEND()
         REPLACE KODE1 WITH TRSTK->KODBRG,QTT WITH TRSTK->QTT
      ELSE
         REPLACE QTT WITH QTT+TRSTK->QTT
      ENDIF
   ELSE
      IF PMS==MPMS
         SELE REKAP
         SEEK TRSTK->KODBRG
         IF !FOUND()
            DBAPPEND()
            REPLACE KODE1 WITH TRSTK->KODBRG,QTT WITH TRSTK->QTT
         ELSE
            REPLACE QTT WITH QTT+TRSTK->QTT
         ENDIF
      ENDIF
   ENDIF
   SELE TRSTK
   SKIP
ENDDO

SELE REKAP
SET RELATION TO KODE1 INTO STK
DBGOTOP()
SET COLOR TO
CLEAR
SET COLOR TO W+/R+
@1,1 SAY ' APAKAH DATA AKAN DICETAK ?(Y/N) 'GET ER PICT 'Y'
SET COLOR TO
READ


IF ER
   CLEAR
   IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
   ENDIF
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'@E 999')
@ 3,2 SAY ' KARTU PEMASUKAN BARANG TANGGAL '
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '--------------------------------   --------------------------------'
@5,0 SAY '| NO|    NAMA BARANG     | QTT |   | NO|    NAMA BARANG     | QTT |'
@6,0 SAY '--------------------------------   --------------------------------'

BR := 7
NO := 1
CEK:= 1

 DO WHILE .NOT. EOF()
  IF CEK=1
   CEK:=2
   @ BR,0 SAY '|'+TRAN(NO,'@E 999')+'|'+STK->NAMA+'|'+TRAN(QTT,'@E 9,999')+'|'
  ELSE
   CEK:=1
  @ BR,35 SAY '|'+TRAN(NO,'@E 999')+'|'+STK->NAMA+'|'+TRAN(QTT,'@E 9,999')+'|'
   BR++
   NO++
  ENDIF

IF BR>=55
   IF CEK=2
    @BR,0 SAY '|'
    @BR,4 SAY '|'
    @BR,25 SAY '|'
    @BR,31 SAY '|'
    @BR,35 SAY '|'
    @BR,39 SAY '|'
    @BR,60 SAY '|'
    @BR,66 SAY '|'
      BR++
   ENDIF
@BR,0 SAY '--------------------------------   --------------------------------'
    @br+3,0 say ' '
    @br+4,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
    ENDIF
    HAL++
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'@E 999')
@ 3,2 SAY ' KARTU PEMASUKAN BARANG TANGGAL '
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '--------------------------------   --------------------------------'
@5,0 SAY '| NO|    NAMA BARANG     | QTT |   | NO|    NAMA BARANG     | QTT |'
@6,0 SAY '--------------------------------   --------------------------------'
    BR:=7
ENDIF
SKIP
ENDD

 IF CEK=2
    @BR,0 SAY '|'
    @BR,4 SAY '|'
    @BR,25 SAY '|'
    @BR,31 SAY '|'
    @BR,35 SAY '|'
    @BR,39 SAY '|'
    @BR,60 SAY '|'
    @BR,66 SAY '|'
      BR++
    ENDIF
@BR,0 SAY '--------------------------------   --------------------------------'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
  KOMENTAR(23,'  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!')
    CLOSE ALL
    Return (nil)
ENDIF

MJUM:=0
DO WHILE .NOT. EOF()
 MJUM+=(qtt*STK->harga)
 SKIP
ENDDO
DBGOTOP()

  DISPBEGIN()
  SET COLOR TO W/N
  @0,0,24,79 BOX REPLI(CHR(178),79)
  sbox(20,1,23,78,'n+/w')

  @21,2 say chr(179)+'Esc->Keluar'+chr(179)+'CTRL+HOME->Data Kiri'
  @22,2 say 'CTRL+END->Data Kanan'+chr(179)+'PGUP'+chr(179)
  @22,COL() SAY 'PGDN'+chr(179)+'HOME'+chr(179)+'END'+CHR(179)

  SBOX(4,1,17,76,'GR+/B,W/R')
  @ 2,2 SAY ' DAFTAR DATA PEMASUKAN TANGGAL '
  SET COLOR TO W/R
  @ 2,34 SAY TGLAWAL
  SET COLOR TO W/B
  @ 2,col() SAY ' SAMPAI TANGGAL '
  SET COLOR TO W/R
  @ 2,col() SAY TGLAKHIR
  @19,53 SAY 'JUMLAH Rp.'
  @19,COL() SAY MJUM PICT '@E 9,999,999,999'

  TABEL:=TBROWSEDB(5,2,16,75)
  DISPEND()

  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  tabel:addcolumn(tbcolumnnew('NAMA',{||STK->NAMA}))
  tabel:addcolumn(tbcolumnnew(' QTT ',{||TRAN(QTT,'@E 9,999')}))
  tabel:addcolumn(tbcolumnnew(' HARGA ',{||TRAN(STK->HARGA,'@e 999,999')}))
  tabel:addcolumn(tbcolumnnew(' JUMLAH ',{||TRAN(QTT*STK->HARGA,'@E 99,999,999')}))

  SETCURSOR(0)
  TABEL:HEADSEP:=CHR(205)
  TABEL:COLSEP:=CHR(179)
  tabel:footsep:=chr(205)
  do while .t.
     do while !tabel:stabilize()
     enddo

     IF TABEL:HitTop .OR. TABEL:HitBottom
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
     ENDIF
     x:=inkey(0)
     if x==27
        SET CURSOR ON
        CLOSE ALL
        Return (nil)
     endif
     key(x,tabel)
  enddo
Return nil
