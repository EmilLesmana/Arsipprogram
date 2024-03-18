Function Menu44()
* Program Menu44.Prg
* Restore data yang pernah dibackup
#include "inkey.ch"
local MScreen:=savescreen(), MColor:=setcolor(), Pil
local MJudul:="RESTORE DATA TRANSAKSI"

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

//MDrive:=space(1)
//setcursor(1)
//Sbox(10,20,12,60,"w+/b,gr+/br")
//@11,25 say "Restore dari drive : " get MDrive pict "!" valid MDrive $ "ABCF"
//read
setcursor(0)

if lastkey()=K_ESC
   restscreen(,,,,MScreen)
   setcolor(MColor)
   return
endif

MFile:="*.stk"
declare AName[adir(MFile)]
adir(MFile,Aname)

Sbox(14,20,22,35,"n/bg,gr+/b")
Pil:=achoice(15,21,21,34,Aname)

if Pil=0
   restscreen(,,,,MScreen)
   setcolor(MColor)
   return
endif

SBox(9,20,11,60,"w*+/b")
@10,27 say "Tunggu..., sedang restore!"

dbcloseAll()
BukaR()

MTgS:=left(Aname[Pil],8)
MTgl:=ctod(MTgS)

//restore Pemasukan Barang
select Trstk
dbseek("STBACKUP")
While Bukti=='STBACKUP' .AND. !EOF()
  If Bukti=="STBACKUP" .and. Tglin==MTgl
     delete
  endif
skip
enddo
pack
MFile:=Aname[Pil]
append from &MFile
erase &MFile
close Trstk

//restore pembelian
select Trin
MFile:=MTgS+".tri"
append from &MFile
erase &MFile
close Trin

select Trss
MFile:=MTgS+".trs"
append from &MFile
erase &MFile
close Trss

select Trout
MFile:=MTgS+".out"
append from &MFile
erase &MFile
close Trout

select Ht
MFile:=MTgS+".UT"
append from &MFile
erase &MFile
close Ht

select Trht
MFile:=MTgS+".ByU"
append from &MFile
erase &MFile
Close Trht

select Put
MFile:=MTgS+".pT"
append from &MFile
erase &MFile
close Put

select Trpt
MFile:=MTgS+".Byp"
append from &MFile
erase &MFile
dbcloseAll()

tone(700,1)
tone(600,1)
tone(500,1)
tone(400,1)
tone(300,1)
restscreen(,,,,MScreen)
setcolor(MColor)
return Nil

