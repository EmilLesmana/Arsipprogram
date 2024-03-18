fUNCTION CTKFKT()
Local nPot,mnofak,mtgl
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
USE STK.dmt INDEX STKX.MLX NEW
USE LGN.dmt INDEX LGN.MLX NEW
USE put.dtr INDEX noput.elx NEW
USE TROUT.dtr INDEX TGLOUTX.ELX ALIAS KELUAR NEW


SET COLOR TO GR
@10,10 TO 13,62

DO WHILE .T.
SET COLOR TO GR+/B,W/R
MNOFAK:=0
MTGL=CTOD(' - - ')
@11,12 SAY ' MASUKAN FAKTUR YANG AKAN DICETAK : ' GET MNOFAK PICT '@B 99999'
@12,12 SAY ' MASUKAN TANGGAL FAKTUR           : ' GET MTGL PICT '@!'
READ
IF MNOFAK=0
  CLOSE ALL
  RETURN
ENDIF
SEEK MTGL
DO WHILE MNOFAK<>FAKTUR .AND. .NOT. EOF()
   SKIP
ENDDO
IF MNOFAK<>FAKTUR
  KOMENTAR(14,' DATA TIDAK DITEMUKAN, GANTI FAKTUR LAIN ..... ')
  @14,0
  LOOP
ELSE
  EXIT
ENDIF
ENDDO
sele put
set relation to kodelgn into lgn
dbseek(mnofak)
nPot:=Tunai
cNama:=lgn->nama
sele keluar
SET RELATION TO KODBRG INTO STK
IF !CEKPRINT()
   CLOSE ALL
   return
ENDIF

@0,32 say ' FAKTUR PENJUALAN '
@1,0 SAY 'LAJU JAYA, CV'
@1,39 SAY 'Pembeli      :'+padr(cnama,25)
@2,0 say 'JL.PLN Dalam 208/203 B, Bandung'
@2,39 say 'Alamat       :'+padr(lgn->Alamat,25)
@3,0 say 'NPWP/NPPKP     : 02.235.508.5.424.000'
@3,39 say 'NPWP/NPPKP   :'+PADR(Lgn->npwp,25)
@4,0 say 'Tgl Pengukuhan : 23 Juli 2003'
@4,39 say 'No.Invoice   :'+Tran(cFaktur,'@e 99999')
SDATE(5,0,MTGL)

BR:=9;JUM:=0;TOT:=0;MTOT:=0;I:=11
@6,0 SAY REPLI('-',79)
@7,0 SAY '| NO |KODE BARANG|       NAMA BARANG       |  QTT  |   HARGA   |   JUMLAH     |'
@8,0 SAY REPLI('-',79)
NO:=0
DO WHILE ! EOF() .AND. MNOFAK=FAKTUR
   NO++
   @BR,0 SAY '|'+TRAN(NO,'@B 9999')+'|'
   @br,6 say PADR(KODBRG,11)+'|'
   @br,19 say (IF(KODBRG#'003       ',PADR(STK->NAMA,24),PADR(MOBIL,24)))+'|'
   @br,45 say TRAN(QTT,'@E 99,999')+'|'
   @BR,53 SAY HARGA PICT '@E 99,999,999'+'|'
   TOT:=QTT*HARGA
   @BR,65 SAY TOT PICT '@E 9,999,999,999'+'|'
   MTOT+=TOT
   I++
   BR++
   SKIP
ENDDO

@BR,0 SAY '|'
@BR,5 SAY '|'
@BR,17 SAY '|'
@BR,43 SAY '|'
@BR,51 SAY '|'
@BR,63 SAY '|'
@BR,64 SAY REPLI('-',14)
@BR,78 SAY '|'

BR++
@BR,0 SAY '|'
@BR,5 SAY '|'
@BR,17 SAY '|'
@BR,43 SAY '|'
@BR,51 SAY '|'
@BR,63 SAY '|'
@BR,64 SAY 'Rp'
@BR,67 SAY MTOT PICT '@E 999,999,999'
@BR,78 SAY '|'

BR++
DO WHILE I<26
   @BR,0 SAY '|'
   @BR,5 SAY '|'
   @BR,17 SAY '|'
   @BR,43 SAY '|'
   @BR,51 SAY '|'
   @BR,63 SAY '|'
   @BR,78 SAY '|'
   BR++
   I++
ENDDO

@BR,0 SAY REPLI('-',79)
@BR+1,3 SAY ' Tanda - Terima    Barang yang sudah dibeli '
@BR+1,53 SAY 'JUMLAH     Rp.'
@BR+1,67 SAY MTOT PICT '@E 999,999,999'
@BR+2,3 SAY '                   tidak dpt dikembalikan '
@BR+2,53 SAY 'P P N  10% '
@BR+2,67 SAY mtot*0.1 PICT '@E 999,999,999'
@br+3,3 say '                   Jatuh Tempo: ..........'
@BR+3,53 SAY 'TOTAL      Rp.'
@BR+3,67 SAY MTOT+(mtot*0.1) PICT '@E 999,999,999'
@br+4,0 say ''
@BR+5,0 SAY ''
@BR+6,0 SAY ''
@BR+7,0 SAY ''
SETPRC(0,0)
SET PRINT OFF
SET DEVICE TO SCREEN
SET COLOR TO
CLOSE ALL
RETURN
