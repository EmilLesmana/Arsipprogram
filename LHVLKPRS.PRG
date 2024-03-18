Memvar getlist
Field Nota,Kodbrg,Nama,Mobil,Hari,ket,harga,Mrk,pbr,qtt,tglabl,Muka,Nomor,;
      Tglvlk
Function Lhvlkprs()
LOCAL MCOLOR,I,MNO,MTGL,MMOBIL,MHARI,TGLSLS,HAL,BR,MTOT,MKODBRG,;
      MMRK,MPBR,MQTT,MHARGA,CIN:=1,ER,JUMLAH,JAWAB,JUDUL,msls,Tot,mPot,;
      Jum,mMuka,ul,mtglabl,ula
set color to
FOR I:=1 TO 80
    SCROLL(,,,,,-1)
NEXT

USE TRVLK NEW
USE STK INDEX ('STKX.ELX') NEW

SELE TRVLK
SET RELATION TO KODBRG INTO STK
BKVLK('PENGAMBILAN BARANG KANISIRAN')
* --------- TAMPILAN LAYAR ------------------- *

DO WHILE .T.
DBGOTOP()
MTGL:=CTOD(' - - ')
SET COLOR TO W/N,W/N
MCOLOR:=SETCOLOR()
MNO:=0
MMOBIL:=SPACE(20)
@3,10 SAY 'K'
@3,11 GET MNO PICT '@B 9999'
@5,16 get mMOBIL PICT '@!'
READ
IF MNO=0 .AND. MMOBIL=''
  CLOSE ALL
  Return (nil)
ENDIF
  IF MNO<>0
   DO WHILE MNO<>NOTA .AND. .NOT. EOF()
    SKIP
   ENDDO
   MMOBIL:=MOBIL
   IF MNO<>NOTA
      KOMENTAR(23,' DATA TIDAK DITEMUKAN,TEKAN SEMBARANG TOMBOL ...... ')
      @23,0
      LOOP
   ELSE
      EXIT
   ENDIF
  ELSE
     DO WHILE MMOBIL<>MOBIL .AND. .NOT. EOF()
       SKIP
     ENDDO
     MNO:=NOTA
   IF MMOBIL<>MOBIL
      KOMENTAR(23,' DATA TIDAK DITEMUKAN,TEKAN SEMBARANG TOMBOL ...... ')
      @23,0
      LOOP
   ELSE
      EXIT
   ENDIF
  ENDIF

ENDDO

@3,10 SAY 'K'
@3,11 SAY NOTA PICT '@B 9999'
@5,16 SAY MOBIL PICT '@!'
@4,10 SAY TGLVLK
@3,49 SAY HARI PICT '99'
TGLSLS:=TGLVLK+HARI
@4,57 SAY TGLSLS


HAL:=1
BR:=9
MTOT:=0

DO WHILE MNO=NOTA .AND. .NOT. EOF()
   SET COLOR TO W/N,W/N
   @BR,2 SAY TRAN(HAL,'99')
   @BR,COL()+1 SAY KODBRG
   @BR,COL()+1 SAY STK->NAMA
   @BR,COL()+1 SAY MRK
   @BR,COL()+1 SAY PBR
   @BR,45 SAY TRAN(QTT,'999')
   @BR,COL()+1 SAY TRAN(HARGA,'999,999')
   JUMLAH:=QTT*HARGA
   SETCOLOR('W/R')
   @BR,68 SAY KET
   SET COLOR TO
   IF KET<>'AFKIR '
   @BR,57 SAY TRAN(JUMLAH,'99,999,999')
     MTOT+=QTT*HARGA
   ENDIF
IF BR=17
   KOMENTAR(23,' GANTI HALAMAN BARU,TEKAN SEMBARANG TOMBOL ...... ')
   @9,0 CLEAR TO 23,70
   BKVLK('PENGAMBILAN BARANG KANISIRAN')
  BR:=8
ENDIF
   SET COLOR TO
   @23,0
   HAL++
   BR++
   SKIP
ENDDO

DBGOTOP()

SET COLOR TO W/N
@19,53 SAY MTOT PICT '99,999,999'

   DO WHILE MNO<>NOTA .AND. .NOT. EOF()
    SKIP
   ENDDO

MTGL:=TGLVLK
@20,53 SAY MUKA PICT '99,999,999'
@21,53 SAY MTOT-MUKA PICT '99,999,999'

SET COLOR TO GR,W/R
UL:=.N.
@20,1 SAY 'APAKAH DATA AKAN DI HAPUS [Y/N]'GET UL PICT 'Y'
READ

