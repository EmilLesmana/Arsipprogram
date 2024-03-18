*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : In.prg                     *
* For Input Pembelian                     *
*******************************************

memvar getlist
#include "ee.intan"
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,PMS,Tglin,MUKA,TUNAI,;
      DP,TGLHT,STATUS,Qtt,HARGA,TOTALHT,Jmlht
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 99,999,999','@e 999,999,999,999'}
Static dDate
Static cFaktur
Static ckodPMSK
Static aTmp
Static ob
Static nElemen
Static c
Static x
Static nBrs
Static nCol
Static Pilih
Static cHelp
Static nArray
Static cTmpData
Static nPPN1

Function In()
geser(1)
buka1()
While .T.
   aTmp:={}
   _mHeader()
   Editheader()
   IF cFaktur=space(8)
      exit
   ENDIF

   IF cKodpmsk=space(3)
      exit
   ENDIF
   cBrowse()
   If Pilih==1
      Proses2()
   else
      Proses1()
   Endif
Enddo
CLOSE ALL
RETURN nil

Static Function cBrowse()
nElemen:=1
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
OB:=TBROWSENEW(7,2,16,70)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}
Ob:Colorspec:='gr+/b,n/g,n/r'

// Add to Objeck Colom
c:=TBCOLUMNNEW(' Kode Brg ',{||aTmp[nelemen,1]})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||aTmp[NELEMEN,2]})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 99,999,999')})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[nElemen,3]*aTmp[NELEMEN,4],'@e 999,999,999,999')})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Sisa ',{||tran(aTmp[NELEMEN,7],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,6]=='F',{3,2},If(aTmp[nElemen,7]==0,{2,1},{1,2}))}
OB:ADDCOLUMN(c)

SEPARATED OB WITH BSINGLE
Return nil

Static Function Proses1()
Local mJud,mTpl
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,17,71)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'   Faktur Pembelian   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2
         ob:right()
         Loop
      endif

      If ob:Colpos==5 .or. ob:colpos==6
         ob:PanHome()
         loop
      endif
      cTmpData:=aTmp[nElemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      SELE STK
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','Nama'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF
         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            LOOP
         ENDIF
         aTmp[nElemen,2]:=stk->Nama
         aTmp[nElemen,4]:=stk->Harga
         if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == space(10)
                         ob:up()
                      endif
                      ob:Refreshcurrent()
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
      Endif
      setcolor('w/r')
      @22,20 say TRAN(stk->qtt,'@e 9,999')
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
      @18,54 say _u pict apict[5]
      aTmp[nElemen,7]:=aTmp[nElemen,3]
      ob:right()
      ob:refreshall()
   endif

   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(10)
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{space(10),space(20),0,0,0,'T',0})
      ob:panhome()
      ob:gobottom()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

   If x ==42
      ob:panhome()
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
         _Hutang(dDate,cFaktur,cKodpmsk,_u)
         Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      endif
      EXIT
   endif
   KEY(X,OB)
END
return(nil)

Static Function Proses2()
Local mJud,mTpl
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,17,71)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'   Faktur Pembelian   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      If aTmp[nElemen,7]<>aTmp[nElemen,3]
         Berita(15,39,' Tidak bisa dikoreksi, batalkan pemasukan barang ... ','br/n')
         loop
      Endif
      if ob:colpos==2
         ob:right()
         Loop
      endif

      If ob:Colpos==5 .or. ob:colpos==6
         ob:PanHome()
         loop
      endif
      cTmpData:=aTmp[nElemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      SELE STK
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','Nama'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF
         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            LOOP
         ENDIF
         aTmp[nElemen,2]:=stk->Nama
         aTmp[nElemen,4]:=stk->Harga
         if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == space(10)
                         ob:up()
                      endif
                      ob:Refreshcurrent()
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
      Endif
      setcolor('w/r')
      @22,20 say TRAN(stk->qtt,'@e 9,999')
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,6]=='T',_u+=aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,54 say _u pict apict[5]
      aTmp[nElemen,7]:=aTmp[nElemen,3]
      ob:right()
      ob:refreshall()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

   If x ==7
      If aTmp[nElemen,7]<>aTmp[nElemen,3]
         Berita(15,39,' Tidak bisa dibatalkan, batalkan pemasukan barang ... ','br/n')
         loop
      Endif
      If(aTmp[nElemen,6]=='F',aTmp[nElemen,6]:='T',aTmp[nElemen,6]:='F')
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,6]=='T',_u+=aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,54 say _u pict apict[5]
      ob:panhome()
      ob:refreshall()
   endif

   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(10)
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{space(10),space(20),0,0,0,'T',0})
      ob:panhome()
      ob:gobottom()
   endif

   If x ==42
      ob:panhome()
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
         _Hutang(dDate,cFaktur,cKodpmsk,_u)
         Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      endif
      EXIT
   endif
   KEY(X,OB)
