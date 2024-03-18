Function Menu43()
* Program Menu43.prg
* Tutup data tidak aktif
# include "inkey.ch"
local MScreen:=savescreen(), MColor:=setcolor()
local mjudul:="TUTUP DATA TIDAK AKTIF"
Local Qttin,Qttotss,Qttinss,Qttot,mSakhir
Sbox(10,15,17,65,"w+/r")
@11,17      say "PERHATIAN!!!"
@row()+1,17 say "Data harus di-BACKUP dulu!!!"
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
MTgBackup:=ctod("")
MDrive:=space(1)
setcursor(1)
@row()+1,22  say "Tanggal backup :" get MTgBackup
//@ row()+1,22 say "Drive hasil    :" get MDrive pict "!" valid MDrive $"ABCF"
read
setcursor(0)
restscreen(,,,,MScreen)
setcolor(Mcolor)
if lastkey()=K_ESC
    return
endif

TgS:=dtoc(MTgBackUp)
FileTrin:=dtoc(MtgBackUp)+'.tri'
FileTstk:=dtoc(MtgBackUp)+".Stk"
FileTrot:=dtoc(MtgBackUp)+".Out"
FileTrss:=dtoc(MtgBackUp)+".Trs"
FileByHt:=dtoc(MtgBackUp)+".BYU"
FileByPt:=dtoc(MtgBackUp)+".BYP"
FileHut:=dtoc(MtgBackUp)+".UT"
FilePut:=dtoc(MtgBackUp)+".PT"
if file(FileTrin)
   Sbox(10,20,13,60,"w*+/b")
   @11,22 say "File "+FileTrin+" sudah ada!"
   @12,22 say "Back-Up dibatalkan..."
   tone(700,10)
   inkey(10)

   restscreen(,,,,MScreen)
   setcolor(MColor)
   return
endif

SBox(10,20,12,60,"w*+/r")
@11,27 say "Tunggu..., sedang backup!"

set dele on
dbcloseAll()
BukaR()
sele trout
index on kodbrg to semtrout
set index to semtrout
sele trss
index on kodbrg to semtrss
set index to semtrss
select Trstk
pack
copy stru to SemTrstk
use SemTrstk exclusive new

select Trstk
index on Kodbrg+dtoc(Tglin) to semtrstk
set index to semtrstk
set relation to Kodbrg into stk
SBox(15,20,17,60,"w*+/r")
@16,27 say "Backup data Pemasukan Barang                       ...."
dbgotop()
do while ! eof()
   Qttin:=Qttotss:=Qttinss:=Qttot:=mSakhir:=0
   MKdBr:=KodBrg
   While KodBrg=MKdBr .and. !eof()
      If Tglin<=MTgBackup
         Qttin+=Qtt
      endif
      dbskip()
   enddo

   select Trss
   dbseek(mkdbr)
   while KodBrg=MKdBr .and. !eof()
      If Tglss<=MTgBackup
         If Status='INSTK'
            QttInss+=Qtt
         else
            Qttotss+=Qtt
         endif
      endif
      dbskip()
   enddo
   select Trout
   dbseek(MKdBr)
   while KodBrg=MKdBr .and. !eof()
      If Tglout<=MTgBackup
         QTTot+=Qtt
      endif
      dbskip()
   enddo


   MSAkhir:=QttIn+QttInss-Qttotss-Qttot

   select SemTrstk
   dbappend()
   repl KodBrg with MKdBr,;
        Bukti  with 'STBACKUP',;
        Tglin  with MTgBackup,;
        Qtt with MSAkhir

   select Trstk
enddo

select Trin
pack
copy to &FileTrin for Tglin<=MTgBackup .and. Sisa==0
dbgotop()
While !Eof()
  If Tglin<=MTgBackup .and. Sisa==0
     delete
  endif
skip
enddo  
pack
close Trin
tone(700,1)

select Trstk
pack
copy to &FileTstk for Tglin<=MTgBackup
dbgotop()
While !Eof()
  If Tglin<=MTgBackup
     delete
  endif
skip
enddo
pack
tone(700,1)

do SBox with 15,20,17,60,"w*+/r"
@16,27 say "Backup data Penyesuaian barang...."
select Trss
pack
copy to &FileTrss for Tglss<=MTgBackup
dele for Tglss<=MTgBackup
pack
close Trss
tone(700,1)

do SBox with 15,20,17,60,"w*+/r"
@16,27 say "Backup data penjualan...."
select Trout
pack
copy to &FileTrot for Tglout<=MTgBackup
dele for Tglout<=MTgBackup
pack
close Trout
tone(700,1)

SBox(15,20,17,60,"w*+/r")
@16,27 say "Backup data Piutang...."
select Trpt
pack
select Put
set order to 2
pack
dbgotop()
do while ! eof()
   if Jmlpt<>Tunai+Giro
      dbskip()
      loop
   endif
   if tglout>mTgbackup
      dbskip()
      loop
   endif
   MCari:=Faktur
   select TrPt
   dbseek(MCari)
   if found()
      do while Faktur=Put->Faktur
         dbskip()
      enddo
      dbskip(-1)
      if TglByr < MtgBackUp
         select Put
         delete
      endif
   endif
   select Put
   dbskip()
enddo
Sele Put
copy to SemPutH for deleted()
use SemPutH new exclusive
recall all
close SemPutH
rename SemPutH.DBF to &FilePUt
select Put
pack
tone(700,1)

do SBox with 15,20,17,60,"w*+/r"
@16,27 say "Backup data bayar utang...."
select TrPt
dbgotop()
copy to &FileByPt for TglByr<=MTgBackup
dele for TglByr<=MTgBackup
pack
tone(700,1)

SBox(15,20,17,60,"w*+/r")
@16,27 say "Backup data Utang...."
select TrHt
pack
select Ht
pack
set order to 2
dbgotop()
do while ! eof()
   if JmlHt<>Tunai+Giro
      dbskip()
      loop
   endif
   if Tglin > MTgBackUp
      dbskip()
      loop
   endif
   MCari:=Nobpb
   select TrHt
   dbseek(MCari)
   if found()
      do while Nobpb=Ht->Nobpb
         dbskip()
      enddo
      dbskip(-1)
      if TglByr < MtgBackUp
         select Ht
         delete
      endif
   endif
   select Ht
   dbskip()
enddo
sele Ht
copy to SemHutH for deleted()
use SemHutH new exclusive
recall all
close SemHutH
rename SemHutH.DBF to &FileHUt
select Ht
pack
tone(700,1)

SBox(15,20,17,60,"w*+/r")
@16,27 say "Backup data bayar utang...."
select TrHt
copy to &FileByHt for TglByr<=MTgBackup
dele for TglByr<=MTgBackup
pack
tone(700,1)

close SemTrstk
select Trstk
append from SemTrstk
tone(700,20)
dbcloseAll()
Berita(15,30,'Proses BackUp Selesai tekan sembarang tombol ...... ','w/r')
restscreen(,,,,MScreen)
setcolor(MColor)
return Nil
