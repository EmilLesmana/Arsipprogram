set date Itali
set cent on
set dele on
sele a
use Trout
copy stru to trout1
sele b
use trout1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglout with a->Tglout,Faktur with a->Tglout,;
   Mobil with a->Mobil,Kodbrg with a->Kodbrg,Qtt with a->Qtt,;
   Harga with a->Harga,Muka with a->Muka,Kodelgn with a->Kodelgn
  sele a
  skip
enddo
set color to
wait ' Selesai Penjualan................ '
close all
Return

