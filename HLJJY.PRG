* -------------------------------------------------------- *
* TLJJY.PRG                                                *
* PROGRAM TRANSFER DATA UNTUK LJJY                         *
* -------------------------------------------------------- *

SET DATE ITALI
SET COLOR TO
CLEAR
set status off
set confirm oN
set exact on
SET DELETE ON
set score off
set wrap on
set color to w/r
@3,23 say ' Data yang akan di HAPUS '
SET COLOR TO GR+/B
@5,20 TO 13,52
// secur()
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
          // secur()
          close all
          setcolor('')
          clear
          return
     CASE PIL=1
        USE TRIN INDEX TGLINX.elx,BPBX.elx
        cari1()
        LI:=0
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLIN<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK
       set default to c:
       USE HT INDEX TGLHTX.elx,NOHTX.elx
       seek tglawal
        DO WHILE TGLHT<=TGLAKHIR .AND. .NOT. EOF()
          DELETE
         SKIP
       ENDDO

     CASE PIL=2
        USE TROUT INDEX TGLOUTX.elx
        cari1()
        LI:=0
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLOUT<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK
       set default to c:
       USE PUT INDEX TGLPTX.elx
       seek tglawal
        DO WHILE TGLPT<=TGLAKHIR .AND. .NOT. EOF()
          DELETE
         SKIP
       ENDDO

     CASE PIL=3
        USE TRVLK
        PACK
     case pil=4
        USE TRPT INDEX TGLBYRPT.elx
        cari1()
        LI:=0
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLBYR<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK

     CASE PIL=5
        USE TRSS INDEX TGLSSX.elx
        cari1()
        LI:=0
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLSS<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK

     case pil=6
        USE TRHT INDEX TGLBYRX.elx,nobyrx.elx
        LI:=0
        cari1()
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLBYR<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK
     CASE PIL=7
        USE TRstk INDEX TGLstk.elx,nostk.elx,buktistk.elx
        LI:=0
        cari1()
        if !caritgl(tglawal)
           // secur()
           komentar(8,' Data tidak ditemukan ........' )
           clear
           RETURN
        ENDIF
        DO WHILE TGLin<=TGLAKHIR .AND. .NOT. EOF()
          DO LIHAT
          DELETE
         SKIP
       ENDDO
       PACK
  ENDCASE
        close all
        // secur()
        SETCOLOR('')
        WAIT ' DATA SUDAH DIHAPUS, TEKAN SEMBARANG TOMBOL ............. '
        CLEAR
        return

Function cari1
***************************************
set color to
clear
SET COLOR TO GR+/B,W/R
public tglawal,tglakhir
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
RETURN nil

Function LIHAT
*********************************
setcolor('')
cls
set color to w/r
@5,20 say ' Tunggu Proses ......... '
           @10,12 say 'No Record --->'
           li++
           set color to n/w+
           @10,27 say li pict '9,999'
return li