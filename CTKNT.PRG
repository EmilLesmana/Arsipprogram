Memvar getlist
Field Tglvlk,nota,Nama,Kodbrg,Kodelgn,tglabl,mukA,;
      mobil,qtt,harga,hari,mrk,pbr,ket
Function Ctknt()
Local mno,br,i,jum,msls,hal,TOT,MMUKA,judul
SET COLOR TO
CLEAR
USE TRVLK NEW
USE STK INDEX STKX.ELX new
SELE TRVLK
SET RELATION TO KODBRG INTO STK
SET COLOR TO GR
@10,10 TO 12,70

DO WHILE .T.
SET COLOR TO GR+/B,GR/N
MNO:=0
@11,12 SAY ' MASUKAN NOTA YANG AKAN DICETAK : '
SET COLOR TO GR,GR
@ 11,47 SAY 'K'
@ 11,48 GET MNO PICT '@B 9999'
READ
IF MNO=0
  CLOSE ALL
  Return (nil)
ENDIF
 DO WHILE MNO<>NOTA .AND. .NOT. EOF()
  SKIP
 ENDDO
 IF MNO<>NOTA
   SET COLOR TO W/R
  @15,11 SAY ' DATA TIDAK DITEMUKAN, GANTI NOTA LAIN ..... '
  SET COLOR TO
  WAIT ''
  @15,11 CLEAR
  LOOP
 ELSE
  EXIT
 ENDIF
ENDDO
IF !CEKPRINT()
   CLOSE ALL
   Return (nil)
ENDIF

@PROW(),PCOL() SAY CHR(27)+'@'
judul:=chr(76)+chr(65)+chr(74)+chr(85)+space(1)+chr(45)+space(1)+;
chr(74)+chr(65)+chr(89)+chr(65)
  @0,30 SAY judul
  ?? chr(15)
  @1,48 say 'Jl. MOH. TOHA 301 Tlp. (022)-5204035     '
  @2,48 say 'Bandung FAX (022)-5201941                '
  ?? chr(18)
  @3,1 SAY 'NO. NOTA :'
  @3,11 SAY 'K'
  @3,12 SAY MNO PICT '@B 9999'
  @3,40 SAY 'PROSES :['
  @3,49 say HARI pict '99'
  @3,51 say '] Hari'
  @4,1 SAY 'TANGGAL  :'
  SDATE(4,11,TGLVLK)
  MSLS:=TGLVLK+HARI
  @4,40 SAY 'TANGGAL SELESAI :'
  @4,57 say MSLS
  @5,1 SAY 'NAMA/NO MOBIL :'
  @5,16 SAY MOBIL
  @5,40 SAY 'TANGGAL AMBIL   :'
  @5,57 SAY TGLABL

  BR:=9;JUM:=0;TOT:=0;I:=11;HAL:=1
@6,0 SAY REPLI('-',80)
@7,0 SAY '|NO| KODE BRG |   NAMA BARANG      |MRK|PBR|QTT| HARGA |    JUMLAH   |  KTRGN  |'
@8,0 SAY REPLI('-',80)
DO WHILE .NOT.EOF().AND.MNO=NOTA
@BR,0 SAY '|'
@BR,1 SAY HAL PICT '99'
@BR,3 SAY '|'
@BR,4 SAY KODBRG
@BR,14 SAY '|'
@BR,15 SAY STK->NAMA
@BR,35 SAY '|'
@BR,36 SAY MRK
@BR,39 SAY '|'
@BR,40 SAY PBR
@BR,43 SAY '|'
@BR,44 SAY QTT PICT '999'
@BR,47 SAY '|'
@BR,48 SAY HARGA PICT '999,999'
@BR,55 SAY '|'
JUM+=QTT*HARGA
@BR,56 SAY 'Rp.'
@BR,59 SAY JUM PICT '99,999,999'
@BR,69 SAY '|'
@BR,72 SAY KET
@BR,79 SAY '|'
MMUKA:=MUKA
I++
BR++
HAL++
TOT+=JUM
SKIP
ENDDO
@BR,0 SAY '|'
@BR,3 SAY '|'
@BR,14 SAY '|'
@BR,35 SAY '|'
@BR,39 SAY '|'
@BR,43 SAY '|'
@BR,47 SAY '|'
@BR,55 SAY '|'
@BR,56 SAY REPL('-',13)
@BR,69 SAY '|'
@BR,79 SAY '|'
BR=BR+1
@BR,0 SAY '|'
@BR,3 SAY '|'
@BR,14 SAY '|'
@BR,35 SAY '|'
@BR,39 SAY '|'
@BR,43 SAY '|'
@BR,47 SAY '|'
@BR,55 SAY '|'
@BR,56 SAY 'Rp.'
@BR,59 SAY TOT PICT '99,999,999'
@BR,69 SAY '|'
@BR,79 SAY '|'

BR++
DO WHILE I<26
@BR,0 SAY '|'
@BR,3 SAY '|'
@BR,14 SAY '|'
@BR,35 SAY '|'
@BR,39 SAY '|'
@BR,43 SAY '|'
@BR,47 SAY '|'
@BR,55 SAY '|'
@BR,69 SAY '|'
@BR,79 SAY '|'
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
CLOSE ALL
CLEAR
Return (nil)