*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : In.prg                     *
* For Input Pembelian                     *
*******************************************
memvar getlist
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,Tglin,MUKA,TUNAI,;
      TGLHT,Sisa,Qtt,HARGA,TOTALHT,pms,jmlht
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@e 99,999,999'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static elemen1
sTATIC aTmp

Function Editin()
local ob
Local x,nBrs,nCol
Local mJud,mTpl,i
Private nElemen
nelemen:=1

geser(1)
buka1()
_mHeader()
_mHelp()
sele Masuk
Set Relation to Kodbrg into Stk
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
OB:ADDCOLUMN(TBCOLUMNNEW(' Kode Brg ',{||Tran(aTmp[nelemen,1],'@!')}))
OB:ADDCOLUMN(TBCOLUMNNEW(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')}))
OB:ADDCOLUMN(TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')}))
OB:ADDCOLUMN(TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 9,999,999')}))
OB:ADDCOLUMN(TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[NELEMEN,3]*aTmp[nElemen,4],'@e 999,999,999')}))

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
   X:=EVAL({||Sakti(1,21,'  Koreksi Pembelian   ','gr+/bg')})
   Devpos(nBrs,nCol)

   IF X==13
      if ob:colpos==ob:colcount()
         ob:panhome()
         loop
      endif

      if ob:colpos==2
         ob:right()
         ob:Refreshcurrent()
         loop
      endif
      cTmpData:=aTmp[nElemen,1]
      elemen1:=aTmp[nElemen,3]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      SELE STK
      if ob:colpos==1
      /*  *****  Periksa Pemasukan Jenis barang dalam satu Faktur *****  */
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            Set order to 2
            mJud:={'KODBRG','NAMA BARANG'}
            mTpl:={'KODBRG','NAMA'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
            Set order to 1
         ENDIF

    if len(aTmp) > 1

      if nElemen == len(aTmp)
      for i:=1 to len(aTmp)-1
      if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
         Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
         aTmp[nElemen,1]:=cTmpData
         if cTmpData == space(10)
            ob:up()
         endif
         ob:Refrescurrent()
         loop
      endif
      Next i

      else

      for i:=nElemen+1 to len(aTmp)
      if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
         Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
         aTmp[nElemen,1]:=cTmpData
         ob:Refreshcurrent()
         loop
      endif
      next i

      for i:=1 to nElemen-1
      if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
         Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
         aTmp[nElemen,1]:=cTmpData
         ob:Refreshcurrent()
         loop
      endif
      next i

      endif
   endif

      ENDIF

      IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
         aTmp[nElemen,1]:=cTmpData
         ob:refreshcurrent()
         LOOP
      ENDIF
      if ob:colpos #  4
      IF aTmp[nElemen,6] # elemen1
         Berita(19,39,' Barang sudah diambil, Tidak Boleh Dirubah .... ','n/bg')
         aTmp[nElemen,3]:=elemen1
         aTmp[nElemen,1]:= cTmpdata
         ob:refreshcurrent()
         LOOP
      ENDIF
      aTmp[nElemen,6]:=aTmp[nElemen,3]
      endif
      if ob:colpos == 1
         aTmp[nElemen,4]:=stk->Harga
      endif
      aTmp[nElemen,2]:=stk->Nama
      setcolor('w/r')
      @22,20 say stk->Qtt pict '@e 9,999,999'
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
      @18,57 say _u pict apict[5]
      ob:right()
      ob:refreshall()
   endif

   If x == 42
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
      @18,57 say _u pict apict[5]
      ob:home()
      ob:gobottom()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(10)
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] == space(10)
         Berita(15,39,' Prosess tidak dilakukan, tekan sembarang tombol ..','g*/n')
      else
         traRtoFi(aTmp)
         _Hutang(_u)
         Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      endif
      EXIT
   endif
   KEY(X,OB)
END
close all
return(nil)

Static Function _mheader()
**************************************************************************
// HEADER FORM
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,44,'r/bg')
Sakti(1,21,'  Koreksi Pembelian   ','gr+/bg')
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
Local mMuka
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
      IF Found()
         berita(5,39,' Sudah ada pemasukan barang, batalkan pemasukan dulu .','gr+/bg')
         close all
         cFaktur:=space(8)
         return nil
      endif
      sele masuk
      dDate:=Tglin
      @4,14 get dDate pict '@!'
      Read
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
   set Relation to Kodbrg into stk
   aTmp:={}
   mmuka:=muka
   While cFaktur == Nobpb .and. !Eof()
      aAdd(aTmp,{Kodbrg,stk->nama,Qtt,Harga,0,Sisa})
      skip
   enddo
   _u:=0
   aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
   SELE PMSK
   REPLACE TOTALHT WITH TOTALHT-(_u-MMUKA)
   SELE Hutang
   set order to 2
   seek cFaktur
   REPLACE JMLHT WITH Jmlht - _u,TUNAI WITH Tunai-MMUKA
   exit
ENDDO
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:=' Enter -> Edit   '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Simpan Data'
@24,0 say padc(cData,80)
return (nil)



// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
lOCAL J
Sele Masuk
seek cFaktur
for j:=1 to len(aTmp)

   //Rubah Harga Barang
   sele stk
   dbseek(aTmp[j,1])
   REPLACE Harga WITH aTmp[j,4]

   // Rekam Data Transaksi
   SELE Masuk
    fieldput(1,dDate)          // Tglin
    fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
    fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
    fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
    fieldput(fieldpos('sisa'),(aTmp[j,6]))    // Sisa   -- qtt Barang
    skip
next
Return (nil)

// proses uang muka
Static Function _Hutang(Jumlah)
**************************************************************************
Local mmuka
sele masuk
seek cFaktur
 MMUKA:=Muka
@19,57 GET MMUKA PICT '@E 99,999,999'
READ
setcolor('w/r')
@20,57 SAY Jumlah-MMUKA PICT '@E 99,999,999'

SELE Masuk
SEEK cFaktur
WHILE cFaktur=NOBPB .AND. !EOF()
   REPLACE MUKA WITH MMUKA
   SKIP
ENDDO

SELE PMSK
REPLACE TOTALHT WITH TOTALHT+(JUMlah-MMUKA)
IF (JUMlah-MMUKA)<=0
   SELE Hutang
   REPLACE Tglht WITH dDate,JMLHT WITH Jmlht+JUMlah,;
   TUNAI WITH Tunai+MMUKA,STATUS WITH 'CASH  '
ELSE
   SELE Hutang
   REPLACE Tglht WITH dDate,JMLHT WITH Jmlht+JUMlah,;
   TUNAI WITH Tunai+MMUKA,STATUS WITH 'KREDIT'
ENDIF
dbcommitall()
Return (Nil)

