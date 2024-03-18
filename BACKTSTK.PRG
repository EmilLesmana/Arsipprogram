set date Itali
set cent on
set dele on
sele a
use Trstk
copy stru to Trstk1
sele b
use Trstk1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglin with a->Tglin,Nobpb with a->Nobpb,Pms with a->Pms,;
   Qtt with a->Qtt,Kodbrg with a->Kodbrg,Bukti with a->Bukti
  sele a
  skip
enddo
set color to
wait ' Selesai Data Masuk barang ................ '
close all
Return

