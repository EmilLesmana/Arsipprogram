Function Lban()
* program LIHAT PABRIK
LOCAL I,TGLAWAL,TGLAKHIR,ER,BR,TOT,MJUM
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT

BUKA2()
USE REKAP.tmp INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW
DELETE ALL
PACK

ER:=.N.
 SET COLOR TO
 CLEAR
 SET COLOR TO GR,W/N
 @5,10 SAY 'TOTAL PENJUALAN BAN '
 @6,10 SAY '  MENURUT JENIS BARANG'
 @7,1 SAY '---------------------------------------------------------------------------'
SELE Trout
set order to 2
TGLAWAL := CTOD(' // ')
TGLAKHIR := CTOD(' // ')
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

IF !CARITGL(TGLAWAL)
   KOMENTAR(15, '  DATA TIDAK DITEMUKAN  ')
    CLOSE ALL
    Return (nil)
ENDIF


SET COLOR TO W*/R
@12,30 SAY ' TUNGGU PROSES ........ '
DO WHILE TGLOUT<=TGLAKHIR .and. .not. eof()
   //IF KODBRG<>'001       ' .AND. KODBRG<>'002       ' ;
   //   .AND. KODBRG<>'003       '
      SELE REKAP
      SEEK Trout->KODBRG
      IF !FOUND()
         DBAPPEND()
      REPLACE QTT WITH Trout->QTT,HARGA WITH Trout->QTT*Trout->HARGA,;
              KODE1 WITH Trout->KODBRG
      ELSE
      REPLACE QTT WITH QTT+Trout->QTT,;
              HARGA WITH HARGA+(Trout->QTT*Trout->HARGA)
      ENDIF
   //ENDIF
   SELE Trout
   SKIP
ENDDO

SELE REKAP
DBGOTOP()
SET RELATION TO KODE1 INTO STK

 SET COLOR TO
 CLEAR
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
@1,1 SAY 'LEMBAR KE - '
@1,13 SAY HAL PICT '@E 999'
@ 3,2 SAY ' KARTU PENJUALAN BAN  TANGGAL '
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '------------------------------------------------------------------------'
@5,0 SAY '|NO |  NAMA BARANG     | QTT |  PENJUALAN   |   PEMBELIAN  | KEUNTUNGAN |'
@6,0 SAY '------------------------------------------------------------------------'

BR := 7;NO:=1;mjum:=0
DO WHILE .NOT. EOF()
   @ BR,0 SAY '|'+TRAN(NO,'@E 999')+'|'+padr(stk->NAMA,18)+'|'+TRAN(QTT,'@E 9,999')+'|'
   @ BR,30 SAY TRAN(HARGA,'@E 99,999,999,999')+'|'+TRAN(STK->HARGA*QTT,'@E 99,999,999,999')
   @ BR,59 SAY '|'+TRAN(HARGA-(STK->HARGA*QTT),'@E 9999,999,999')+'|'
    BR++;NO++;mjum+=HARGA-(STK->HARGA*QTT)

IF BR=55
@BR,0 SAY '------------------------------------------------------------------------'
@br+1,57 say tran(mjum,'@e 999,999,999,999')
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
@1,1 SAY 'LEMBAR KE - '
@1,13 SAY HAL PICT '@E 999'
@ 3,2 SAY ' KARTU PENJUALAN BAN  TANGGAL '
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '------------------------------------------------------------------------'
@5,0 SAY '|NO |  NAMA BARANG     | QTT |  PENJUALAN   |   PEMBELIAN  | KEUNTUNGAN |'
@6,0 SAY '------------------------------------------------------------------------'
    BR:=7
ENDIF
SKIP
ENDD
@BR,0 SAY '------------------------------------------------------------------------'
@br+1,57 say tran(mjum,'@e 999,999,999,999')
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
 @ 23,20 SAY '  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!'
 WAIT ''
 SET COLOR TO
 CLEAR
 CLOSE ALL
 Return (nil)
ENDIF

MJUM:=0
DO WHILE .NOT. EOF()
 MJUM+=harga-(QTT*STK->HARGA)
 SKIP
ENDDO

GO TOP
DECLARE TPL[5],APICT[5],JUD[5]
TPL[1]='STK->NAMA'
TPL[2]='QTT'
TPL[3]='HARGA'
TPL[4]='QTT*STK->HARGA'
TPL[5]='HARGA-(QTT*STK->HARGA)'

APICT[1]='@!'
APICT[2]='@E 999,999'
APICT[3]='@E 999,999,999,999'
APICT[4]='@E 999,999,999,999'
APICT[5]='@E 999,999,999,999'

JUD[1]=' NAMA BARANG '
JUD[2]=' QTT '
JUD[3]=' PENJUALAN '
JUD[4]=' PEMBELIAN '
JUD[5]=' KEUNTUNGAN '

FOR I=0 TO 23
  SET COLOR TO W/N
  @I,0 SAY REPLI(CHR(178),79)
NEXT
SET COLOR TO W/B
@ 2,7 SAY ' KARTU PENJUALAN BAN  TANGGAL '
SET COLOR TO W/R
@ 2,39 SAY TGLAWAL
SET COLOR TO W/B
@ 2,col() SAY ' SAMPAI TANGGAL '
SET COLOR TO W/R
@ 2,col() SAY TGLAKHIR
DO SBOX WITH 4,6,21,71,'GR+/B,W/R'
@23,47 SAY 'JUMLAH Rp.'
@23,58 SAY MJUM PICT '@E 999,999,999,999'
DBEDIT(5,7,20,70,TPL,'FUNGSI',APICT,JUD)
Return (nil)