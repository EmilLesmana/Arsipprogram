*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Out.prg                    *
* For Output to Penjualan                 *
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
Static aTmp
Static mMuka
Static mJumlah

Function Btlout()
local ob
Local x,nBrs,nCol
Local mJud,mTpl,c
Private nElemen
nelemen:=1

geser(2)
buka2()
While .t.
_mHeader()
_mHelp()
sele Keluar
Set Relation to Kodbrg into Stk
Editheader()
   IF cFAKTUR ==space(8)
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
c:Colorblock:={||If(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')})
c:Colorblock:={||If(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 9,999,999')})
c:Colorblock:={||If(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[NELEMEN,3]*aTmp[nElemen,4],'@e 999,999,999')})
c:Colorblock:={||If(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
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
   X:=EVAL({||Putar(1,23,'  Batal Penjualan  ','gr+/bg')})
   Devpos(nBrs,nCol)
   _u:=0
   aEval(aTmp,{|e,_au|_u:=if(aTmp[_au,6] # 'F',_u+aTmp[_au,3]*aTmp[_au,4],_u)})
   @18,57 say _u pict apict[5]
   IF X == 7
      if(aTmp[nelemen,6] # 'F',aTmp[nelemen,6]:='F',aTmp[nelemen,6]:='T')
      _u:=0
      aEval(aTmp,{|e,_au|_u:=if(aTmp[_au,6] # 'F',_u+aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,57 say _u pict apict[5]
      ob:refreshall()
   endif

   If x == 42
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
Putar(1,23,'  Batal Penjualan  ','gr+/bg')
@4,2 SAY ' Tanggal : '
@3,2 SAY ' Faktur  : '
@5,2 SAY ' Kod Lgn : '

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
dDate:=Date()
WHILE .T.
   cFaktur:=space(8)
   setcolor('n/w,n/w')
   @3,14 get cFaktur pict '@!'
   read
   IF CfAKTUR == space(8)
      RETURN NIL
   ENDIF
   Sele Keluar
   seek cFaktur
   If !Found()
      Berita(5,39,' No Faktur tidak ditemukan, Ganti Nomor Lain .... ','g/n')
      loop
   else
      dDate:=Tglout
   endif
   @4,14 say dDate
   @5,14 say kodeLgn
   mMuka:=Muka
   SELE Lgn
   IF !fFound(6,39,Keluar->KODelgn,'gr+/bg')
       LOOP
   ENDIF
      setcolor('n/w,n/w')
      @3,50 SAY nama
      @4,50 SAY padr(ALAMAT,25)
   SELE Piutang
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglpt .and. ! Eof()
        skip
   enddo

   If cFaktur==Faktur .and. dDate==Tglpt
   If Tunai+Giro # mMuka
      Berita(5,39,' Faktur sudah dibayar, batalkan pembayaran dulu ... ','g/n')
      cFaktur:=0
      Return ( Nil )
   endif
   endif

   Sele Keluar
   Set Relation to Kodbrg into stk
   aTmp:={}
   While cFaktur == Faktur .and. dDate == Tglout .and. ! Eof()
      aAdd(aTmp,{Kodbrg,if(kodbrg#'003       ',stk->nama,mobil),qtt,harga,0,' '})
      skip
   enddo
   seek cFaktur
   mJumlah:=0
   aEval(aTmp,{|e,_au|mJumlah+=aTmp[_au,3]*aTmp[_au,4]})
   @18,57 say mJumlah pict apict[5]
   exit
ENDDO
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:='Delete -> Pembatalan  '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Proses'
@23,0 say padc(cData,80)
return (nil)



// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j

for j:=1 to len(aTmp)

   //Kurangi Stok Gudang
   sele stk
   If aTmp[j,6] == 'F'
   dbseek(aTmp[j,1])
   if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
      aTmp[j,1] # '003       '
      REPLACE Qtt WITH Qtt+aTmp[j,3]
   endif
   endif

   // Rekam Data Transaksi
   SELE Keluar
   If aTmp[j,6] == 'F'
      delete
   endif
    skip
next
Return (nil)

// proses uang muka
Static Function _Hutang()
**************************************************************************
Local Jumlah
_u:=0
aEval(aTmp,{|e,_au|_u:=if(aTmp[_au,6] # 'F',_u+aTmp[_au,3]*aTmp[_au,4],_u)})
@18,57 say _u pict apict[5]
jumlah:=_u - mMuka
If Jumlah < 0
   Jumlah:=0
endif

@19,57 say MMUKA PICT '@E 99,999,999'
setcolor('w/r')
@20,57 SAY Jumlah PICT '@E 99,999,999'
SELE Lgn
REPLACE TOTALUT WITH TOTALUT - ((mJumlah-mMuka) - Jumlah)

SELE Piutang
seek dDate
While cFaktur # Faktur .and. dDate == Tglpt .and. ! Eof()
    skip
enddo
if _u == 0
   delete
else
   REPLACE JMLPT WITH jmlpt - (mJumlah - _u)
endif

Return (Nil)
