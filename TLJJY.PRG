* -------------------------------------------------------- *
* TLJJY.PRG                                                *
* PROGRAM TRANSFER DATA UNTUK LJJY                         *
* -------------------------------------------------------- *
Memvar Getlist
Static aTmp
Static aHil
Static Tglawal
Static Tglakhir
Static TDrv
Static li
Static lih
Static pil
Static acu
Static i
Static No
Static j
Field Nobpb,Tglin,tglbyr,Faktur,qtt,kodbrg,tglss,bukti,tglht,tglout,tglpt

Function Tljjy()
set talk off
set status off
set confirm oN
set exact on
SET DELETE ON
set score off
set wrap on
set date italian
aTmp:={}
aHil:={}
Geser(3)
li:=1
set color to gr+
@1,0 say 'Program ini digunakan untuk merekam data Transaksi.'
@2,0 say 'Pastikan tempat tujuan perekaman sudah tersedia.'
set color to b
@4,0 say '* Cara menggunakan Program ini *'
set color to gr
@6,0 say ' 1. Pilih jenis data yang akan ditransfmr.'
@7,0 say ' 2. Tentukan tanggal data yang akan ditransfer.'
set color to b
@9,0 say ' * Pesan yang akan muncul jika ada kesalahan *'
set color to gr
@12,0 say ' 1. Tanggal mulai perekaman tidak ditemukan.'
set color to w/r+
@14,0 say ' * Keterangan * '
set color to gr
@16,0 say ' 1. Sumber adalah:'
@17,0 say '       Drive tempat data yang akan di Copy kan,'
@18,0 say '       jika data ada pada Directori pastikan directori aktif pada saat itu '
@19,0 say ' 1. Tujuan adalah:'
@20,0 say '       Drive tempat data yang akan di simpan,'
@21,0 say '       jika data ada pada Directori pastikan directori aktif pada saat itu '
wait ' Tekan Sembarang Tombol.......... '
Pilih()
close all
Return (nil)

Static Function Pilih()
While .t.
Geser(2)
set color to w/r
@1,2 say ' Esc --> Keluar '
@3,23 say ' Data yang akan di copy kan '
SET COLOR TO GR+/B
@5,20 TO 13,52
SET COLOR TO GR+/B,GR+/R
@6,21 prompt ' 1. Pembelian                  '
@7,21 prompt ' 2. Pengeluaran                '
@8,21 prompt ' 3. Vulkanisir                 '
@9,21 prompt ' 4. Pembayaran Piutang         '
@10,21 prompt ' 5. Penyesuaian                '
@11,21 prompt ' 6. Pembayaran Hutang          '
@12,21 prompt ' 7. Pemasukan Barang           '
MENU TO PIL

  DO CASE
     CASE PIL %8=0
        close all
        set default to c:
        exit
     CASE PIL=1
        tin()
     CASE PIL=2
        tout()
     CASE PIL=3
        tvlk()
     case pil=4
        tput()
     CASE PIL=5
        tpss()
     case pil=6
        tht()
     CASE PIL=7
        tpo()
  ENDCASE
  atmp:={}
  ahil:={}
  SET COLOR TO
  WAIT ' TEKAN SEMBARANG TOMBOL ............. '
  CLEAR
  close all
  set default to c:
enddo

Return (nil)


Static Function Tin()
***************************************
USE TRIN INDEX TGLINX.elx,bpbx.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
   RETURN nil
ENDIF
TUJUAN()
IF TDRV=1
    while trin->tglin<=Tglakhir .and. ! eof()
       For i:=1 to fcount()
           aAdd(aHil,trin->(Fieldget(i)))
       next i
       aadd(aTmp,ahil)
       aHil:={}
       Skip
    enddo
    set color to gr
    @8,5 say ' Pemasukan barang ........ '
    LI:=0
    set default to a:
    IF .NOT. FILE('TRIN.DBF')
       set default to c:
       COPY STRU TO a:\TRIN.DBF
       set default to a:
       USE TRIN
       INDEX ON TGLIN TO TGLINX.elx
       INDEX ON NOBPB TO BPBX.elx
    ENDIF
    USE TRIN INDEX TGLINX.elx,BPBX.elx
    For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == TGLIN .AND. aTmp[i,2] == NOBPB .AND.;
              aTmp[i,5] == KODBRG
              A->(dbskip())
              i++
              if i >= Len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           Dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbAppend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i

ELSE
   set color to gr
   @8,5 say ' Pemasukan barang ........ '
   LI:=0
   set default to b:
   IF .NOT. FILE('TRIN.DBF')
       set default to c:
      COPY STRU TO b:\TRIN.DBF
      set default to b:
      USE TRIN
      INDEX ON TGLIN TO TGLINX.elx
      INDEX ON NOBPB TO BPBX.elx
   ENDIF
   USE TRIN INDEX TGLINX.elx,BPBX.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == TGLIN .AND. aTmp[i,2] == NOBPB .AND.;
              aTmp[i,5] == KODBRG
              A->(dbskip())
              i++
              if i >= Len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF

