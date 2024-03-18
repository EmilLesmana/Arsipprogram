Memvar getlist
Field Tglvlk,Nota,Pbr,Nama,Kodbrg,Mrk,Harga,;
      Qtt,Ket,mobil
Function Lvlkabl()
Local Er,br,ul,no,hal,i
* program LIHAT PABRIK
USE TRVLK NEW
USE STK INDEX ('STKX.ELX') NEW
SELE TRVLK
SET RELATION TO KODBRG INTO STK
DBGOTOP()

ER:=.N.
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
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,10 SAY '   DAFTAR DATA BARANG VULKANISIR    '
@4,0 SAY '-----------------------------------------------------------------------------'
@5,0 SAY '|TANGGAL |NO NOTA| KODE BRG |MRK|PBR|QTT| HARGA | KTRGN|  MOBIL/NAMA        |'
@6,0 SAY '-----------------------------------------------------------------------------'
BR := 7
UL := 0
NO := 1
 DO WHILE .NOT. EOF()
    @ BR,0 SAY '|'
    @ BR,1 SAY TGLVLK
    @ BR,9 SAY '|'
    @ BR,10 SAY 'K'
    @ BR,11 SAY NOTA PICT '@B 9999'
    @ BR,17 SAY '|'
    @ BR,18 SAY KODBRG
    @ BR,28 SAY '|'
    @ BR,29 SAY MRK
    @ BR,32 SAY '|'
    @ BR,33 SAY PBR
    @ BR,36 SAY '|'
    @ BR,37 SAY QTT PICT '999'
    @ BR,40 SAY '|'
    @ BR,41 SAY HARGA PICT '999,999'
    @ BR,48 SAY '|'
    @ BR,49 SAY KET
    @ BR,55 SAY '|'
    @ BR,56 SAY MOBIL
    @ BR,76 SAY '|'
    BR:=BR+1
    UL:=UL+1

IF UL>=49
@BR,0 SAY '-----------------------------------------------------------------------------'
    @br+3,0 say ' '
    @br+4,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO
    CLEAR
    SET COLOR TO GR+/B
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
       CLOSE ALL
       Return (nil)
    ENDIF
    HAL++
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,10 SAY '   DAFTAR DATA BARANG VULKANISIR   '
@4,0 SAY '-----------------------------------------------------------------------------'
@5,0 SAY '|TANGGAL |NO NOTA| KODE BRG |MRK|PBR|QTT| HARGA | KTRGN|  MOBIL/NAMA        |'
@6,0 SAY '-----------------------------------------------------------------------------'
    BR:=7
    UL:=0
ENDIF

SKIP
ENDD
SET COLOR TO GR
@BR,0 SAY '-----------------------------------------------------------------------------'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO GR+/B
 @ 23,20 SAY '  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!'
 WAIT ''
     SET COLOR TO
    CLEAR
    CLOSE ALL
    Return (nil)
ENDIF


DECLARE TPL[9],APICT[9],JUD[9]

TPL[1]='TGLVLK'
TPL[2]='NOTA'
TPL[3]='B->NAMA'
TPL[4]='MRK'
TPL[5]='PBR'
TPL[6]='QTT'
TPL[7]='HARGA'
TPL[8]='KET'
TPL[9]='MOBIL'

APICT[1]='@D'
APICT[2]='@B K 9999'
APICT[3]='@!'
APICT[4]='@!'
APICT[5]='@!'
APICT[6]='9,999'
APICT[7]='999,999'
APICT[8]='@!'
APICT[9]='@!'

JUD[1]='TGL MASUK'
JUD[2]='NOTA'
JUD[3]='NAMA BARANG'
JUD[4]='MEREK'
JUD[5]='PABRIK'
JUD[6]=' QTT'
JUD[7]=' HARGA '
JUD[8]=' KETERANGAN '
JUD[9]=' NAMA / NO MOBIL '

FOR I=0 TO 23
  SET COLOR TO W/N
  @I,0 SAY REPLI(CHR(178),79)
NEXT
SET COLOR TO W/B
@ 2,10 SAY '   DAFTAR DATA BARANG VULKANISIR   '
DO SBOX WITH 4,1,21,76,'GR+/B,W/R'
DBEDIT(5,2,20,75,TPL,'FUNGSI',APICT,JUD)
Return (nil)