set date Itali
set cent on
set dele on
sele a
use Trht
copy stru to Trht1
sele b
use Trht1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglht with a->Tglht,Nobpb with a->Nobpb,Pms with a->Pms,;
   Jmlht with a->Jmlht,Tglbyr with a->Tglbyr,Bank with a->Bank,;
   Giro with a->Giro,Tunai with a->Tunai,Status with a->Status,;
   Tglgr with a->Tglgr
  sele a
  skip
enddo
set color to
wait ' Selesai Transaksi Hutang................ '
close all
Return

