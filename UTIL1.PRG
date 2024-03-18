* Program Menu41.Prg
* Membuat file index
#include "inkey.ch"
#include "Directry.ch"
Function util1()
local MScreen:=savescreen(), MColor:=setcolor()
Sbox(10,15,16,65,"w+/r")
@11,16      say "PERHATIAN!!!"
//@row()+1,16 say "Program di workstation lain harus dihentikan!"
@row()+1,16 say "Proses ini akan cukup lama."
@row()+1,16 say "Tekan ESC untuk membatalkan atau"
@row()+1,16 say "Tekan sebarang tombol untuk melanjutkan!"
tone(700,10)
inkey(0)
if lastkey()=K_ESC
   restscreen(,,,,MScreen)
   setcolor(MColor)
   return nil
endif
AEVAL(DIRECTORY("*.ELX"), { |aFile| ;
    FERASE(aFile[F_NAME]) })
AEVAL(DIRECTORY("*.MLX"), { |aFile| ;
    FERASE(aFile[F_NAME]) })
begin sequence
  baru()
  dbcloseAll()
  tone(700,10)
end
restscreen(,,,,MScreen)
setcolor(MColor)
return nil
