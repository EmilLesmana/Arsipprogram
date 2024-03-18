static x
static ddate
static tglawal
static tglakhir
static nsakhir
#include 'ee.int'

Function LKas()
* program LIHAT
LOCAL I,PIL,TEKS1,ER,HAL,BR,TOT
//PRIVATE TGLAWAL
dbcloseall()
If !KasS()
   Return nil
Endif

If !AccS()
   Return nil
endif

use rekap.tmp index 'kode1.tmp','tgl1.tmp' new
SELE REKAP
ZAP

 SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT

Sele Acc
SET COLOR TO GR,W/N
@5,10 SAY 'Posisi Kas Hari ini->Rp.'+Tran(Jumlah,'@e 99,999,999,999')
TGLAWAL  := CTOD(' // ')
TGLAKHIR := CTOD(' // ')
@ 6,7 SAY '  TANGGAL : 'GET TGLAWAL
@ 6,28 SAY '   SAMPAI'
@ 6,38 SAY '   TANGGAL :'GET TGLAKHIR
READ
dTglawal:=tglawal
ddate:=date()
IF TGLAKHIR=CTOD(' / / ')
   TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @6,51 SAY TGLAKHIR
ENDIF



// ************************ Perhitungan Neraca / General Ledger **************
sele kas
nSawal:=DSblini:=KSblini:=DSbljln:=KSbljln:=Dakhir:=Kakhir:=nSakhir:=0
dbgotop()
While !Eof()
      If Tglout<Tglawal
         DSblini+=debit
         KSblini+=kredit
      elseif tglout>=tglawal .and. Tglout<Tglakhir
         DSbljln+=debit
         KSbljln+=kredit
      elseif Tglout>=tglakhir
         Dakhir+=Debit
         Kakhir+=kredit
      endif
  dbskip()
enddo

nSAwal:=DSblini-KSblini
nSAkhir:=nSawal+(DSbljln-KSbljln)+(Dakhir-Kakhir)
Sele Rekap
dbappend()
Replace Catat with 'Saldo Sebelumnya ........',Harga3 with nSawal

Sele Kas
set order to 2
IF !caritgl(Tglawal)
   KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
   CLOSE ALL
   Return (nil)
ENDIF
While Tglout<=Tglakhir .and. !Eof()
   Sele Rekap
   dbappend()
   Replace TGL1 WITH KAS->TGLOUT,nobpb with kas->Faktur,Catat with Kas->Uraian,Harga1 with Kas->Debit,Harga2 with Kas->Kredit
   Sele kas
   dbskip()
Enddo
Sele Rekap
dbgotop()
nTot:=harga3
dbskip()
While !eof()
  Replace harga3 with ntot+(Harga1-harga2)
  ntot:=harga3
  dbskip()
Enddo
dbappend()
REPLACE CATAT WITH 'Saldo akhir ',HARGA3 WITH nSakhir
DBGOTOP()

*************************************************************************
ER:=.N.
 SET COLOR TO W+/R+
 @1,1 SAY ' APAKAH DATA AKAN DICETAK ?(Y/N) 'GET ER PICT 'Y'
 SET COLOR TO
 READ

IF ER
   IF !CEKPRINT()
      CLOSE ALL
      return nil
   ENDIF
   Cetak()
ELSE
   cBrowse()
ENDIF
RETURN NIL

static Function Cetak()
@1,40 say Pbesar+'BUKU KAS'+Nbesar
@2,7 say ' Tanggal : '+tran(tglawal,'@d')+' S/D  tanggal :'+tran(tglakhir,'@d')
sDate(3,7,dDate)
@4,7 say '-------------------------------------------------------------------------------'
@6,7 say '|            Uraian                 |     masuk   |   keluar    |   Akhir     |'
@7,7 say '-------------------------------------------------------------------------------'
br:=8
nJum:=0
nJum1:=0
While !Eof()
@br,7 say '|'+Padc(Catat,35)+'|'+Tran(harga1,'@e 9,999,999,999')+;
   '|'+Tran(harga2,'@e 9,999,999,999')+'|'+Tran(harga3,'@e 9,999,999,999')+'|'
   nJum+=Harga1
   nJum1+=Harga2
   br++
 If Br==66