* data hutang
***************************************
set default to c:
USE HT INDEX TGLHTX.elx,NOHTX.elx
pack
aTmp:={}
aHil:={}
seek tglawal
while ht->tglht<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,Fieldget(i))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo

IF TDRV=1
    set color to gr
    @8,5 say ' Data Hutang ................ '
    LI:=0
    set default to a:
   IF .NOT. FILE('HT.DBF')
      set default to c:
      COPY STRU TO a:\HT.DBF
      set default to a:
      USE HT
      INDEX ON TGLHT TO TGLHTX.elx
      INDEX ON NOBPB TO NOHTX.elx
   ENDIF

   USE HT INDEX TGLHTX.elx,NOHTX.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglht .and. aTmp[i,2] == NOBPB
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i

ELSE
   set color to gr
   @8,5 say ' Data Hutang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('HT.DBF')
      set default to c:
     COPY STRU TO b:\HT.DBF
     set default to b:
     USE HT
     INDEX ON TGLHT TO TGLHTX.elx
     INDEX ON NOBPB TO NOHTX.elx
   ENDIF

   USE HT INDEX TGLHTX.elx,NOHTX.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglht .and. aTmp[i,2] == NOBPB
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF
return nil


Static Function TOUT()
 ***************************************
 ahil:={}
 atmp:={}
USE TROUT INDEX TGLOUTX.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
   RETURN nil
ENDIF
while tglout<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,trout->(Fieldget(i)))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
TUJUAN()
IF TDRV=1
  COPY TO A:\SEM.DBF WHILE TGLOUT<=TGLAKHIR
   set color to gr
   @8,5 say ' Pengeluaran barang ........ '
   LI:=0
   set default to a:
   IF .NOT. FILE('TROUT.DBF')
      set default to c:
     COPY STRU TO a:\TROUT.DBF
     set default to a:
     USE TROUT
     INDEX ON TGLOUT TO TGLOUTX.elx
   ENDIF

   USE TROUT INDEX TGLOUTX.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglout .and. aTmp[i,2] == Faktur .and. ;
                 aTmp[i,4] == Kodbrg .and. aTmp[i,6] == Qtt
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ELSE
   set color to gr
   @8,5 say ' Pengeluaran barang ........ '
   LI:=0
   set default to b:
   IF .NOT. FILE('TROUT.DBF')
      set default to c:
     COPY STRU TO b:\TROUT.DBF
     USE TROUT
     INDEX ON TGLOUT TO TGLOUTX.elx
   ENDIF
   USE TROUT INDEX TGLOUTX.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglout .and. aTmp[i,2] == Faktur .and. ;
                 aTmp[i,4] == Kodbrg .and. aTmp[i,6] == Qtt
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF

* data PIutang
 ***************************************
set default to c:
USE PUT INDEX TGLPTX.elx
pack
SEEK TGLAWAL
aTmp:={}
aHil:={}
while tglpt<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,Fieldget(i))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
IF TDRV=1
   set color to gr
   @8,5 say ' Data PIutang ................ '
   LI:=0
   set default to a:
   IF .NOT. FILE('PUT.DBF')
      set default to c:
     COPY STRU TO a:\PUT.DBF
     set default to a:
     USE PUT
     INDEX ON TGLPT TO TGLPTX.elx
   ENDIF
   use put index tglptx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglpt .and. aTmp[i,2] == Faktur
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ELSE
   set color to gr
   @8,5 say ' Data PIutang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('PUT.DBF')
      set default to c:
     COPY STRU TO b:\PUT.DBF
     set default to b:
     USE PUT
     INDEX ON TGLPT TO TGLPTX.elx
   ENDIF
   use put index tglptx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglpt .and. aTmp[i,2] == Faktur
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHaT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
endif
return nil


Static Function TVLK()
tujuan()
USE TRVLK
pack
IF TDRV=1
  COPY TO A:\TRVLK.DBF WHILE .NOT. EOF()
ELSE
  COPY TO B:\TRVLK.DBF WHILE .NOT. EOF()
ENDIF
return nil

Static Function TPUT()
***************************************
USE TRPT INDEX TGLBYRPT.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
 RETURN nil
