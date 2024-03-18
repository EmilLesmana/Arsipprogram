set date Itali
set cent on
set dele on
sele a
use Trpt
copy stru to Trpt1
sele b
use Trpt1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglout with a->Tglout,Faktur with a->Faktur,;
   Kodelgn with a->Kodelgn,Tglbyr with a->Tglbyr,Bank with a->Bank,;
   Giro with a->Giro,Tunai with a->Tunai,Sisa with a->Sisa
  sele a
  skip
enddo
set color to
wait ' Selesai Transaksi Piutang................ '
close all
Return

