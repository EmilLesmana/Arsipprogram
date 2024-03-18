#xcommand DEFAULT <var> to <nilai> =>;
       <var> := Iif( <var> == Nil, <nilai>, <var> )

FUNCTION BUKA1()
USE "TRIN.DTR" INDEX ('BPBX.ELX'),('TGLINX.ELX') NEW
USE "TRSTK.DTR" INDEX ('BUKTIX.ELX'),('TGLSTKX.ELX') NEW
USE "PMSK.DMT" INDEX ('PMSKX.MLX'),('NAMAPMSK.MLX') NEW
USE "STK.DMT" INDEX ('STKX.MLX'),('GRPX.MLX'),('NAMABRG.MLX') NEW
USE "HT.DTR" INDEX ('NOHTX.ELX'),('Tglhtx.elx') new
USE "TRSS.DTR" INDEX ('TGLSSX.ELX') NEW
USE "TRHT.DTR" INDEX ('NOBYRX.ELX'),('TGLBYRX.ELX') NEW
RETURN NIL

FUNCTION BUKA2()
USE "TROUT.DTR" INDEX ('Faktur.Elx'),('TGLOUTX.ELX') NEW
USE "STK.DMT" INDEX ('STKX.MLX'),('GRPX.MLX'),('NAMABRG.MLX') NEW
USE "TRPT.DTR" INDEX ('NOTRPUT.ELX'),('TGLBYRPT.ELX') NEW
USE "PUT.DTR" INDEX ('NOPUT.ELX'),('TGLPTX.ELX') NEW
USE "LGN.DMT" INDEX ('LGN.MLX'),('NAMAX.MLX') NEW
RETURN NIL

FUNCTION BUKABYR()
USE "TRHT.DTR" INDEX ('NOBYRX.ELX'),('TGLBYRX.ELX') NEW
USE "TRPT.DTR" INDEX ('NOTRPUT.ELX'),('TGLBYRPT.ELX') NEW
USE "HT.DTR" INDEX ('NOHTX.ELX'),('TGLHTX.ELX') NEW
USE "PUT.DTR" INDEX ('NOPUT.ELX'),('TGLPTX.ELX')  NEW
USE "PMSK.DMT" INDEX ('PMSKX.MLX'),('NAMAPMSK.MLX') NEW
USE "LGN.DMT" INDEX ('LGN.MLX'),('NAMAX.MLX') NEW
RETURN NIL

Function BukaR()
USE "TRIN.DTR" INDEX ('BPBX.ELX'),('TGLINX.ELX') NEW
USE "TRSTK.DTR" INDEX ('BUKTIX.ELX'),('TGLSTKX.ELX') NEW
USE "HT.DTR" INDEX ('NOHTX.ELX'),('Tglhtx.elx') new
USE "TRHT.DTR" INDEX ('NOBYRX.ELX'),('TGLBYRX.ELX') NEW
USE "TRSS.DTR" INDEX ('TGLSSX.ELX') NEW
USE "TROUT.DTR" INDEX ('Faktur.Elx'),('TGLOUTX.ELX') NEW
USE "TRPT.DTR" INDEX ('NOTRPUT.ELX'),('TGLBYRPT.ELX') NEW
USE "PUT.DTR" INDEX ('NOPUT.ELX'),('TGLPTX.ELX') NEW
USE "STK.DMT" INDEX ('STKX.MLX'),('GRPX.MLX'),('NAMABRG.MLX') NEW
USE "PMSK.DMT" INDEX ('PMSKX.MLX'),('NAMAPMSK.MLX') NEW
USE "LGN.DMT" INDEX ('LGN.MLX'),('NAMAX.MLX') NEW
Return Nil

