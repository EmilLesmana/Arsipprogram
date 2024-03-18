set date Itali
set cent on
set dele on
sele a
use Put
copy stru to Put1
sele b
use Put1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglout with a->Tglout,Faktur with a->Faktur,Nama with a->Nama,;
   Jmlpt with a->Jmlpt,Tglbyr with a->Tglbyr,Sisa with a->Sisa,;
   Giro with a->Giro,Tunai with a->Tunai,Status with a->Status,;
   Kodelgn with a->Kodelgn
  sele a
  skip
enddo
set color to
wait ' Selesai Data Piutang................ '
close all
Return

