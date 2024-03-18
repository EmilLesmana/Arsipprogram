set date Itali
set cent on
set dele on
sele a
use ht
copy stru to ht1
sele b
use ht1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglin with a->Tglin,Nobpb with a->Nobpb,Kodpmsk with a->Kodpmsk,;
   Jmlht with a->Jmlht,Tglbyr with a->Tglbyr,Sisa with a->Sisa,;
   Giro with a->Giro,Status with a->Status,Tunai with a->Tunai
  sele a
  skip
enddo
set color to
wait ' Selesai Data Hutang................ '
close all
Return

