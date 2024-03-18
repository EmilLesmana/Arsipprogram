Memvar getlist
Field Tglin,Tglout,Nobpb,Faktur,Nama,Kodbrg,Kodelgn,kodpmsk,tglss,bukti,;
      qtt,tglht,tglpt,tglbyr,kode1,kode2,grp,tgl1
Function Ltotprs()
Local br,ul,i,cek,no,hal,er
* program LIHAT PABRIK
SETCOLOR('')
FOR I:=1 TO 25
    SCROLL(,,,,1)
NEXT
USE TRVLK NEW
USE REKAP INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW
USE STK INDEX ('STKX.ELX') NEW
SELE REKAP
DELE ALL
PACK

ER=.N.
 SET COLOR TO
 CLEAR
SET COLOR TO W*/R
@12,30 SAY ' TUNGGU PROSES ........ '
SELE TRVLK
DBGOTOP()
 DO WHILE .NOT. EOF()
     SELE REKAP
     SEEK TRVLK->KODBRG
     IF !FOUND()
        DBAPPEND()
       REPLACE KODE1 WITH TRVLK->KODBRG,QTT WITH QTT+TRVLK->QTT
     ELSE
       REPLACE QTT WITH QTT+TRVLK->QTT
     ENDIF
 SELE TRVLK
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
   IF !CEKPRINT()
      CLOSE ALL
      Return (nil)
   ENDIF
HAL:=1
   CLEAR
   SET COLOR TO
   SET COLOR TO GR+
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,5 SAY ' DAFTAR DATA BARANG VULKANISIR YANG DI PROSES '
@ 3,52 SAY DATE()
@4,0 SAY '--------------------------------   --------------------------------'
@5,0 SAY '| NO|    NAMA BARANG     | QTT |   | NO|    NAMA BARANG     | QTT |'
@6,0 SAY '--------------------------------   --------------------------------'
BR := 7
UL := 0
NO := 1
CEK:=1

 DO WHILE .NOT. EOF()
  IF CEK=1
    CEK++
    @ BR,0 SAY '|'
    @ BR,PCOL() SAY TRAN(NO,'999')+'|'+STK->NAMA+'|'+TRAN(QTT,'9,999')+'|'
   ELSE
    CEK--
    @ BR,35 SAY '|'
    @ BR,PCOL() SAY TRAN(NO,'999')+'|'+STK->NAMA+'|'+TRAN(QTT,'9,999')+'|'
    BR++
    UL++
    NO++
   ENDIF

IF UL>=49
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
      UL++
    ENDIF
@BR,0 SAY '--------------------------------   --------------------------------'
    @br+3,0 say ' '
    @br+4,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO
    CLEAR
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
       CLOSE ALL
       Return (nil)
    ENDIF
    HAL++
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,5 SAY ' DAFTAR DATA BARANG VULKANISIR YANG DI PROSES '
@ 3,52 SAY DATE()
@4,0 SAY '--------------------------------   --------------------------------'
@5,0 SAY '| NO|    NAMA BARANG     | QTT |   | NO|    NAMA BARANG     | QTT |'
@6,0 SAY '--------------------------------   --------------------------------'
    BR:=7
    UL:=0
ENDIF

SKIP
ENDD

SET COLOR TO W/N
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
      UL++
    ENDIF
SET COLOR TO GR
@BR,0 SAY '--------------------------------   --------------------------------'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO GR+/B
 @ 23,20 SAY '  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!'
 WAIT ''
    SET COLOR TO
    CLOSE ALL
    Return (nil)
ENDIF

DBGOTOP()
DECLARE TPL[2],APICT[2],JUD[2]
TPL[1]='STK->NAMA'
TPL[2]='QTT'

APICT[1]='@!'
APICT[2]='999,999'

JUD[1]=' NAMA BARANG '
JUD[2]=' QTT '

FOR I=0 TO 23
  SET COLOR TO W/N
  @I,0 SAY REPLI(CHR(178),79)
NEXT
SET COLOR TO W/B
@ 2,7 SAY ' DAFTAR DATA BARANG VULKANISIR YANG DI PROSES '
SET COLOR TO W/R
@ 2,52 SAY DATE()
DO SBOX WITH 4,6,21,71,'GR+/B,W/R'
DBEDIT(5,7,20,70,TPL,'FUNGSI',APICT,JUD)
Return (nil)