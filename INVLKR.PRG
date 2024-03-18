Memvar getlist
Field Nota,Kodbrg,Nama,Mobil,Hari,ket,harga,Mrk,pbr,qtt,tglabl,Muka,Nomor,;
      Tglvlk
Function Invlkr()
LOCAL MCOLOR,I,MNO,MTGL,MMOBIL,MHARI,TGLSLS,HAL,BR,MTOT,MKODBRG,;
      MMRK,MPBR,MQTT,MHARGA,CIN:=1,ER,JUMLAH,JAWAB,JUDUL,msls,Tot,mPot,;
      Jum,mMuka,erna,Pil,mKet
set color to
for i:=1 to 25
    scroll(,,,,-1)
next

USE TRVLK  new
use stk index ('stkx.elx') NEW

bkvlk('PENGAMBILAN BARANG KANISIRAN')
* --------- TAMPILAN LAYAR ------------------- *

sele trvlk
set relation to kodbrg into stk

DO WHILE .T.
DBGOTOP()
MTGL:=CTOD(' - - ')
SET COLOR TO W/N,W/N
MNO:=0
MMOBIL:=SPACE(20)
@3,10 SAY 'K'
@3,11 GET MNO PICT '@B 9999'
@5,16 get mMOBIL PICT '@!'
READ
IF MNO==0 .AND. MMOBIL==''
  CLOSE ALL
  Return (nil)
ENDIF
  IF MNO<>0
   DO WHILE MNO<>NOTA .AND. .NOT. EOF()
    SKIP
   ENDDO
   MMOBIL=MOBIL
   IF MNO<>NOTA
         SET COLOR TO W/B
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
@5,57 SAY TGLABL


HAL :=1
BR  :=9
MTOT:=0

DO WHILE .NOT. EOF() .AND. MNO=NOTA
   SET COLOR TO W/N,W/N
   @BR,2 SAY HAL PICT '99'
   @BR,5 SAY KODBRG PICT '@!'
   @BR,16 SAY STK->NAMA
   @BR,37 SAY MRK
   @BR,41 SAY PBR
   @BR,45 SAY QTT PICT '999'
   @BR,49 SAY HARGA PICT '999,999'
   JUMLAH:=QTT*HARGA
   @BR,57 SAY JUMLAH PICT '99,999,999'
   SET COLOR TO W+/R,GR+*/BG
   @BR,68 SAY KET

   SAVE SCREEN TO ERNA
   @19,1 SAY ' 1. PROSES '
   @19,13 SAY ' 2. JADI  '
   @19,24 SAY ' 3. AFKIR '
   PIL=2
   SET COLOR TO GR
   @20,1 SAY ' TEKAN 1,2 ATAU 3 'GET PIL PICT '9' RANGE 1,3
   READ
   DO CASE
     CASE PIL=1
       MKET:='PROSES'
     CASE PIL=2
       MKET:='JADI  '
     CASE PIL=3
       MKET:='AFKIR '
   ENDCASE
   RESTORE SCREEN FROM ERNA
   SET COLOR TO W/N
   @BR,68 SAY MKET
   REPLACE KET WITH MKET
   IF MKET<>'AFKIR '
     MTOT+=QTT*HARGA
   ENDIF
   IF BR=17
      KOMENTAR(23,' GANTI HALAMAN BARU,TEKAN SEMBARANG TOMBOL ...... ')
      @9,0 CLEAR TO 23,63
      BR:=8
   ENDIF
   SET COLOR TO
   @23,0
   HAL++
   BR++
   SKIP
ENDDO

DBGOTOP()

SET COLOR TO W/N,W*/N
@19,57 SAY MTOT PICT '99,999,999'
DO WHILE MNO<>NOTA
   SKIP
ENDDO

@20,57 SAY MUKA PICT '99,999,999'
@21,57 SAY MTOT-MUKA PICT '99,999,999'

KOMENTAR(23,' TEKAN SEMBARANG TOMBOL KEMBALI KE MENU..............')
CLOSE ALL
Return (nil)
