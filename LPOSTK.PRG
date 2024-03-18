Memvar getlist
Field Tglin,nobpb,bukti,Nama,Kodbrg,Kodelgn,tglabl,mukA,;
      mobil,qtt,harga,hari,mrk,pbr,ket,pms
Function Lpostk()
* program LIHAT PABRIK
LOCA I,TGLAWAL,TGLAKHIR,MPMS,ER,BR,TOT,HAL,MJUM,mnobpb,C,tabel,x
 SET COLOR TO
 for i:=1 to 25
   scroll(,,,,-1)
 next

BUKA1()

 SET COLOR TO GR,W/N
 @5,10 SAY 'ISI NO BPB '
 @6,10 SAY 'JIKA NO BPB DIKOSONGKAN SELURUH PEMASUKAN AKAN TAMPIL'
 @7,1 SAY '----------------------------------------------------------------------'

SELE TRSTK
SET RELATION TO KODBRG INTO STK
DO WHILE .T.
   TGLAWAL := CTOD(' // ')
   TGLAKHIR := CTOD(' // ')
   MNOBPB:=SPACE(8)
   SET COLOR TO GR,W/N
   @9,15 SAY ' NO BPB : ' GET MNOBPB PICT '@!'
   READ

   IF MNOBPB=''
      @ 8,7 SAY '  TANGGAL : 'GET TGLAWAL
      @ 8,28 SAY '   SAMPAI'
      @ 8,38 SAY '   TANGGAL :'GET TGLAKHIR
      READ

      IF TGLAKHIR=CTOD(' / / ')
         TGLAKHIR=DATE()
         @8,51 SAY TGLAKHIR
         SET COLOR TO GR+/B
      ENDIF
      SET ORDER TO 2
      IF !CARITGL(TGLAWAL)
         KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
         @15,0
         CLOSE ALL
         Return (nil)
      ENDIF
      COPY TO SEM.DBF WHILE TGLIN<=TGLAKHIR
   ELSE
      INDEX ON NOBPB TO SEMX
      SET INDEX TO SEMX
      IF !CARI(15,MNOBPB)
         @15,0
         CLOSE ALL
         Return (nil)
      ENDIF
      COPY TO SEM.DBF WHILE MNOBPB==NOBPB
   ENDIF
   EXIT
ENDDO
USE SEM NEW
SET RELATION TO KODBRG INTO STK
DBGOTOP()


IF EOF()
   KOMENTAR(15,' DATA TIDAK DITEMUKAN ......... ')
   CLOSE ALL
   Return (nil)
ENDIF
SET COLOR TO
CLEAR
ER:=.N.
SETCOLOR('W/R,GR+/B')
@1,2 SAY ' APAKAH DATA AKAN DICETAK [Y/N] ?' GET ER PICT 'Y'
READ

IF ER
   IF !CEKPRINT()
      close all
      Return (nil)
   ENDIF
   ?? CHR(15)
   HAL:=1
   @1,1 SAY 'LEMBAR KE - '
   @1,13 SAY HAL PICT '@E 999'
   @ 3,2 SAY ' DAFTAR DATA PEMASUKAN TANGGAL '
   @ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '----------------------------------------------------------'
@5,0 SAY '| TANGGAL  |NO BUKTI | NO BPB |   NAMA BARANG      | QTT |'
@6,0 SAY '----------------------------------------------------------'
   BR:=7
DO WHILE ! EOF()
   @ BR,0 SAY '|'+tran(TGLIN,'@d')+'|'+padr(BUKTI,9)+'|'+NOBPB+'|'+;
              padr(STK->NAMA,20)+'|'
   @ BR,PCOL() SAY tran(QTT,'@E 9,999')+'|'
     BR++
   IF BR==60
@BR,0 SAY '----------------------------------------------------------'
      ? ''
      ? CHR(18)
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      SET COLOR TO
      CLEAR
      KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
      @5,0
      IF !CEKPRINT()
         close all
         Return (nil)
      ENDIF
      HAL++
   ?? CHR(15)
   HAL:=1
   @1,1 SAY 'LEMBAR KE - '
   @1,13 SAY HAL PICT '@E 999'
   @ 3,2 SAY ' DAFTAR DATA PEMASUKAN TANGGAL '
   @ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '----------------------------------------------------------'
@5,0 SAY '| TANGGAL  |NO BUKTI | NO BPB |   NAMA BARANG      | QTT |'
@6,0 SAY '----------------------------------------------------------'
   BR:=7
   ENDIF
   SKIP
ENDD
@BR,0 SAY '----------------------------------------------------------'
      ? ''
      ?? CHR(18)
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    KOMENTAR(15,'  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!')
    CLOSE ALL
    Return (nil)
ENDIF

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
  TABEL:=TBROWSEDB(5,2,16,75)
  DISPEND()

  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  tabel:addcolumn(tbcolumnnew('TGLIN',{||TGLIN}))
  tabel:addcolumn(tbcolumnnew('NO BUKTI',{||BUKTI}))
  tabel:addcolumn(tbcolumnnew('NO BPB',{||NOBPB}))
  tabel:addcolumn(tbcolumnnew('NAMA BARANG',{||STK->NAMA}))
  tabel:addcolumn(tbcolumnnew(' QTT ',{||TRAN(QTT,'@E 9,999')}))

  SETCURSOR(0)
  TABEL:HEADSEP:=CHR(205)
  TABEL:COLSEP:=CHR(179)
  tabel:footsep:=chr(205)
  TABEL:FREEZE:=2
  TABEL:COLPOS:=3
  do while .t.
     IF TABEL:COLPOS>TABEL:COLCOUNT
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
     elseif tabel:colpos<=tabel:freeze
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
        tabel:colpos:=3
     endif

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
Return nil