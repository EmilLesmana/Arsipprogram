fUNCTION pajaks()
Local I,TGLAWAL,TGLAKHIR,ER,BR,TOT,MJUM,no,cseri,cinvoice,ckodlgn,;
      cNamaL,cAlamat1,cAlamat2,cAlamat3,cNpwpL,cseri1,cSeri2
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
BUKA2()
USE REKAP.TMP INDEX ('KODE1.TMP'),('KODE2.TMP'),('TGL1.TMP') NEW
DELETE ALL
PACK

cSeri:=space(25)
cInvoice:=space(10)
cKodlgn:=space(3)
cNamaL:=space(40)
cAlamat1:=space(40)
cAlamat2:=space(40)
cAlamat3:=space(40)
cNpwpL:=space(40)
cSeri1:='010.'
cSeri2:=space(15)


ER:=.N.
SET COLOR TO
CLEAR
SET COLOR TO GR,W/N
@5,10 SAY ' FAKTUR PAJAK STANDAR '
@6,10 SAY '----------------------'

SELE TROUT
SET ORDER TO 2
TGLAWAL:=CTOD(' // ')
TGLAKHIR:=CTOD(' // ')

@7,7 SAY ' TANGGAL : 'GET TGLAWAL
@7,28 SAY '  SAMPAI'
@7,38 SAY '  TANGGAL :'GET TGLAKHIR
READ

IF TGLAKHIR=CTOD(' // ')
   TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @7,51 SAY TGLAKHIR
   SET COLOR TO GR+/B
ENDIF

IF !CARITGL(TGLAWAL)
   KOMENTAR(15,'   DATA TIDAK DITEMUKAN   ')
   CLOSE ALL
   RETURN (NIL)
ENDIF

@9,1 say 'Kode Seri Faktur Pajak : '+cSeri1 get cSeri2 pict'@!'
@10,1 say ' Nomor Invoice         :' get cInvoice pict'@!'
@11,1 say ' Kode Langganan        :' get cKodlgn pict'@!'
read
cSeri:=cSeri1+cSeri2

sele lgn
seek ckodlgn
if Found()

cKodlgn:=Kodelgn
cNamaL:=Nama
cAlamat1:=Alamat
cAlamat2:=Alamat2
cAlamat3:=Alamat3
cNpwpL:=Npwp


endif



SELE TROUT
set relation to faktur into put
SET COLOR TO W*/R
@12,30 SAY '   TUNGGU PROSES ........... '
DO WHILE TGLOUT<=TGLAKHIR .AND. .NOT. EOF()
   SELE REKAP
   SEEK TROUT->KODBRG
   If cKodlgn==space(3)
      if ckodlgn<>put->kodelgn
      IF !FOUND()
         DBAPPEND()
         REPLACE QTT WITH TROUT->QTT,HARGA WITH TROUT->QTT*TROUT->HARGA,;
         KODE1 WITH TROUT->KODBRG
      ELSE
         REPLACE QTT WITH QTT+TROUT->QTT,HARGA WITH HARGA+(TROUT->QTT*TROUT->HARGA)
      ENDIF
      endif
   else
      if ckodlgn==put->kodelgn
      IF !FOUND()
         DBAPPEND()
         REPLACE QTT WITH TROUT->QTT,HARGA WITH TROUT->QTT*TROUT->HARGA,;
         KODE1 WITH TROUT->KODBRG
      ELSE
         REPLACE QTT WITH QTT+TROUT->QTT,HARGA WITH HARGA+(TROUT->QTT*TROUT->HARGA)
      ENDIF
      endif
   endif
   SELE TROUT
   SKIP
ENDDO

SELE REKAP
DBGOTOP()
SET RELATION TO KODE1 INTO STK

SET COLOR TO
CLEAR
SET COLOR TO W+/R+
@1,1 SAY ' APAKAH DATA AKAN DICETAK ?(Y/N) ' GET ER PICT 'Y'
SET COLOR TO
READ

