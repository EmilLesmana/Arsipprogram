Function Lout()
* program LIHAT PABRIK
LOCAL I,TGLAWAL,TGLAKHIR,PIL,TEKS1,ER,HAL,BR,TOT
buka2()
 SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
Sele Put
set Relation to Kodelgn into Lgn
sele Trout
set order to 2

 SET COLOR TO GR,W/N
@5,10 SAY 'DATA PENJUALAN DARI'
TGLAWAL  := CTOD(' // ')
TGLAKHIR := CTOD(' // ')
@ 6,7 SAY '  TANGGAL : 'GET TGLAWAL
@ 6,28 SAY '   SAMPAI'
@ 6,38 SAY '   TANGGAL :'GET TGLAKHIR
READ

IF TGLAKHIR=CTOD(' / / ')
   TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @6,51 SAY TGLAKHIR
ENDIF

IF .NOT.CARITGL(TGLAWAL)
   KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
   CLOSE ALL
   Return (nil)
ENDIF

COPY TO SEM.DBF WHILE TGLOUT<=TGLAKHIR
USE SEM NEW

SET COLOR TO GR+/B,W/R
@8,20 SAY ' PILIH DATA YANG AKAN DI TAMPILKAN '
*CENTER(' PILIH DATA YANG AKAN DI TAMPILKAN ',8,1,80,'GR+/B,W/R')
@10,2 PROMPT ' 1. SELURUH DATA PENJUALAN    '
@11,2 PROMPT ' 2. DATA UNTUK JASA SPOORING  '
@12,2 PROMPT ' 3. DATA UNTUK JASA BALANCING '
@13,2 PROMPT ' 4. DATA PENGELUARAN          '
@14,2 PROMPT ' 5. KEMBALI KE MENU           '
MENU TO PIL

DO CASE
   CASE PIL %5=0
    SET COLOR TO
    CLOSE ALL
    Return (nil)
   CASE PIL=1
    SET FILTER TO TGLOUT>=TGLAWAL .AND. TGLOUT<=TGLAKHIR
    TEKS1=' DAFTAR DATA PENJUALAN TANGGAL '
   CASE PIL=2
    SET FILTER TO TGLOUT>=TGLAWAL .AND. TGLOUT<=TGLAKHIR .AND. KODBRG='001       '
    TEKS1=' DATA HASIL JASA SPOORING '
   CASE PIL=3
    SET FILTER TO TGLOUT>=TGLAWAL .AND. TGLOUT<=TGLAKHIR .AND. KODBRG='002       '
    TEKS1=' DATA HASIL JASA BALANCING '
   CASE PIL=4
    SET FILTER TO TGLOUT>=TGLAWAL .AND. TGLOUT<=TGLAKHIR .AND. KODBRG='005       '
    TEKS1=' DATA PENGELUARAN '
ENDCASE
DBGOTOP()
SET RELATION TO KODBRG INTO STK,To Faktur into Put

  IF EOF()
     KOMENTAR(17,'  DATA TIDAK DITEMUKAN  ')
     CLOSE ALL
     Return (nil)
  ENDIF
SET COLOR TO
CLEAR

ER:=.N.
 SET COLOR TO W+/R+
 @1,1 SAY ' APAKAH DATA AKAN DICETAK ?(Y/N) 'GET ER PICT 'Y'
 SET COLOR TO
 READ

IF ER
   IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
   ENDIF
   HAL:=1
   CLEAR
    ?? chr(15)
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'@E 999')
@ 3,2 SAY TEKS1
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '------------------------------------------------------------------------------------'
@5,0 SAY '| TANGGAL  | FAKTUR| Keterangan    |   NAMA BARANG     |QTT|   HARGA   |   JUMLAH  |'
@6,0 SAY '------------------------------------------------------------------------------------'

BR:= 7
TOT:=0

 DO WHILE .NOT. EOF()
    @ BR,0 SAY '|'+tran(TGLOUT,'@d')+'|'+Padr(FAKTUR,7)+'|'+PadR(lgn->nama,15)+'|';
               +PADR(If(kodbrg#'003       ',STK->NAMA,mobil),19)
    @ BR,PCOL() SAY '|'+TRAN(QTT,'@E 999')+'| '+TRAN(HARGA,'@E 99,999,999')+'|'
    JUMLAH:=HARGA*QTT
    @ BR,pcol() SAY TRAN(JUMLAH,'@E 999,999,999')+'|'
    BR++
    TOT+=JUMLAH

IF BR=55
@br,0 SAY '------------------------------------------------------------------------------------'
@BR+1,68 SAY TOT PICT '@E 9,999,999,999'
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
@ 3,2 SAY TEKS1
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '------------------------------------------------------------------------------------'
@5,0 SAY '| TANGGAL  | FAKTUR| Keterangan    |   NAMA BARANG     |QTT|   HARGA   |   JUMLAH  |'
@6,0 SAY '------------------------------------------------------------------------------------'
    BR:=7
ENDIF
SKIP
ENDD

@br,0 SAY '------------------------------------------------------------------------------------'
@BR+1,68 SAY TOT PICT '@E 9,999,999,999'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO GR+/B
 KOMENTAR(23,'  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!')
    CLOSE ALL
    Return (nil)
ENDIF
 MJUM:=0
DO WHILE .NOT. EOF()
 MJUM+=QTT*harga
 SKIP
ENDDO
DBGOTOP()
DECLARE TPL[7],APICT[7],JUD[7]
TPL[1]='TGLOUT'
TPL[2]='FAKTUR'
TPL[3]='padR(lgn->nama,15)'
TPL[4]='If(kodbrg#"003       ",STK->NAMA,mobil)'
TPL[5]='QTT'
TPL[6]='HARGA'
TPL[7]='QTT*HARGA'

APICT[1]='@D'
APICT[2]='@!'
APICT[3]='@!'
APICT[4]='@!'
APICT[5]='@E 9,999'
APICT[6]='@E 99,999,999'
APICT[7]='@E 99,999,999,999'

JUD[1]='TGL JUAL'
JUD[2]=' FAKTUR '
JUD[3]=' Keterangan '
JUD[4]=' NAMA BARANG '
JUD[5]=' QTT '
JUD[6]=' HARGA '
JUD[7]=' JUMLAH '

FOR I=0 TO 23
  SET COLOR TO W/N
  @I,0 SAY REPLI(CHR(178),79)
NEXT
SET COLOR TO W/B
@ 2,2 SAY TEKS1
SET COLOR TO W/R
@ 2,34 SAY TGLAWAL
SET COLOR TO W/B
@ 2,col()+1 SAY ' SAMPAI TANGGAL '
SET COLOR TO W/R
@ 2,col() SAY TGLAKHIR
DO SBOX WITH 4,1,21,76,'GR+/B,W/R'
@23,53 SAY 'JUMLAH Rp.'
@23,63 SAY MJUM PICT '@E 999,999,999,999'
DBEDIT(5,2,20,75,TPL,'FUNGSI',APICT,JUD)
Return (nil)