ENDIF
while tglbyr<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,Fieldget(i))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
TUJUAN()
IF TDRV=1
   set color to gr
   @8,5 say ' Pembayaran PIutang ................ '
   LI:=0
   set default to a:
   IF .NOT. FILE('Trpt.DBF')
      set default to c:
     COPY STRU TO a:\trpt.DBF
     set default to a:
     USE Trpt
     INDEX ON TGLbyr TO TGLbyrpt.elx
   ENDIF
   use trpt index tglbyrpt.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,4]
        IF FOUND()
           WHILE aTmp[i,4] == tglbyr .and. aTmp[i,2] == Faktur
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ELSE
   set color to gr
   @8,5 say ' Pembayaran PIutang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('Trpt.DBF')
      set default to c:
     COPY STRU TO b:\trpt.DBF
     set default to b:
     USE Trpt
     INDEX ON TGLbyr TO TGLbyrpt.elx
   ENDIF
   use trpt index tglbyrpt.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,4]
        IF FOUND()
           WHILE aTmp[i,4] == Tglbyr .and. aTmp[i,2] == Faktur
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF
return nil

Static Function TPSS()
 ***************************************
USE TRSS INDEX TGLSSX.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
   RETURN nil
ENDIF
while tglss<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,Fieldget(i))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
TUJUAN()
IF TDRV=1
   set color to gr
   @8,5 say ' Penyesuaian Stok Barang ................ '
   LI:=0
   set default to a:
   IF .NOT. FILE('Trss.DBF')
      set default to c:
     COPY STRU TO a:\trss.DBF
     set default to a:
     USE Trss
     INDEX ON TGLss TO TGLssx.elx
   ENDIF
   use trss index tglssx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglss .and. aTmp[i,2] == Bukti .and. ;
               aTmp[i,5] == qtt .and. aTmp[i,4] == KOdbrg
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
          LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i

ELSE
   set color to gr
   @8,5 say ' Penyesuaian Stok Barang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('Trss.DBF')
      set default to c:
     COPY STRU TO b:\trss.DBF
     set default to b:
     USE Trss
     INDEX ON TGLss TO TGLssx.elx
   ENDIF
   use trss index tglssx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglss .and. aTmp[i,2] == Bukti .and. ;
               aTmp[i,5] == qtt .and. aTmp[i,4] == KOdbrg
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF
return nil

Static Function THT()
 ***************************************
USE TRHT INDEX TGLBYRX.elx,nobyrx.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
 RETURN nil
ENDIF
while tglbyr<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,Fieldget(i))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
TUJUAN()
IF TDRV=1
   set color to gr
   @8,5 say ' Pembayaran Hutang ................ '
   LI:=0
   set default to a:
   IF .NOT. FILE('Trht.DBF')
      set default to c:
     COPY STRU TO a:\trht.DBF
     set default to a:
     USE Trht
     INDEX ON TGLbyr TO TGLbyrx.elx
     index on nobpb to nobyrx.elx
   ENDIF
   use trht index tglbyrx.elx,nobyrx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,5]
        IF FOUND()
           WHILE aTmp[i,5] == Tglbyr .and. aTmp[i,2] == Nobpb
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ELSE
   set color to gr
   @8,5 say ' Pembayaran Hutang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('Trht.DBF')
      set default to c:
     COPY STRU TO b:\trht.DBF
     set default to b:
     USE Trht
     INDEX ON TGLbyr TO TGLbyrx.elx
     index on nobpb to nobyrx.elx
   ENDIF
   use trht index tglbyrx.elx,nobyrx.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,5]
        IF FOUND()
           WHILE aTmp[i,5] == Tglbyr .and. aTmp[i,2] == Nobpb
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
          LIHAT()
          dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF
return nil

Static Function TPO()
***************************************
USE TRstk INDEX TGLstk.elx,buktistk.elx,nostk.elx
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
 RETURN nil
ENDIF
while tglin<=Tglakhir .and. ! eof()
    For i:=1 to fcount()
        aAdd(aHil,(Fieldget(i)))
    next i
    aadd(aTmp,ahil)
    aHil:={}
    Skip
enddo
TUJUAN()
IF TDRV=1
   set color to gr
   @8,5 say ' Pemasukkan barang ................ '
   LI:=0
   set default to a:
   IF .NOT. FILE('Trstk.DBF')
      set default to c:
     COPY STRU TO a:\trstk.DBF
     set default to a:
     USE Trstk
     INDEX ON TGLin TO TGLstk.elx
     index on nobpb to nostk.elx
     index on bukti to buktistk.elx
   ENDIF
   use trstk index tglstk.elx,buktistk.elx,nostk.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglin .and. aTmp[i,6] == bukti .and. ;
                 aTmp[i,5] == Kodbrg .and. aTmp[i,4] == Qtt
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,aTmp[i,j])
           next j
           a->(dbskip())
       ENDIF
    next i