IF UL
MTGLABL=CTOD(' - - ')
@5,57 GET MTGLABL
READ
   DO WHILE MNO=NOTA .and. !eof()
    REPLACE TGLABL WITH MTGLABL
    SKIP
   ENDDO
 SET COLOR TO
 CLEAR
 SET COLOR TO GR,W/R
 ULA:=.Y.
 @1,1 SAY 'APAKAH DATA AKAN DI CETAK [Y/N]'GET ULA PICT 'Y'
 READ
  DBGOTOP()
  DO WHILE MNO<>NOTA .AND. .NOT. EOF()
    SKIP
  ENDDO
 IF ULA
    IF !CEKPRINT()
       CLOSE ALL
       Return (nil)
    ENDIF
    @PROW(),PCOL() SAY CHR(27)+'@'
judul=chr(76)+chr(65)+chr(74)+chr(85)+space(1)+chr(45)+space(1)+;
chr(74)+chr(65)+chr(89)+chr(65)
  @0,30 SAY judul
  ?? chr(15)
  @1,48 say 'Jl. MOH. TOHA 301 Tlp. (022)-504035     '
  @2,48 say 'Bandung FAX (022)-501941                '
  ?? chr(18)
  @3,1 SAY 'NO. NOTA :'
  @3,11 SAY 'K'
  @3,12 SAY MNO PICT '@B 9999'
  @3,40 SAY 'PROSES :['
  @3,49 say HARI pict '99'
  @3,51 say '] Hari'
  @4,1 SAY 'TANGGAL  :'
  SDATE(4,11,MTGL)
  MSLS=MTGL+HARI
  @4,40 SAY 'TANGGAL SELESAI :'
  @4,57 say MSLS
  @5,1 SAY 'NAMA/NO MOBIL :'
  @5,16 SAY MOBIL
  @5,40 SAY 'TANGGAL AMBIL   :'
  @5,57 SAY TGLABL

  BR:=9
  JUM:=0
  TOT:=0
  I:=11
  HAL:=1
@6,0 SAY REPLI('-',80)
@ 7,0 SAY '|NO| KODE BRG |   NAMA BARANG      |MRK|PBR|QTT| HARGA |    JUMLAH   |  KTRGN  |'
@ 8,0 SAY REPLI('-',80)
DO WHILE .NOT.EOF().AND.MNO=NOTA
@BR,0 SAY '|'+tran(HAL,'99')+'|'+KODBRG+'|'+STK->NAMA+'|'+MRK+'|'+PBR+'|'
@BR,PCOL() SAY TRAN(QTT,'999')+'|'+TRAN(HARGA,'999,999')+'|'
JUM:=QTT*HARGA
@BR,56 SAY 'Rp.'+TRAN(JUM,'99,999,999')+'|'+PADR(KET,9)+'|'
MMUKA=MUKA
I++
BR++
HAL++
TOT+=JUM
SKIP
ENDDO
@BR,0 SAY '|  |          |                    |   |   |   |       |'+;
          '-------------|         |'
BR++
@BR,0 SAY '|  |          |                    |   |   |   |       |'+'Rp.'+TRAN(TOT,'99,999,999')+;
          '|         |'
BR++
DO WHILE I<26
@BR,0 SAY '|  |          |                    |   |   |   |       |'+;
          '             |         |'
BR++
I++
ENDDO

@BR,0 SAY REPLI('-',80)
@BR+1,49 SAY 'JUMLAH Rp.'
@BR+1,59 SAY TOT PICT '99,999,999'
@BR+2,46 SAY 'UANG MUKA Rp.'
@BR+2,59 SAY MMUKA PICT '99,999,999'
@BR+3,49 SAY 'SISA   Rp.'
@BR+3,59 SAY TOT-MMUKA PICT '99,999,999'
@BR+4,0 SAY ''
@BR+5,0 SAY ''
@BR+6,0 SAY ''
@BR+7,0 SAY ''
?? CHR(18)
SETPRC(0,0)
SET PRINT OFF
SET DEVICE TO SCREEN
SET COLOR TO

DBGOTOP()
DO WHILE MNO<>NOTA .AND. .NOT. EOF()
   SKIP
ENDDO

DO WHILE MNO=NOTA .AND. .NOT. EOF()
   DELE
   SKIP
ENDDO

PACK
CLOSE ALL
CLEAR
Return (nil)

ELSE

DBGOTOP()
DO WHILE MNO<>NOTA .AND. .NOT. EOF()
   SKIP
ENDDO

DO WHILE MNO=NOTA .AND. .NOT. EOF()
   DELE
   SKIP
ENDDO

   PACK
   Return (nil)
ENDIF

ELSE
   SET COLOR TO
   CLEAR
   CLOSE ALL
   Return (nil)
ENDIF
Return (nil)