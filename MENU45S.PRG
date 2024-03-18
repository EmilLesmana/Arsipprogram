Function Menu45s()
* Program Menu45s.prg
# include "inkey.ch"
local nTot1:=nTot2:=nTot3:=nTot4:=nTot5:=nTot6:=0
local nBlAwal:=nBl:=nSSinAwal:=nSSin:=nSSotawal:=nSSot:=nOtAwal:=nOt:=0
local nStkawal:=nStkakhir:=0
local MScreen:=savescreen(), MColor:=setcolor()
local mjudul:="LAPORAN STOK MUTASI BARANG"

Sbox(10,15,17,65,"w+/r")
@11,17      say "PERHATIAN!!!"
@row()+1,17 say "Data barang jangan dirubah MANUAL!!!"
@row()+1,17 say "Program di workstation lain harus dihentikan!"
@row()+1,17 say "Proses ini akan sangat lama."
@row()+1,17 say "Tekan ENTER untuk melanjutkan atau"
@row()+1,17 say "Tekan sebarang tombol untuk membatalkan!"
tone(700,10)
inkey(0)
if ! lastkey()=K_ENTER
   restscreen(,,,,MScreen)
   setcolor(MColor)
   return
endif

sbox(10,20,15,60,"w+/b,n/bg")
@ 11,39-len(mjudul)/2 say mjudul
@ 12,21 say repl(chr(196),39)
DTglawal:=ctod("")
dTglakhir:=Date()
setcursor(1)
@row()+1,22  say "MULAI Tanggal :" get dTglawal
@row(),Col()+1 say 'Sampai Tanggal :'+dtoc(dTglakhir)
read

setcursor(0)
restscreen(,,,,MScreen)
setcolor(Mcolor)
if lastkey()=K_ESC
    return
endif
SBox(10,20,12,60,"w*+/r")
@11,27 say "Tunggu..., sedang Menghitung!"
dbcloseAll()
BukaHS()
sele trss
index on kodbrg to semtrss
set index to semtrss
sele trout
index on kodbrg to semtrout
set index to semtrout
sele Rekap
zap

select Trstk
Set order to 2
If !Caritgl(dTglawal)
   dbcloseall()
   @row()+3,15 say ' Data tidak ditemukan...... '
   inkey(2)
   Return nil
Endif
index on kodbrg to semstk
set index to semstk
set relation to Kodbrg into stk
dbgotop()
do while ! eof()
nBlAwal:=nBl:=nSSinAwal:=nSSin:=nSSotawal:=nSSot:=nOtAwal:=nOt:=0
nStkawal:=nStkakhir:=0
   MKdBr:=KodBrg
   cNama:=stk->Nama
   do while KodBrg=MKdBr .and. ! eof()
      IF tglin<dtglawal
         nBlawal+=Qtt
      elseif Tglin<=dTglakhir
         nBl+=Qtt
      Endif
      dbskip()
   enddo

   select Trss
   dbseek(mkdbr)
   do while KodBrg=MKdBr .and. ! eof()
      IF tglss<dtglawal .and. Status=='INSTK'
         nSSinawal+=Qtt
      elseif Tglss<=dTglakhir .And. Status=='INSTK'
         nSSin+=Qtt
      elseif Tglss<dTglawal .And. Status=='OTSTK'
         nSSotawal+=Qtt
      elseif Tglss<=dTglakhir .And. Status=='OTSTK'
         nSSot+=Qtt
      Endif
      dbskip()
   enddo


   select Trout
   dbseek(MKdBr)
   do while KodBrg=MKdBr .and. ! eof()
      IF tglout<dtglawal
         nOtawal+=Qtt
      elseif Tglout<=dTglakhir
         nOt+=Qtt
      Endif
      dbskip()
   enddo

   nStkAwal:=nBlawal+nSSInawal-nOtawal-nSSotawal
   nStkakhir:=nStkawal+nBl+nSSin-nOt-nSSot

   select Rekap
   dbappend()
   repl Kode1 with MKdBr,;
        Catat with cnama,;
        qtt  with nStkawal,;
        harga  with nBl,;
        Harga1 with nSSin,;
        Harga2  with nSSot,;
        harga3  with nOt,;
        Harga4 with nStkakhir

   select Trstk
enddo
sele Rekap

GO TOP

SET COLOR TO
CLEAR

ER:=.N.
SET COLOR TO W/R,N*/G
@1,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ

DECLARE TPL[8],APICT[8],AJUD[8]
  IF .NOT. ER
    TPL[1] = 'kode1'
    TPL[2] = 'CATAT'
    TPL[3] = 'QTT'
    TPL[4] = 'HARGA'
    TPL[5] = 'HARGA1'
    TPL[6] = 'HARGA2'
    TPL[7] = 'HARGA3'
    TPL[8] = 'HARGA4'

    APICT[1]='@!'
    APICT[2]='@!'
    APICT[3]='@E 999,999'
    APICT[4]='@E 999,999'
    APICT[5]='@E 999,999'
    APICT[6]='@E 999,999'
    APICT[7]='@E 999,999'
    APICT[8]='@E 9,999,999'

    AJUD[1]=' Kode Brg '
    AJUD[2]='Nama Barang'
    AJUD[3]='Stok Awal'
    AJUD[4]='Pembelian'
    AJUD[5]='Masuk'
    AJUD[6]='Keluar'
    AJUD[7]='Penjualan'
    AJUD[8]='Stok Akhir'

    SET COLOR TO W/N
    @0,0,24,80 BOX REPLI(CHR(178),9)
    SET COLOR TO GR+/B
    @2,22 SAY mjudul
    @3,20 SAY ' PERIODE :'
    SET COLOR TO W/R
    @3,COL()+2 SAY dTGLAWAL
    SET COLOR TO GR+/B
    @3,COL()+2 SAY '-'
    SET COLOR TO W/R
    @3,COL()+2 SAY dTGLAKHIR
    SBOX(6,4,21,76,'GR+/B,W/R')
    TABEL:=TBROWSEDB(7,5,20,75)
  DISPEND()
  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  Tabel:Addcolumn(tbcolumnnew(ajud[1],{||tran(&(tpl[1]),apict[1])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[2],{||tran(&(tpl[2]),apict[2])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[3],{||tran(&(tpl[3]),apict[3])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[4],{||tran(&(tpl[4]),apict[4])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[5],{||tran(&(tpl[5]),apict[5])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[6],{||tran(&(tpl[6]),apict[6])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[7],{||tran(&(tpl[7]),apict[7])}))
  Tabel:Addcolumn(tbcolumnnew(ajud[8],{||tran(&(tpl[8]),apict[8])}))
  TABEL:HEADSEP:='мям'
  TABEL:COLSEP:= ' Ё '
  tabel:footsep:='мом'
  tabel:freeze:=1
  While .t.
     While !Tabel:Stabilize()
     enddo
      mbrs:=row();mcol:=col()
      x:={||waktu()};x:=eval(x)
      @mbrs,mcol say ''
     if x==27
        SET CURSOR ON
        exit
     endif
     key(x,tabel)
  enddo
ELSE
      IF !CEKPRINT()
         dbcommitall()
         dbcloseall()
         Return (nil)
      ENDIF
       ?? chr(15)
       @2,22 SAY mJudul
       @3,20 SAY ' PERIODE :'
       @3,31 SAY dTGLAWAL
       @3,40 SAY '-'
       @3,43 SAY dTGLAKHIR
@4,1 SAY '----------------------------------------------------------------------------------------'
@5,1 SAY '|kod barang|       Nama Barang       |S.Awal | Beli  | Masuk |Keluar | Jual  | S.AKHIR|'
@6,1 SAY '----------------------------------------------------------------------------------------'
   BR:=7
DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+kode1+'|'+CATAT+'|'+TRAN(Qtt,'@E 999,999')+'|'+TRAN(Harga,'@E 999,999')+'|'+;
             TRAN(Harga1,'@E 999,999')+'|'+ TRAN(Harga2,'@E 999,999')+'|'
   @BR,PCOL() SAY TRAN(HARGA3,'@E 999,999')+'|'+TRAN(HARGA4,'@E 9999,999')+'|'
   IF BR=60
@Br+1,1 SAY '----------------------------------------------------------------------------------------'
      @BR+2,1 SAY ''
      ?? chr(18)
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      SET COLOR TO W*/R
      KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
      @1,0
      IF !CEKPRINT()
         dbcommitall()
         dbcloseall()
         Return (nil)
      ENDIF
      ?? chr(15)
       @2,22 SAY mjudul
       @3,20 SAY ' PERIODE :'
       @3,31 SAY dTGLAWAL
       @3,40 SAY '-'
       @3,43 SAY dTGLAKHIR
@4,1 SAY '----------------------------------------------------------------------------------------'
@5,1 SAY '|kod barang|       Nama Barang       |S.Awal | Beli  | Masuk |Keluar | Jual  | S.AKHIR|'
@6,1 SAY '----------------------------------------------------------------------------------------'
      BR:=7
   ENDIF
        BR++
        SKIP
    ENDDO
@Br,1 SAY '----------------------------------------------------------------------------------------'
        @BR+1,1 SAY ''
        ?? chr(18)
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        dbcommitall()
        dbcloseall()
        Return (nil)
ENDIF
tone(700,20)
ER:=.N.
SET COLOR TO W/R,N*/G
@1,1 SAY ' APAKAH DATA STOK AKAN DI RUBAH [Y/N]? ' GET ER PICT 'Y'
READ
If Er
   Sele Rekap
   Dbgotop()
   While !Eof()
     Sele Stk
     Dbseek(Rekap->Kode1)
     If Found()
        Replace Qtt with Rekap->Harga4
     Endif
     Sele Rekap
     dbskip()
   Enddo
Endif
dbcloseAll()
restscreen(,,,,MScreen)
setcolor(MColor)
return Nil
