*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : In.prg                     *
* For Input Pembelian                     *
*******************************************
memvar getlist
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,Tglin,MUKA,TUNAI,;
      TGLHT,KODPMS,STATUS,QMTR,QYDS,QPCS,HARGA,TOTALHT
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@e 99,999,999'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static elemen1
sTATIC aTmp
Static mMuka
Static mJumlah

Function Btlin()
local ob,c
Local x,nBrs,nCol
Local mJud,mTpl
Private nElemen
nelemen:=1

geser(1)
buka1()
While .t.
_mHeader()
_mHelp()
sele Masuk
Editheader()
   IF cFaktur=space(8)
      CLOSE ALL
      RETURN nil
   ENDIF

//aAdd(aTmp,{space(10),space(20),0,0,0})
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
OB:=TBROWSENEW(7,2,16,70)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}

// Add to Objeck Colom
ob:Colorspec:='gr+/b,g/n,w/r,g/n'
c:=TBCOLUMNNEW(' Kode Brg ',{||Tran(aTmp[nelemen,1],'@!')})
c:Colorblock:={||If(aTmp[nElemen,7] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')})
c:Colorblock:={||If(aTmp[nElemen,7] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,7] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 9,999,999')})
c:Colorblock:={||If(aTmp[nElemen,7] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:Colorblock:={||If(aTmp[nElemen,7] # 'F',{1,2},{3,4})}
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[NELEMEN,3]*aTmp[nElemen,4],'@e 999,999,999')})
OB:ADDCOLUMN(c)

OB:HEADSEP:='мям'
OB:COLSEP:= ' Ё '
OB:FOOTSEP:='мом'

WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif

   setcolor('R/bg')
   Showind(ob,len(aTmp),nElemen,17,71)
   X:=EVAL({||Sakti(1,23,'  Batal Pembelian  ','gr+/bg')})
   Devpos(nBrs,nCol)

   _u:=0
   aEval(aTmp,{|e,_au|_u:=If(aTmp[_au,7] == 'F',_u,_u + aTmp[_au,3]*aTmp[_au,4])})
   @18,57 say _u pict apict[5]
   IF X == 7
      If(aTmp[nElemen,7] # 'F',aTmp[nElemen,7]:='F',aTmp[nElemen,7]:='T')
      _u:=0
      aEval(aTmp,{|e,_au|_u:=If(aTmp[_au,7] == 'F',_u,_u + aTmp[_au,3]*aTmp[_au,4])})
      @18,57 say _u pict apict[5]
      ob:refreshall()
   endif

   If x == 42
      _u:=0
      aEval(aTmp,{|e,_au|_u:=If(aTmp[_au,7] == 'F',_u,_u + aTmp[_au,3]*aTmp[_au,4])})
      @18,57 say _u pict apict[5]
      traRtoFi(aTmp)
      _Hutang()
      Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      EXIT
   endif
   KEY(X,OB)
END
Enddo
return(nil)

Static Function _mheader()
**************************************************************************
// HEADER FORM
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,44,'r/bg')
Keyboard(chr(13))
Putar(1,23,'  Batal Pembelian  ','gr+/bg')
@3,2 SAY ' No.Bpb  : '
@4,2 SAY ' Tanggal : '
@5,2 SAY ' Kod PMSK: '

@3,39 SAY ' Nama   : '
@4,39 SAY ' Alamat : '

// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
sbox(17,37,21,71,'GR+/B,W/R')
@18,38 say ' Jumlah   :Rp.'
@19,38 say ' Bayar    :Rp.'
@20,38 say ' Sisa     :Rp.'
@22,5 say ' Stok Gudang = '
Return (nil)

Static Function EditHeader()
**************************************************************************
WHILE .T.
   aTmp:={}
   cFaktur:=space(8)
   setcolor('n/w,n/w')
   @3,14 get cFaktur pict '@!'
   READ
   Sele Masuk
   IF cFaktur=space(8)
      CLOSE ALL
      RETURN nil
   endif
   seek cFaktur
   IF !Found()
      berita(5,39,' Nomor tidak ditemukan, Ganti Nomor Lain .... ','gr+/bg')
      LOOP
   ELSE
      sele trstk
      set order to 2
      seek cFaktur
      If Found()
         berita(5,39,' Pemasukan sudak dilakukan, batalkan pemasukan barang ... ','gr+/bg')
         close all
         cFaktur:=space(8)
         return nil
      endif
      sele masuk
      dDate:=Tglin
      @4,14 say dDate pict '@!'
      @5,14 say PMS pict '@!'
      SELE PMSK
      IF !fFound(6,39,Masuk->PMS,'gr+/bg')
         LOOP
      ENDIF
      setcolor('n/w,n/w')
      @3,50 SAY nama
      @4,50 SAY padr(ALAMAT,25)
   endif
   Sele Masuk
   mMuka:=muka
   SELE Hutang
   set order to 2
   seek cFaktur
   If Tunai+Giro # mMuka
      berita(5,39,' Faktur sudah dibayar, batalkan pembayaran dulu ... ','gr+/bg')
      cFaktur:=space(8)
      Return( nil )
   endif
   Sele Masuk
   set Relation to Kodbrg into stk
   aTmp:={}
   While cFaktur == Nobpb .and. !Eof()
      aAdd(aTmp,{Kodbrg,stk->nama,Qtt,Harga,0,Sisa,' '})
      skip
   enddo
mJumlah:=0
aEval(aTmp,{|e,_au|mJumlah+=aTmp[_au,3]*aTmp[_au,4]})
   exit
ENDDO
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:=' DELETE -> PEMBATALAN   '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Proses '
@24,0 say padc(cData,80)
return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
lOCAL J

Sele Masuk
seek cFaktur
for j:=1 to len(aTmp)
    sele stk
    If aTmp[j,7] == 'F'
       dbseek(aTmp[j,1])
       Replace qtt with qtt-aTmp[j,3]
    endif
    sele masuk
    If aTmp[j,7] == 'F'
       Delete
    endif
    masuk->(dbskip(1))
next
Return (nil)

// proses uang muka
Static Function _Hutang()
**************************************************************************
Local Jumlah
_u:=0
aEval(aTmp,{|e,_au|_u:=If(aTmp[_au,7] == 'F',_u,_u + aTmp[_au,3]*aTmp[_au,4])})
@18,57 say _u pict apict[5]
Jumlah:=_u - mMuka
If Jumlah < 0
   Jumlah:=0
endif
SELE PMSK
REPLACE TOTALHT WITH TOTALHT - ((mJumlah-mMuka)-Jumlah)
SELE Hutang
If _u == 0
   delete
else
   REPLACE JMLHT WITH Jmlht - (mJumlah - _u)
endif

@19,57 say MMUKA PICT '@E 99,999,999'
setcolor('w/r')
@20,57 SAY Jumlah PICT '@E 99,999,999'
Return (Nil)