Function BukaHS()
USE "TRSTK.DTR" INDEX ('BUKTIX.ELX'),('TGLSTKX.ELX') NEW
USE "TRSS.DTR" INDEX ('TGLSSX.ELX') NEW
USE "TROUT.DTR" INDEX ('Faktur.Elx'),('TGLOUTX.ELX') NEW
USE "STK.DMT" INDEX ('STKX.MLX'),('GRPX.MLX'),('NAMABRG.MLX') NEW
USE "REKAP.TMP" INDEX ('KODE1.TMP'),('TGL1.TMP')  NEW
Return Nil

Function BukaHU()
USE "HT.DTR" INDEX ('NOHTX.ELX'),('Tglhtx.elx') new
USE "TRHT.DTR" INDEX ('NOBYRX.ELX'),('TGLBYRX.ELX') NEW
USE "TRPT.DTR" INDEX ('NOTRPUT.ELX'),('TGLBYRPT.ELX') NEW
USE "PUT.DTR" INDEX ('NOPUT.ELX'),('TGLPTX.ELX') NEW
USE "PMSK.DMT" INDEX ('PMSKX.MLX'),('NAMAPMSK.MLX') NEW
USE "LGN.DMT" INDEX ('LGN.MLX'),('NAMAX.MLX') NEW
USE "REKAP.TMP" INDEX ('KODE1.TMP'),('TGL1.TMP')  NEW
Return Nil

FUNCTION REKAP() //15
   USE "REKAP.TMP" INDEX ('KODE1.TMP'),('TGL1.TMP')  NEW
RETURN (NIL)

If !File('sandi.dsd')
   dbcreate('sandi.dsd',{{'Sandi1   ', 'C',10, 0},;
                         {'Sandi2   ', 'C',10, 0},;
                         {'Sandi3   ', 'C',10, 0},;
                         {'Sandi4   ', 'C',10, 0},;
                         {'Sandi5   ', 'C',10, 0}})
  use Sandi.dsd new shared
  dbappend()
  if Reclock()
     Replace Sandi1 with '1        ',Sandi2 with '2          ',;
             Sandi3 with '3        ',Sandi4 with '4          ',;
             Sandi5 with '5        '
     dbcommit()
     unlock
  endif
  dbcloseall()
Endif

