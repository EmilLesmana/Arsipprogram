Function Rsandi()
Local cSandi:=space(10),;
      cSandi1:=space(10),;
      cSandi2:=space(10),;
      cSandi3:=space(10)
Setcolor('n+/n+')
@0,0,24,79 box Repli(Chr(219),9)
Setcolor('n/w')
@0,2 say ' Untuk perubahan sandi Pembukaan '
Setcolor('w/n+,w/n+')
setcursor(2)
@2,2 SAY ' Masukan Sandi Lama :' Get cSandi Pict '@!'
Read
If cSandi#No->Sandi1
   Berita(15,39,' Sandi Tidak sah, Tekan sembarang tombol. ','w/r')
   use
   Return nil
Else
   @4,2 say ' Masukan Sandi Baru :' Get cSandi1 Pict '@!'
   Read
   If cSandi1==space(10)
      cSandi1:=cSandi
   endif
endif
Replace No->Sandi1 with cSandi1
Berita(15,39,' Perubahan Sandi Pertama sudah dilakukan, Tekan sembarang tombol. ','w/r')

Setcolor('n/w')
@6,2 say ' Untuk perubahan sandi Laporan / Kedua '
Setcolor('w/n+,w/n+')
setcursor(2)
@8,2 say ' Masukan Sandi Lama :' Get cSandi Pict '@!'
Read

If cSandi#No->Sandi2
   Berita(15,39,' Sandi Tidak sah, Tekan sembarang tombol. ','w/r')
   use
   Return nil
Else
   @10,2 say ' Masukan Sandi Baru :' Get cSandi2 Pict '@!'
   Read
   If cSandi2==space(10)
      cSandi2:=cSandi
   endif
endif
Replace No->Sandi2 with cSandi2
Berita(15,39,' Perubahan Sandi Kedua sudah dilakukan, Tekan sembarang tombol. ','w/r')

Setcolor('n/w')
@12,2 say ' Untuk perubahan sandi Laporan / KeTiga '
Setcolor('w/n+,w/n+')
setcursor(2)
@14,2 say ' Masukan Sandi Lama :' Get cSandi Pict '@!'
Read

If cSandi#No->Sandi
   Berita(15,39,' Sandi Tidak sah, Tekan sembarang tombol. ','w/r')
   use
   Return nil
Else
   @16,2 say ' Masukan Sandi Baru :' Get cSandi3 Pict '@!'
   Read
   If cSandi==space(10)
      cSandi3:=cSandi
   endif
endif
Replace No->Sandi with cSandi3
Berita(15,39,' Perubahan Sandi KETIGA sudah dilakukan, Tekan sembarang tombol. ','w/r')
use
Return nil