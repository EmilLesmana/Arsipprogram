Function LHKAS()
* program LIHAT PABRIK
LOCAL I,TGLAWAL,TGLAKHIR,ER,BR,TOT,MJUM
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
dbcloseall()
If !kass()
   Return nil
Endif

use rekap.tmp index 'kode1.tmp','tgl1.tmp' new

SELE REKAP
ZAP

ER:=.N.
 SET COLOR TO
 CLEAR
 SET COLOR TO GR,W/N
 @6,10 SAY '  MENURUT JENIS KAS'
 @7,1 SAY '---------------------------------------------------------------------------'
SELE KAS
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

sele kas
set order to 2
IF !CARITGL(TGLAWAL)
   KOMENTAR(15, '  DATA TIDAK DITEMUKAN  ')
   CLOSE ALL
   Return (nil)
ENDIF

while tglout<=tglakhir .and. !Eof()
     sele rekap
     dbappend()
     replace tgl1 with kas->tglout,catat with kas->nama,harga with kas->jumlah
     sele kas
     dbskip()
enddo

sele Rekap
SET order to 2
dbgotop()

IF Eof()
   KOMENTAR(15, '  DATA TIDAK DITEMUKAN  ')
   inkey(0)
    CLOSE ALL
    Return (nil)
ENDIF

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
   ?? CHR(15)
  HAL:=1
@1,1 SAY 'LEMBAR KE - '
@1,13 SAY HAL PICT '@E 999'
@ 2,2 SAY ' PENGELUARAN KAS '
@ 3,34 SAY 'TANGGAL - '+Tran(TGLAWAL,'@d')+'- Sampai - '+Tran(Tglakhir,'@d')
@4,0 SAY '-----------------------------------------------------'
@5,0 SAY '| NO |Tanggal |    NAMA                 |  Jumlah   |'
@6,0 SAY '-----------------------------------------------------'
BR := 7;NO:=1;mjum:=0
DO WHILE .NOT. EOF()
   @ BR,0 SAY '|'+TRAN(NO,'@E 9999')+'|'+Tran(Tgl1,'@d')+'|'+;
              Padc(catat,25)+'|'+Tran(harga,'@e 999,999,999')
    BR++;NO++;mjum+=harga

IF BR=55
@Br,0 SAY '-----------------------------------------------------'
@br+1,30 say tran(mjum,'@e 9,999,999,999')
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
@ 2,2 SAY ' PENGELUARAN KAS '
@ 3,34 SAY 'TANGGAL - '+Tran(TGLAWAL,'@d')+'- Sampai - '+Tran(Tglakhir,'@d')
@4,0 SAY '-----------------------------------------------------'
@5,0 SAY '| NO |Tanggal |    NAMA                 |  Jumlah   |'
@6,0 SAY '-----------------------------------------------------'
    BR:=7
ENDIF
SKIP
ENDD
@Br,0 SAY '-----------------------------------------------------'
@br+1,30 say tran(mjum,'@e 9,999,999,999')
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
 MJUM+=harga
 SKIP
ENDDO

dbgotop()
DECLARE TPL[3],APICT[3],JUD[3]
TPL[1]='TGL1'
TPL[2]='catat'
TPL[3]='harga'

APICT[1]='@D'
APICT[2]='@!'
APICT[3]='@E 999,999,999'

JUD[1]=' TANGGAL '
JUD[2]=' NAMA '
JUD[3]=' JUMLAH '

FOR I=0 TO 23
  SET COLOR TO W/N
  @I,0 SAY REPLI(CHR(178),79)
NEXT
SET COLOR TO W/B
@ 2,7 SAY ' Pengeluaran KAS'
SET COLOR TO W/R
@ 2,35 SAY TGLAWAL
SET COLOR TO W/B
@ 2,45 SAY ' SAMPAI TANGGAL '
SET COLOR TO W/R
@ 2,62 SAY TGLAKHIR
DO SBOX WITH 4,6,21,71,'GR+/B,W/R'
@23,47 SAY 'JUMLAH Rp.'
@23,58 SAY MJUM PICT '@E 9,999,999,999'
DBEDIT(5,7,20,70,TPL,'FUNGSI',APICT,JUD)
Return (nil)