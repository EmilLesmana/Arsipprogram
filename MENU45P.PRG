Function Menu45P()
* Program Menu45P.prg
# include "inkey.ch"
local nTot1:=nTot2:=nTot3:=nTot4:=nTot5:=nTot6:=0
local nBlAwal:=nBl:=nSSinAwal:=nSSin:=nSSotawal:=nSSot:=nOtAwal:=nOt:=0
local nStkawal:=nStkakhir:=0
local MScreen:=savescreen(), MColor:=setcolor()
local mjudul:="LAPORAN HUTANG LANGGANAN"

Sbox(10,15,17,65,"w+/r")
@11,17      say "PERHATIAN!!!"
@row()+1,17 say "Data Piutang jangan dirubah MANUAL!!!"
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
BukaHU()
sele Rekap
set order to 2
zap

select Put
Set order to 2
If !CariTgl(dTglawal)
   dbcloseall()
   @row()+3,15 say ' Data tidak ditemukan...... '
   inkey(2)
   Return nil
Endif
index on kodelgn to semput
set index to semput
set relation to KodeLgn into Lgn
dbgotop()
do while ! eof()
   MKdBr:=Kodelgn
   cNama:=Lgn->Nama
   nBlawal:=nBl:=0
   dbeval({||nBlawal+=JMLPT,nBl+=Tunai+giro},,{||Kodelgn==MKdBr .and. Tglout<dTglawal},,,.F.)
   dbseek(mkdbr)
   nSSin:=nSSot:=0
   dbeval({||nSSin+=JMLPT,nSSot+=Tunai+giro},,{||Kodelgn==MKdBr .and. Tglout<dTglakhir},,,.F.)
   do while Kodelgn==MKdBr .and. ! eof()
      dbskip()
   enddo

   nStkakhir:=nBlawal+nSSin-nSSot-nBl

   select Rekap
   dbappend()
   repl Kode2 with MKdBr,;
        Catat with cnama,;
        qtt  with nBlawal,;
        harga  with nBl,;
        Harga1 with nSSin,;
        Harga2  with nSSot,;
        Harga3 with nStkakhir

   select Put
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
    TPL[1] = 'kode2'
    TPL[2] = 'CATAT'
    TPL[3] = 'QTT'
    TPL[4] = 'HARGA'
    TPL[5] = 'HARGA1'
    TPL[6] = 'HARGA2'
    TPL[7] = 'HARGA3'

    APICT[1]='@!'
    APICT[2]='@!'
    APICT[3]='@E 99,999,999,999'
    APICT[4]='@E 99,999,999,999'
    APICT[5]='@E 99,999,999,999'
    APICT[6]='@E 99,999,999,999'
    APICT[7]='@E 99,999,999,999'

    AJUD[1]=' Kode'
    AJUD[2]='Pemasok'
    AJUD[3]='H Awal'
    AJUD[4]='B Awal'
    AJUD[5]='H Baru'
    AJUD[6]='B Baru'
    AJUD[7]='H Akhir'

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
         CLOSE ALL
         Return (nil)
      ENDIF
       ?? chr(15)
       @2,22 SAY mJudul
       @3,20 SAY ' PERIODE :'
       @3,31 SAY dTGLAWAL
       @3,40 SAY '-'
       @3,43 SAY dTGLAKHIR
@4,1 SAY '-----------------------------------------------------------------------------------------------------------'
@5,1 SAY '|kod|       Nama Langgan      |   H.Awal     |   B.Awal     |   H.Baru     |   B.Baru     |   H.AKHIR     |'
@6,1 SAY '-----------------------------------------------------------------------------------------------------------'
   BR:=7
DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+kode2+'|'+CATAT+'|'+TRAN(Qtt,'@E 99,999,999,999')+'|'+TRAN(Harga,'@E 99,999,999,999')+'|'+;
             TRAN(Harga1,'@E 99,999,999,999')+'|'+ TRAN(Harga2,'@E 99,999,999,999')+'|'
   @BR,PCOL() SAY TRAN(HARGA3,'@E 99,999,999,999')+'|'
   IF BR=60
@br+1,1 SAY '-----------------------------------------------------------------------------------------------------------'
      @BR+2,1 SAY ''
      SETPRC(0,0)
      ?? chr(18)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      SET COLOR TO W*/R
      KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
      @1,0
      IF !CEKPRINT()
         CLOSE ALL
         Return (nil)
      ENDIF
        ?? chr(15)
       @2,22 SAY mjudul
       @3,20 SAY ' PERIODE :'
       @3,31 SAY dTGLAWAL
       @3,40 SAY '-'
       @3,43 SAY dTGLAKHIR
@4,1 SAY '-----------------------------------------------------------------------------------------------------------'
@5,1 SAY '|kod|       Nama Langgan      |   H.Awal     |   B.Awal     |   H.Baru     |   B.Baru     |   H.AKHIR     |'
@6,1 SAY '-----------------------------------------------------------------------------------------------------------'
      BR:=7
   ENDIF
        BR++
        SKIP
    ENDDO
@br,1 SAY '-----------------------------------------------------------------------------------------------------------'
        @BR+1,1 SAY ''
        SETPRC(0,0)
        ?? chr(18)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
ENDIF
tone(700,20)
ER:=.N.
SET COLOR TO W/R,N*/G
@1,1 SAY ' APAKAH DATA PIUTANG AKAN DI RUBAH [Y/N]? ' GET ER PICT 'Y'
READ
If Er
   Sele Rekap 
   Dbgotop()
  While !Eof()
    Sele Lgn
    seek Rekap->Kode2
    If Found()
      Replace Totalut with rekap->Harga3
    endif
    sele Rekap
    skip
 enddo
endif
dbcloseAll()
restscreen(,,,,MScreen)
setcolor(MColor)
return Nil