END
return(nil)


Static Function _mheader()
**************************************************************************
// HEADER FORM
Setcolor('n+/n')
@0,0,23,79 BOX REPLI(CHR(219),9)
sBox(0,21,2,46,'r/bg')
Keyboard(chr(13))
Sakti(1,23,'   Faktur Pembelian   ','gr+/bg')
@4,2 SAY ' Tanggal : '
@3,2 SAY ' Faktur  : '
@3,25 SAY ' PPN : '
@5,2 SAY ' KodPmsk : '

@3,39 SAY ' Nama   : '
@4,39 SAY ' Alamat : '

Sele Ht
Sele Trin
Set Relation to Kodbrg into Stk,to nobpb into Ht

// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
sbox(17,37,22,71,'GR+/B,W/R')
@18,38 say ' Jumlah   :Rp.'
@19,38 say ' P P N    :Rp.'
@20,38 say ' Bayar    :Rp.'
@21,38 say ' Total    :Rp.'
@22,5 say ' Stok Gudang = '
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl
dDate:=date()
nPPN1=11
ckodPMSK:=space(3)
cFaktur:=space(8)
setcolor('n/w,n/w')
@3,14 get cFaktur pict '@!'
@3,32 get nPPN1 pict '99'
Read

IF cFaktur=space(8)
   CLOSE ALL
   RETURN nil
Else
   SEEK cfaktur
   IF fOUND()
      sele trht
      dbseek(cFaktur)
      If Found()
         Berita(15,30,'Batalkan Pembayaran Hutang,untuk Koreksi Pembelian... ','r/w')
         cFaktur:=space(8)
         Return nil
      endif
      Sele Trin
      cKodpmsk:=Ht->Kodpmsk
      dDate:=Tglin
      While cFaktur==Nobpb .and. !Eof()
         aAdd(aTmp,{Kodbrg,stk->Nama,Qtt,Harga,Qtt*Harga,'T',Sisa})
         skip
      Enddo
      nArray:=Len(aTmp)
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,6]=='T',_u+=aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,54 say _u pict apict[5]
      Setcolor('r/bg')
      cHelp:='Enter->Edit  Esc->Batal Proses Delete->Hapus data "*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=1
   Else
      aAdd(aTmp,{space(10),space(20),0,0,0,'T',0})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=2
   Endif
Endif

@4,14 get dDate
sele Pmsk
@5,14 get ckodPMSK pict '@!'
read
IF cKODPMSK=space(3)
   SAVE SCREEN
   MJUD:={'KODPMSK','NAMA '}
   MTPL:={'KODpmsk','NAMA'}
   SBOX(4,29,21,69,'R/Bg,W/R')
   DBEDIT(5,30,20,68,MTPL,'','',MJUD)
   RESTORE SCREEN
   IF LASTKEY()=27
      RETURN nil
   ENDIF
   cKODPMSK:=Pmsk->KODpmsk
ENDIF

IF !fFound(6,39,cKODPMSK,'gr+/bg')
   cKodpmsk:=space(3)
   Return nil
