set date Itali
set cent on
set dele on
sele a
use Trss
copy stru to Trss1
sele b
use Trss1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
   Replace Tglss with a->Tglss,Bukti with a->Bukti,Status with a->Status,;
   Qtt with a->Qtt,Kodbrg with a->Kodbrg,Harga with a->Harga,Ket with a->Ket
  sele a
  skip
enddo
set color to
wait ' Selesai Data Penyesuaian................ '
close all
Return