FUNCTION SandiS(lShared)
local X
local MScreen:=savescreen(), MColor:=setcolor()
Default lShared to .T.
dbopen('Sandi.dsd',,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbopen('Sandi.dsd',,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.


// CREATE NEW DATABASE FOR USER -------------------------
FUNCTION BARU()
// PENYESUAIAN ------------------------------------------
IF !FILE('TRSS.DTR')
   dbcreate('TRSS.DTR',{{'TGLSS  ', 'D',8, 0},;
                        {'BUKTI  ', 'C',6, 0},;
                        {'STATUS ', 'C',5, 0},;
                        {'QTT    ', 'N',6, 0},;
                        {'KODBRG ', 'C',10,0},;
                        {'HARGA  ', 'N',9 ,0},;
                        {'KET    ', 'C',15,0}})
ENDIF
IF !FILE('TGLSSX.ELX')
  USE TRSS.DTR
  JINDEX('TLGSSX.ELX')
  INDEX ON TGLSS TO ('TGLSSX.ELX') EVAL FINDEX()
  CLOSE ALL
ENDIF

// MASUK HUTANG ------------------------------------------------
IF !FILE('TRIN.DTR')
   dbcreate('TRIN.DTR',{{'TGLIN  ', 'D',8, 0},;
                        {'NOBPB  ', 'C',8, 0},;
                        {'QTT    ', 'N',6, 0},;
                        {'SISA   ', 'N',6, 0},;
                        {'KODBRG ', 'C',10,0},;
                        {'HARGA  ', 'N',9, 0}})
ENDIF
IF !FILE('BPBX.ELX')
  USE "TRIN.DTR"
  JINDEX('BPBX.ELX')
  INDEX ON NOBPB TO ('BPBX.ELX') EVAL FINDEX()
  CLOSE ALL
ENDIF

IF !FILE('TGLINX.ELX')
  USE "TRIN.DTR"
  JINDEX('TGLINX.ELX')
  INDEX ON TGLIN TO ('TGLINX.ELX') EVAL FINDEX()
  CLOSE ALL
ENDIF

IF !FILE('TRstk.DTR')
   dbcreate('TRSTK.DTR',{{'TGLIN  ', 'D',8, 0},;
                         {'BUKTI  ', 'C',8, 0},;
                         {'NOBPB  ', 'C',8, 0},;
                         {'QTT    ', 'N',6, 0},;
                         {'KODBRG ', 'C',10,0},;
                         {'HARGA  ', 'N',9, 0}})
ENDIF
IF !FILE('Buktix.ELX')
  USE "TRSTK.DTR"
  JINDEX('BUKTIX.ELX')
  INDEX ON BUKTI TO ('BUKTIX.ELX') EVAL FINDEX()
  CLOSE ALL
ENDIF

IF !FILE('TGLSTKX.ELX')
  USE "TRSTK.DTR"
  JINDEX('TGLSTKX.ELX')
  INDEX ON TGLIN TO ('TGLSTKX.ELX') EVAL FINDEX()
  CLOSE ALL
ENDIF

// KELUAR ------------------------------------------------
IF !FILE('TROUT.DTR')
   dbcreate('TROUT.DTR',{{'TGLOUT   ', 'D',8 , 0},;
                         {'FAKTUR   ', 'N',5 , 0},;
                         {'MOBIL    ', 'C',20, 0},;
                         {'KODBRG   ', 'C',10, 0},;
                         {'QTT      ', 'N',9 , 0},;
                         {'HARGA    ', 'N',9 , 0},;
                         {'HARGAT   ', 'N',9 , 0},;
                         {'MUKA     ', 'N',9 , 0},;
                         {'KODELGN  ', 'C',3 , 0}})
ENDIF

IF !FILE('Faktur.ELX')
   USE "TROUT.DTR"
   JINDEX('Faktur.Elx')
   INDEX ON Faktur TO ('Faktur.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('TGLOUTX.ELX')
   USE "TROUT.DTR"
   JINDEX('TGLOUTX')
   INDEX ON TGLOUT TO ('TGLOUTX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// HUTANG -----------------------------------------------
IF !FILE('HT.DTR')
   dbcreate('ht.DTR',{{'TGLIN    ', 'D',8 , 0},;
                        {'NOBPB    ', 'C',8 , 0},;
                        {'kodPMSk  ', 'C',3 , 0},;
                        {'JMLHT    ', 'N',12, 0},;
                        {'TGLBYR   ', 'D',8 , 0},;
                        {'STATUS   ', 'C',1 , 0},;
                        {'TUNAI    ', 'N',12, 0}})
ENDIF

IF !FILE('TGLHTX.ELX')
   USE "HT.DTR"
   JINDEX('TGLHTX.ELX')
   INDEX ON TGLIN TO ('TGLHTX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('NOHTX.ELX')
   USE "HT.DTR"
   JINDEX('NOHTX')
   INDEX ON NOBPB TO ('NOHTX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// PIUTANG -----------------------------------------------
IF !FILE('PUT.DTR')
   dbcreate('PUT.DTR',  {{'TGLOUT    ', 'D',8 , 0},;
                         {'FAKTUR   ', 'N',5 , 0},;
                         {'NAMA     ', 'C',15, 0},;
                         {'JMLPT    ', 'N',12, 0},;
                         {'TGLBYR   ', 'D',8 , 0},;
                         {'SISA     ', 'N',9 , 0},;
                         {'GIRO     ', 'N',12, 0},;
                         {'TUNAI    ', 'N',12, 0},;
                         {'STATUS   ', 'C',1 , 0},;
                         {'KODELGN  ', 'C',3 , 0}})
ENDIF

IF !FILE('TGLPTX.ELX')
   USE "PUT.DTR"
   JINDEX('TGLPTX.ELX TGLPT')
   INDEX ON TGLOUT TO ('TGLPTX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('NOPUT.ELX')
   USE "PUT.DTR"
   JINDEX('NOPUT.ELX')
   INDEX ON FAKTUR TO ('NOPUT.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// BYRHUTANG ----------------------------------------------
IF !FILE('TRHT.DTR')
   dbcreate('TRHT.DTR', {{'TGLHT    ', 'D',8 , 0},;
                         {'NOBPB    ', 'C',8 , 0},;
                         {'kodpmsk  ', 'C',3 , 0},;
                         {'JMLHT    ', 'N',12, 0},;
                         {'TGLBYR   ', 'D',8 , 0},;
                         {'BANK     ', 'C',15, 0},;
                         {'GIRO     ', 'N',12, 0},;
                         {'TUNAI    ', 'N',12, 0},;
                         {'TGLGR    ', 'D',8 , 0}})
ENDIF

IF !FILE('NOBYRX.ELX')
   USE "TRHT.DTR"
   JINDEX('NOBYRX.ELX')
   INDEX ON NOBPB TO ('NOBYRX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('TGLBYRX.ELX TGLBYR')
   USE "TRHT.DTR"
   JINDEX('TGLBYRX.ELX')
   INDEX ON TGLBYR TO ('TGLBYRX.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// BYRPIUTANG ---------------------------------------------
IF !FILE('TRPT.DTR')
   dbcreate('TRPT.DTR', {{'TGLOUT    ', 'D',8 , 0},;
                         {'FAKTUR   ', 'N',5 , 0},;
                         {'KODELGN  ', 'C',3 , 0},;
                         {'TGLBYR   ', 'D',8 , 0},;
                         {'BANK     ', 'C',15, 0},;
                         {'GIRO     ', 'N',12, 0},;
                         {'TUNAI    ', 'N',12, 0}})
ENDIF

IF !FILE('TGLBYRPT.ELX')
   USE "TRPT.DTR"
   JINDEX('TGLBYRPT.ELX TGLPT')
   INDEX ON TGLBYR TO ('TGLBYRPT.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('NOTRPUT.ELX')
   USE "TRPT.DTR"
   JINDEX('NOTRPUT.ELX')
   INDEX ON FAKTUR TO ('NOTRPUT.ELX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// DATABASE MASTER ---------------------------------------
// ---------------------------- 1 -------------------------
IF !FILE('PMSK.DMT')
   dbcreate('PMSK.DMT',{{'KODPMSK  ', 'C',3 , 0},;
                        {'NAMA     ', 'C',25, 0},;
                        {'ALAMAT   ', 'C',32, 0},;
                        {'TELP     ', 'C',15, 0},;
                        {'TOTALHT  ', 'N',12, 0}})
ENDIF

IF !FILE('PMSKX.MLX')
  USE "PMSK.DMT"
  JINDEX('PMSKX.MLX')
  INDEX ON KODPMSK TO ('PMSKX.MLX') EVAL FINDEX()
  CLOSE ALL
ENDIF

IF !FILE('NAMAPMSK.MLX')
  USE "PMSK.DMT"
  JINDEX('PMSKX.MLX')
  INDEX ON NAMA TO ('NAMAPMSK.MLX') EVAL FINDEX()
  CLOSE ALL
ENDIF

// ---------------------------- 2 -------------------------
IF !FILE('STK.DMT')
   dbcreate('STK.DMT',{{'KODBRG   ', 'C',10, 0},;
                        {'NAMA     ', 'C',20, 0},;
                        {'QTT      ', 'N',6 , 0},;
                        {'HARGA    ', 'N',9, 0},;
                        {'MIN      ', 'N',3 , 0},;
                        {'GRP      ', 'C',6 , 0}})
   USE "STK.DMT"
   USE
ENDIF

IF !FILE('STKX.MLX')
   USE "STK.DMT"
   JINDEX('STKX.MLX')
   INDEX ON KODBRG TO ('STKX.MLX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('GRPX.MLX')
   USE "STK.DMT"
   JINDEX('GRPX.MLX')
   INDEX ON GRP TO ('GRPX.MLX') EVAL FINDEX()
   CLOSE ALL
ENDIF

IF !FILE('NAMABRG.MLX')
   USE "STK.DMT"
   JINDEX('GRPX.MLX')
   INDEX ON NAMA TO ('NAMABRG.MLX') EVAL FINDEX()
   CLOSE ALL
ENDIF

// ---------------------------- 4 -------------------------
IF !FILE('LGN.DMT')
   dbcreate('LGN.DMT', {{'KODELGN  ', 'C',3 , 0},;
                        {'NAMA     ', 'C',40, 0},;
                        {'ALAMAT   ', 'C',40, 0},;
                        {'ALAMAT2  ', 'C',40, 0},;
                        {'ALAMAT3  ', 'C',25, 0},;
                        {'NPWP     ', 'C',30, 0},;
                        {'TELP     ', 'C',15, 0},;
                        {'TOTALUT  ', 'N',12, 0}})
ENDIF

IF !FILE('LGN.MLX')
  USE "LGN.DMT"
  JINDEX('LGN.MLX')
  INDEX ON KODELGN TO ('LGN.MLX') EVAL FINDEX()
  CLOSE ALL
ENDIF

IF !FILE('NAMAX.MLX')
    USE "LGN.DMT"
    JINDEX('NAMAX.MLX')
    INDEX ON NAMA TO ('NAMAX.MLX') EVAL FINDEX()
    CLOSE ALL
ENDIF

IF !FILE('Kas.DBF')
   dbcreate('Kas.DBF', {{'Tglout   ', 'D',8 , 0},;
                        {'Faktur   ', 'C',8 , 0},;
                        {'Kode     ', 'C',3 , 0},;
                        {'URAIAN   ', 'C',40, 0},;
                        {'DEBIT    ', 'N',12, 0},;
                        {'KREDIT   ', 'N',12, 0},;
                        {'Jumlah   ', 'N',12, 0}})
ENDIF

IF !FILE('Nokas.ELX')
  USE "KAS.DBF" new exclusive
  If neterr()
      Berita(15,30,' File terkunci  ulangi Index ...........','w/r')
   else
      JINDEX('NOKAS.ELX')
      INDEX ON Faktur TO ('Nokas.ELX') EVAL FINDEX()
  endif
  CLOSE ALL
ENDIF

IF !FILE('TGLkas.ELX')
  USE "KAS.DBF" new exclusive
  If neterr()
      Berita(15,30,' File terkunci  ulangi Index ...........','w/r')
   else
      JINDEX('TglKAS.ELX')
      INDEX ON Tglout TO ('TGlkas.ELX') EVAL FINDEX()
  endif
  CLOSE ALL
ENDIF

IF !FILE('ACC.DMT')
   dbcreate('ACC.DMT', {{'KODACC   ', 'C',5 , 0},;
                        {'JUMLAH   ', 'N',15, 0},;
                        {'URAIAN   ', 'C',20, 0}})
  use acc.dmt new shared
  If Reclock()
     dbappend()
     Replace Kodacc with '001  ',Uraian with 'KAS KECIL ...'
     dbcommit()
     unlock
  endif
  If Reclock()
     dbappend()
     Replace Kodacc with '11111',URAIAN WITH 'BANK.....'
     dbcommit()
     unlock
  endif
  dbcloseall()
ENDIF

IF !FILE('KODACC.MLX')
  USE "ACC.DMT" new exclusive
  If neterr()
      Berita(15,30,' File terkunci  ulangi Index ...........','w/r')
   else
      JINDEX('ACC.MLX')
      INDEX ON KODACC TO ('KODACC.MLX') EVAL FINDEX()
  endif
  CLOSE ALL
ENDIF

If !File('NKAS.dMT')
   dbcreate('NKAS.dMT',{{'Nomor   ', 'N',5, 0}})
  use NKAS.DMT new shared
  dbappend()
  if Reclock()
     Replace Nomor with 1
     dbcommit()
     unlock
  endif
  dbcloseall()
Endif

// ---------------------------- 6 -------------------------
IF !FILE('REKAP.TMP')
   dbcreate('REKAP.TMP',{{'KODE1   ', 'C',10, 0},;
                        {'KODE2    ', 'C',3 , 0},;
                        {'nobpb    ', 'C',8 , 0},;
                        {'TGL1     ', 'D',8 , 0},;
                        {'QTT      ', 'N',15, 0},;
                        {'CATAT    ', 'C',25, 0},;
                        {'HARGA    ', 'N',15, 0},;
                        {'HARGA1   ', 'N',15, 0},;
                        {'HARGA2   ', 'N',15, 0},;
                        {'HARGA3   ', 'N',15, 0},;
                        {'HARGA4   ', 'N',15, 0},;
                        {'HARGA5   ', 'N',15, 0}})
ENDIF

IF !FILE('KODE1.TMP')
   USE "REKAP.TMP"
   INDEX ON KODE1 TO ('KODE1.TMP')
   CLOSE ALL
ENDIF

IF !FILE('KODE2.TMP')
   USE "REKAP.TMP"
   INDEX ON KODE2 TO ('KODE2.TMP')
   CLOSE ALL
ENDIF

IF !FILE('TGL1.TMP')
   USE "REKAP.TMP"
   INDEX ON TGL1 TO ('TGL1.TMP')
   CLOSE ALL
ENDIF
RETURN NIL

func RecLock()
local MScreen:=savescreen(), MColor:=setcolor(),;
      nRow:=row(),nCol:=Col()
do while ! rlock()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba me-lock file..., tekan ESC untuk membatalkan!"
   X:=inkey()
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      SetPos(nrow,ncol)
      return .F.
   endif
enddo
restscreen(,,,,MScreen)
setcolor(MColor)
SetPos(nrow,ncol)
return .T.

***************************** -9- *************************************
FUNCTION LGNS(lShared)
local X
local MScreen:=savescreen(), MColor:=setcolor()
Local aIdx:={'LGN.MLX','NAMAX.MLX'}
Default lShared to .T.
dbOpen("LGN.DMT",aidx,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbOpen("LGN.DMT",aidx,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.

***************************** -10- *************************************
FUNCTION KASS(lshared)
local X
local MScreen:=savescreen(), MColor:=setcolor()
Local aIdx:={'nokas.elx','tglkas.elx'}
Default lShared to .T.
dbOpen('kas.dbf',aidx,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbOpen('kas.dbf',aidx,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.

FUNCTION ACCs(lshared)
Local X
Local MScreen:=savescreen(), MColor:=setcolor()
Local aIdx:={'KodAcc.mlx'}
Default lShared to .T.
DbOpen('Acc.dmt',aidx,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbOpen('Acc.dmt',aidx,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.

***************************** -14- *************************************
FUNCTION NKASS(lShared)
local X
local MScreen:=savescreen(), MColor:=setcolor()
Default lShared to .T.
dbopen('NKAS.dMT',,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbopen('NKAS.dMT',,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.

***************************** -11- *************************************
FUNCTION REKAPe(lShared)
local X
local MScreen:=savescreen(), MColor:=setcolor(),i,test:=1
Local aIdx:={'KODE1.TMP','TGL1.TMP'}
Default lShared to .T.
dbOpen('Rekap.Tmp',aidx,lShared,1)
do while neterr()
   do SBox with 10,10,13,70,"w*+/b"
   @11,15 say "File sedang di-lock user lain."
   @12,15 say "Mencoba membuka file..., tekan ESC untuk membatalkan!"
   dbOpen('Rekap.Tmp',aidx,lShared,1)
   X:=inkey(5)
   if X=K_ESC
      restscreen(,,,,MScreen)
      setcolor(MColor)
      return .F.
   endif
enddo
return .T.