ENDIF
setcolor('n/w,n/w')
@5,14 SAY ckodPMSK pict '@!'
@3,50 SAY Pmsk->nama
@4,50 SAY padr(Pmsk->ALAMAT,25)
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
Sele Trin
Dbseek(cFaktur)
for j:=1 to len(aTmp)
   If Pilih==2
      // Rekam Data Transaksi
      Sele Stk
      dbseek(aTmp[j,1])
      */Replace Harga with aTmp[j,4]/*
      Replace Harga with ((Qtt*harga)+(aTmp[j,3]*aTmp[j,4]))/(Qtt+aTmp[j,3])
      Sele Trin
      dbappend()
      fieldput(fieldpos('Tglin'),dDate)          // Tglin
      fieldput(fieldpos('Nobpb'),cFaktur)        // Nobpb
      fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
      fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
      fieldput(fieldpos('Harga'),(aTmp[j,4]))    // Harga
      fieldput(fieldpos('Sisa'),(aTmp[j,7]))    // Harga
  Else
     If aTmp[j,6]=='T'
        // Rekam Data Transaksi
        Sele Stk
        dbseek(aTmp[j,1])
        Replace Harga with aTmp[j,4]
//        Replace Harga with (Qtt*harga)+(aTmp[j,3]*aTmp[j,4])/Qtt+aTmp[j,4]
        Sele Trin
        If nArray>=J
           fieldput(fieldpos('Tglin'),ddate)    // Qpcs
           fieldput(fieldpos('Nobpb'),cFaktur)        // Nobpb
           fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
           fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
           fieldput(fieldpos('Harga'),(aTmp[j,4]))    // Harga
           fieldput(fieldpos('Sisa'),(aTmp[j,7]))    // Harga
        else
           dbappend()
           fieldput(fieldpos('Tglin'),ddate)    // Qpcs
           fieldput(fieldpos('Nobpb'),cFaktur)        // Nobpb
           fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
           fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
           fieldput(fieldpos('Harga'),(aTmp[j,4]))    // Harga
           fieldput(fieldpos('Sisa'),(aTmp[j,7]))    // Harga
        Endif
     else
        Sele Trin
        Delete
     endif
  Endif
  dbSkip()
next
Return (nil)

// proses uang muka
Static Function _Hutang(dDate,cFaktur,cKodpmsk,MJUMLAH)
**************************************************************************
Local MMUKA,nPPn
Sele Ht
dbseek(cFaktur)
If Found()
   If mjumlah==0
      mmuka:=0
   else
      mmUKA:=Tunai
   endif
Else
  mMuka:=0
Endif
nPPn:=(mjumlah*((nppn1+100)/100))-mjumlah
@19,54 say nPPn PICT '@E 999,999,999,999'
@20,54 GET MMUKA PICT '@E 999,999,999,999'
READ
setcolor('w/r')
@21,54 SAY MJUMLAH+nPPn-MMUKA PICT '@E 999,999,999,999'
If Pilih==2
   SELE Pmsk
   dbseek(cKodpmsk)
   REPLACE TOTALHt WITH TOTALHt+(mjumlah+nPPn-MMUKA)
else
      SELE Pmsk
   If cKodpmsk==Ht->KodPmsk
      dbseek(Ht->Kodpmsk)
      REPLACE TOTALht WITH TOTALht+((mjumlah+nPPn-MMUKA)-;
      (Ht->Jmlht-Ht->Tunai))
   Else
      dbseek(Ht->Kodpmsk)
      REPLACE TOTALht WITH TOTALht-(Ht->Jmlht-Ht->Tunai)
      dbseek(cKodpmsk)
      REPLACE TOTALht WITH TOTALht+(mJumlah+nPPn-MMUKA)
   endif
endif

Sele Ht
If Pilih==2
   If mJumlah-mmuka<=0
      DBAPPEND()
      REPLACE Tglin WITH DDATE,Nobpb WITH CFAKTUR,Tunai WITH MMUKA,;
      kodpmsk with ckodpmsk,Jmlht WITH MJUMLAH,Status with 'L'
   else
      DBAPPEND()
      REPLACE Tglin WITH DDATE,Nobpb WITH CFAKTUR,Tunai WITH MMUKA,;
      kodpmsk with ckodpmsk,Jmlht WITH MJUMLAH,Status with 'H'
   endif
Else
   Sele Trin
   dbseek(cFaktur)
   If !Found()
      Sele Ht
      dbseek(cFaktur)
      If Found()
         delete
      Endif
   else
      Sele Ht
      dbseek(cFaktur)
      REPLACE Tunai WITH MMUKA,kodpmsk with ckodpmsk,;
      Jmlht WITH MJUMLAH,Tglin with dDate
   endif
Endif
dbCommitaLL()
Return (Nil)