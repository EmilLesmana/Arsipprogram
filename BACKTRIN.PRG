*Static Function Tin()
***************************************
**USE TRIN INDEX TGLINX.elx,bpbx.elx
set date Itali
set cent on
set dele on
sele a
use Trin
copy stru to trin1
sele b
use trin1

sele a
dbgoto(2000)
while ! eof()
   Sele b
   dbappend()
     Replace Tglin with a->Tglin,Nobpb with a->Nobpb,;
     Kodpmsk with a->Kodpmsk,Qtt with a->Qtt,Kodbrg with a->Kodbrg,;
     Harga with a->harga,Sisa with a->sisa,Muka with a->Muka
  sele a
  skip
enddo
set color to
wait ' Selesai ................ '
close all
Return