IF ER
   IF !CEKPRINT()
      CLOSE ALL
      RETURN (NIL)
   ENDIF




//LGJDLGB(0,1)
@0,30 say 'F A K T U R  P A J A K'
@1,0 say '|'
@1,1 SAY REPLI('-',65)
@1,66 say '|'
@2,0 say '|'
@2,1 SAY 'Kode dan Nomor Seri Faktur Pajak :'+padr(cSeri,25)
@2,66 say '|'
@3,0 say '|'
@3,1 SAY REPLI('-',65)
@3,66 say '|'
@4,0 say '|'
@4,1 say 'Pengusaha Kena Pajak'
//@4,1 say '                                             No. Invoice :'+padr(cinvoice,10)
@4,66 say '|'
@5,0 say '|'
@5,1 say 'Nama                    : LAJU JAYA, CV '
@5,66 say '|'
@6,0 say '|'
@6,1 say 'Alamat                  : Jl. PLN Dalam 208/203 B, Mohamad Toha '
@6,66 say '|'
@7,0 say '|'
@7,1 say 'NPWP / NPPKP            : 02.235.508.5.424.000'
@7,66 say '|'
//@8,1 say 'Tanggal Pengukuhan PKP  : 23 Juli 2003 '
//SDATE(2,1,MTGL)
@8,0 say '|'
@8,1 SAY REPLI('-',65)
@8,66 say '|'
@9,0 say '|'
@9,1 say 'Pembeli Barang Kena Pajak / Penerima Jasa Kena Pajak'
@9,66 say '|'
@10,0 say '|'
@10,1 SAY REPLI('-',65)
@10,66 say '|'
@11,0 say '|'
@11,1 SAY 'Nama                    :'+padr(cNamaL,40)
@11,66 say '|'
@12,0 say '|'
@12,1 SAY 'Alamat                  :'+PADR(cAlamat1,40)
@12,66 say '|'
//@13,26 say PADR(cAlamat2,40)
//@14,26 say PADR(cAlamat3,40)
@13,0 say '|'
@13,1 SAY 'NPWP / NPPKP            :'+padr(cnpwpL,40)
@13,66 say '|'

BR:=17;JUM:=0;TOT:=0;MTOT:=0;I:=11
@14,0 say '|'
@14,1 SAY REPLI('-',65)
@14,66 say '|'
@15,0 SAY '| NO |   NAMA BARANG          |   QTT  | H.SATUAN |    JUMLAH     |'
@16,0 say '|'
@16,1 SAY REPLI('-',65)
@16,66 say '|'
NO:=0
DO WHILE ! EOF()
   NO++
   @BR,0 SAY '|'+TRAN(NO,'@B 9999')
   @BR,5 SAY '|'
   @BR,7 SAY PADR(STK->NAMA,22)
   @BR,30 SAY '|'+TRAN(QTT,'@E 999,999')
   @BR,39 SAY '|'
   @BR,40 SAY TRAN(harga/QTT,'@E 99,999,999')
   @BR,50 SAY '|'
   @BR,51 SAY HARGA PICT '@E 999,999,999,999'
   @BR,66 SAY '|'
   MTOT+=HARGA
   I++
   BR++
   SKIP
ENDDO

DO WHILE I<40
@BR,0 SAY '|'
@BR,5 SAY '|'
@BR,30 SAY '|'
@BR,39 SAY '|'
@BR,50 SAY '|'
@BR,66 SAY '|'
BR++
I++
SKIP
ENDDO