@br,7 say '-------------------------------------------------------------------------------'
@br+1,8 SAY 'Masuk Rp.'+tRAN(nJUM,'@E 9,999,999,999')+' | '+'KELUAR Rp.'+;
            tRAN(nJUM1,'@E 9,999,999,999')+' | '
    @br+2,0 SAY ''
    SETPRC(0,0)
    ?? chr(18)
    SET PRINT OFF
    SET DEVICE TO SCREEN
    KOMENTAR(5,30,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
        sele acc
    if Reclock()
       replace jumlah with nsakhir
       dbcommit()
       unlock
     endif
    dbcloseall()
        Return (nil)
    ENDIF
@1,40 say Pbesar+'BUKU KAS'+Nbesar
@2,7 say ' Tanggal : '+tran(tglawal,'@d')+' S/D  tanggal :'+tran(tglakhir,'@d')
sDate(3,7,dDate)
@4,7 say '-------------------------------------------------------------------------------'
@6,7 say '|            Uraian                 |     masuk   |   keluar    |   Akhir     |'
@7,7 say '-------------------------------------------------------------------------------'
br:=8
 endif
skip
enddo
@br,7 say '-------------------------------------------------------------------------------'
    @br+1,8 SAY 'Masuk Rp.'+tRAN(nJUM,'@E 9,999,999,999')+' | '+'KELUAR Rp.'+;
            tRAN(nJUM1,'@E 9,999,999,999')+' | '
    @br+2,0 SAY ''
    SETPRC(0,0)
    ?? chr(18)
    SET PRINT OFF
    SET DEVICE TO SCREEN
    KOMENTAR(5,30,' DATA HABIS, TEKAN SEMBARANG TOMBOL........ ')
    sele acc
    if Reclock()
       replace jumlah with nsakhir
       dbcommit()
       unlock
     endif
    dbcloseall()
Return nil


static Function cbrowse()
local tabel,njum,njum1
TABEL:=TBROWSEDB(5,2,20,75)
sele rekap
DISPBEGIN()
NJUM:=NJUM1:=0
WHILE .NOT. EOF()
NJUM+=HARGA1
NJUM1+=HARGA2
SKIP
ENDDO
DBGOTOP()
SET COLOR TO W/N
@0,0,24,79 BOX REPLI(CHR(178),79)
setcolor("gr+/n")
@ 1,2 SAY 'ÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ BUKU KAS ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝ '
@2,01 say ' Tanggal : '
@2,COL() SAY tglawal
@2,COL() SAY ' S/D  tanggal :'
@2,COL() SAY tran(tglakhir,'@d')
sDate(3,1,dDate)
@23,2 SAY 'Masuk Rp.'+tRAN(nJUM,'@E 9,999,999,999')+' | '+'KELUAR Rp.'+;
            tRAN(nJUM1,'@E 9,999,999,999')+' | '
SBOX(4,1,21,76,'GR+/B,W/R')
DISPEND()
  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  C:=tbcolumnnew('Tanggal',{||Tran(Tgl1,'@d')})
  tabel:addcolumn(C)
  C:=tbcolumnnew('Faktur',{||Padc(nobpb,8)})
  //C:COLORBLOCK:={||IF(QTT<MIN,{3,4},{1,2})}
  tabel:addcolumn(C)
  C:=tbcolumnnew('URAIAN',{||CATAT})
  //C:COLORBLOCK:={||IF(QTT<MIN,{3,4},{1,2})}
  tabel:addcolumn(C)
  C:=tbcolumnnew(' MASUK ',{||TRAN(HARGA1,'@E 9,999,999,999')})
  //C:COLORBLOCK:={||IF(QTT<MIN,{3,4},{1,2})}
  tabel:addcolumn(C)
  C:=tbcolumnnew('KELUAR',{||TRAN(HARGA2,'@E 9,999,999,999')})
  //C:COLORBLOCK:={||IF(QTT<MIN,{3,4},{1,2})}
  tabel:addcolumn(C)
  C:=tbcolumnnew('SALDO AKHIR',{||TRAN(HARGA3,'@E 9,999,999,999')})
  //C:COLORBLOCK:={||IF(QTT<MIN,{3,4},{1,2})}
  tabel:addcolumn(C)
  SETCURSOR(0)
  TABEL:HEADSEP:='ÍÑÍ'
  TABEL:COLSEP:= ' ³ '
  tabel:footsep:='ÍÏÍ'
  //tabel:freeze:=1
  //tabel:colpos:=2
While .t.
     do while !tabel:stabilize()
     enddo
     IF TABEL:HITTOP .OR. TABEL:HITBOTTOM
        tone(200,1)
        tone(400,1)
     ENDIF
      mbrs:=row();mcol:=col()
      x:={||waktu()};x:=eval(x)
      @mbrs,mcol say ''
     if x==27
        SET CURSOR ON
        exit
     endif
     key(x,tabel)
enddo
sele acc
    if Reclock()
       replace jumlah with nsakhir
       dbcommit()
       unlock
     endif
    dbcloseall()
Return (nil)