ELSE
   set color to gr
   @8,5 say ' Pemasukkan barang ................ '
   LI:=0
   set default to b:
   IF .NOT. FILE('Trstk.DBF')
      set default to c:
     COPY STRU TO b:\trstk.DBF
     set default to b:
     USE Trstk
     INDEX ON TGLin TO TGLstk.elx
     index on nobpb to nostk.elx
     index on bukti to buktistk.elx
   ENDIF
   use trstk index tglstk.elx,buktistk.elx,nostk.elx
   For i:=1 to len(aTmp)
        SEEK aTmp[i,1]
        IF FOUND()
           WHILE aTmp[i,1] == Tglin .and. aTmp[i,6] == bukti .and. ;
                 aTmp[i,5] == Kodbrg .and. aTmp[i,4] == Qtt
              A->(dbskip())
              i++
              if i >= len(aTmp)
                 Return nil
              endif
           ENDDO
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,fieldget(aTmp[i,j]))
           next j
           A->(dbSKIP())
        else
           LIHAT()
           dbappend()
           For j:=1 to len(aTmp[i])
               Fieldput(j,fieldget(aTmp[i,j]))
           next j
           a->(dbskip())
       ENDIF
    next i
ENDIF
return nil

Static Function Cari1()
***************************************
set color to
clear
SET COLOR TO GR+/B,W/R
TGLAWAL :=CTOD(' // ')
TGLAKHIR := CTOD(' // ')
  @ 5,7 SAY '  TANGGAL : 'GET TGLAWAL
  @ 5,28 SAY '   SAMPAI'
  @ 5,38 SAY '   TANGGAL :'GET TGLAKHIR
  READ

  IF TGLAKHIR=CTOD(' / / ')
     TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @5,51 SAY TGLAKHIR
   SET COLOR TO GR+/B
  ENDIF

IF .NOT. FOUND()
   ACU:=0
   SET COLOR TO W+*/R+
   @22,70 SAY 'THINKING'
   SET COLOR TO
   SEEK TGLAWAL
 DO WHILE .NOT. FOUND().AND.(ACU<300)
   ACU:=ACU+1
   TGLAWAL:=TGLAWAL+1
   SEEK TGLAWAL
 ENDDO
@21,0 CLEAR TO 23,79
ENDIF
SEEK TGLAWAL
  IF .NOT. FOUND()
    SET COLOR TO W+/R+
    @8,1 SAY '  DATA TIDAK DITEMUKAN  '
    WAIT ''
    @8,0 CLEAR TO 8,70
    SET COLOR TO
    CLEAR
    Return nil
  ENDIF
return nil

Static Function TUJUAN()
 ******************************
lih:=1
set color to
clear
set color to w/r
@3,25 say ' Tujuan '
SET COLOR TO n/bg
@5,20 TO 9,40
SET COLOR TO n/bg,w/R
@6,21 PROMPT ' 1.  DRIVE A:      '
@7,21 PROMPT ' 2.  DRIVE B:      '
@8,21 prompt ' 3.  Keluar .......'
MENU TO lih
  DO CASE
     CASE lih=1
       tdrv:=1
     CASE lih=2
       tdrv:=2
     case lih=3
       set color to
       clear
       Return nil
  ENDCASE

set color to w/r*
@20,40 say ' Tunggu Proses ..... '
 if tdrv=1
  set default to a:
   IF !FILE('STK.DBF')
     set default to c:
     copy file stk.dbf to a:stk.dbf
     copy file stkx.elx to a:stkx.elx
     copy file grpx.elx to a:grpx.elx
     copy file pmsk.dbf to a:pmsk.dbf
     copy file pmskx.elx to a:pmskx.elx
     copy file no.dbf to a:no.dbf
     copy file notr.dbf to a:notr.dbf
     copy file lgn.dbf to a:lgn.dbf
     copy file lgn.elx to a:lgn.elx
     copy file namax.elx to a:namax.elx
   ENDIF

 else
    set default to b:
   IF .NOT. FILE('STK.DBF')
     set default to c:
     copy file stk.dbf to b:stk.dbf
     copy file stkx.elx to b:stkx.elx
     copy file grpx.elx to b:grpx.elx
     copy file pmsk.dbf to b:pmsk.dbf
     copy file pmskx.elx to b:pmskx.elx
     copy file no.dbf to b:no.dbf
     copy file notr.dbf to b:notr.dbf
     copy file lgn.dbf to b:lgn.dbf
     copy file lgn.elx to b:lgn.elx
     copy file namax.elx to b:namax.elx
   ENDIF
endif
set default to c:
set color to
clear
return nil

Static Function LIHAT()
*********************************
set color to w/r
@5,20 say ' Tunggu Proses ......... '
           @10,12 say 'No Record --->'
           li++
           set color to n/w+
           @10,27 say li pict '9,999'
return nil