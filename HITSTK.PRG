Function HitStk()
* Program Hitstk.prg
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
index on kodbrg to semstk
set index to semstk
set relation to Kodbrg into stk
dbgotop()
nBlAwal:=nBl:=nSSinAwal:=nSSin:=nSSotawal:=nSSot:=nOtAwal:=nOt:=0
nStkawal:=nStkakhir:=0
do while ! eof()
   MKdBr:=KodBrg
   cNama:=stk->Nama

   select Rekap
   dbseek(mkdbr)
   If ! found()
      dbappend()
      repl Kode1 with MKdBr,Catat with cnama,;
           qtt  with trstk->Qtt
   else
      repl qtt  with Qtt+trstk->Qtt
   endif
   sele Trstk
   skip
enddo

select Trss
set relation to Kodbrg into stk
dbgotop()
do while ! eof()
   MKdBr:=Kodbrg
   cNama:=stk->nama
   select Rekap
   If Trss->Status=='INSTK'
      dbseek(mkdbr)
      If ! found()
         dbappend()
         repl Kode1 with MKdBr,Catat with cnama,;
              qtt  with trss->Qtt
      else
         repl qtt  with Qtt+trss->Qtt
      endif
    else
      dbseek(mkdbr)
      If ! found()
         dbappend()
         repl Kode1 with MKdBr,Catat with cnama,;
              qtt  with -1*trss->Qtt
      else
         repl qtt  with Qtt-trss->Qtt
      endif
    endif
    Sele Trss
    skip
Enddo

sele trout
set relation to Kodbrg into stk
dbgotop()
do while ! eof()
   MKdBr:=KodBrg
   cNama:=stk->Nama

   select Rekap
   dbseek(mkdbr)
   If !found()
      dbappend()
      repl Kode1 with MKdBr,Catat with cnama,;
           qtt  with -1*trout->Qtt
   else
      repl qtt  with Qtt-trout->Qtt
   endif
   sele Trout
   skip
enddo

sele Rekap

dbGOTOP()
do while ! eof()
 sele stk
 dbseek(rekap->kode1)
 If Found()
    Replace Qtt with rekap->qtt
 endif
 sele rekap
 skip
enddo

SET COLOR TO
CLEAR


dbcloseAll()
restscreen(,,,,MScreen)
setcolor(MColor)
return Nil