@BR,0 SAY REPLI('-',65)   
@BR,66 SAY '|'
@BR+1,0 SAY '| Harga Jual / Penggantian'
@br+1,50 say '|'
@BR+1,51 SAY mTOT PICT '@E 999,999,999,999'+'|'
@br+2,0 SAY REPLI('-',65)
@br+2,66 SAY '|'
@br+3,0 say '| Dikurangi Potongan Harga '
@br+3,50 say '|'
@br+3,66 say '|'
@br+4,0 SAY REPLI('-',65)
@br+4,66 SAY '|'
@br+5,0 say '| Dikurangi Uang Muka '
@br+5,50 say '|'
@br+5,66 say '|'
@br+6,0 SAY REPLI('-',65)
@br+6,66 SAY '|'
@br+7,0 say '| Dasar pengenaan Pajak '
@br+7,50 say '|'
@BR+7,51 SAY tran(mTOT,'@E 999,999,999,999')
@br+7,66 say '|'
@br+8,0 SAY REPLI('-',65)
@br+8,66 SAY '|'
@br+9,0 say '| PPN = 10% X Dasar Pengenaan Pajak '
@br+9,50 say '|'
@BR+9,51 SAY tran(0.1*mtot,'@E 999,999,999,999')
@br+9,66 say '|'
@br+10,0 SAY REPLI('-',65)
@br+10,66 SAY '|'
@br+11,0 say '| Total PPnBM (Pajak Penjualan Barang Mewah)'
@br+11,50 say '|'
@BR+11,51 SAY tran(mtot+(0.1*mTOT),'@E 999,999,999,999')
@br+11,66 say '|'
@br+12,0 SAY REPLI('-',65)
@br+12,66 SAY '|'
@BR+13,33 SAY 'Bandung, Tanggal : '+Dtoc(tglawal)
@BR+17,33 SAY 'NAMA  : FARINA SUZANA'
@BR+18,0 SAY ''
@BR+19,0 SAY ''
@BR+20,0 SAY ' '
SETPRC(0,0)
SET PRINT OFF
SET DEVICE TO SCREEN
else
/*
   @0,30 say 'F A K T U R  P A J A K'
@1,1 SAY 'Kode dan Nomor Seri Faktur Pajak :'+padr(cSeri,25)
@3,1 say 'Pengusaha Kena Pajak'
@4,1 say 'Nama                    : LAJU JAYA, CV      No. Invoice :'+padr(cinvoice,10)
@5,1 say 'Alamat                  : Jl. PLN Dalam 208/203 B, Mohamad Toha '
@6,1 say 'NPWP / NPPKP            : 02.235.508.5.424.000'
@7,1 say 'Tanggal Pengukuhan PKP  : 23 Juli 2003 '
//SDATE(2,1,MTGL)
@9,1 say 'Pembeli Barang Kena Pajak / Penerima Jasa Kena Pajak'
@10,1 SAY 'Nama                    :'+padr(cNamaL,40)
@11,1 SAY 'Alamat                  :'+PADR(cAlamat1,40)
@12,26 say PADR(cAlamat2,40)
@13,26 say PADR(cAlamat3,40)
@14,1 SAY 'NPWP / NPPKP            :'+padr(cnpwpL,40)

@BR+1,0 SAY '| Harga Jual '
@br+1,63 say '|'
@BR+1,64 SAY mTOT PICT '@E 999,999,999,999'+'|'
@br+2,0 SAY REPLI('-',79)
@br+3,0 say '| Dikurangi Potongan Harga '
@br+3,63 say '|'
@br+3,79 say '|'
@br+4,0 SAY REPLI('-',79)
@br+5,0 say '| Dikurangi Uang Muka yang telah diterima '
@br+5,63 say '|'
@br+5,79 say '|'
@br+6,0 SAY REPLI('-',79)
@br+7,0 say '| Dasar pengenaan Pajak '
@br+7,63 say '|'
@BR+7,64 SAY tran(mTOT*(100/110),'@E 999,999,999,999')
@br+7,79 say '|'
@br+8,0 SAY REPLI('-',79)
@br+9,0 say '| PPN = 10% X Dasar Pengenaan Pajak '
@br+9,63 say '|'
@BR+9,64 SAY tran(mtot-(mTOT*(100/110)),'@E 999,999,999,999')
@br+9,79 say '|'
@br+10,0 SAY REPLI('-',79)

@BR+11,33 SAY '..................,Tanggal .................'
*/
endif

SET COLOR TO
CLOSE ALL
RETURN
