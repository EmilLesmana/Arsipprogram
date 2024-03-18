*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : In.prg                     *
* For Input Pemasukan Barang              *
*******************************************

memvar getlist
#include "ee.intan"
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,PMS,Tglin,MUKA,TUNAI,;
      DP,TGLHT,STATUS,Qtt,HARGA,TOTALHT,Jmlht
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 99,999,999','@e 99,999,999,999'}
Static dDate
Static cFaktur
Static cBukti
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

Function Stkawal()
geser(1)
dbcloseall()
buka1()
While .T.
   aTmp:={}
   _mHeader()
   Editheader()
   IF cFaktur='OPNAME  '
      exit
   ENDIF

   If cBukti==space(8)
      exit
   ENDIF
   cBrowse()
   If Pilih==1
      Proses2()
   else
      Proses1()
   Endif
Enddo
dbCLOSEALL()
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
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||aTmp[NELEMEN,2]})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Stok awal   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2
         ob:right()
         Loop
      endif

      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      SELE Stk
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','stk->Nama'}
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
      Endif
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
      aAdd(aTmp,{space(10),space(20),0,'T'})
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Stok awal   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2
         ob:right()
         Loop
      endif

      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      SELE Stk
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','stk->Nama'}
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
      Endif
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
      aAdd(aTmp,{space(10),space(20),0,'T'})
      ob:panhome()
      ob:gobottom()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

   If x ==7
      If(aTmp[nElemen,4]=='F',aTmp[nElemen,4]:='T',aTmp[nElemen,4]:='F')
      ob:panhome()
      ob:refreshall()
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
sBox(0,21,2,52,'r/bg')
Keyboard(chr(13))
Sakti(1,23,'   Pemasukan Stok Awal   ','gr+/bg')
@3,2 SAY ' No.Bukti: '
@5,2 SAY ' Tanggal : '

// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
@22,5 say ' Sisa Stok = '
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl
dDate:=date()
cFaktur:='OPNAME  '
setcolor('n/w,n/w')
@3,14 get cFaktur pict '@!'
Read
If cFaktur=='OPNAME  '
   Return nil
endif
SEle Trstk
Set Relation to kodbrg into stk
dbSeek(cFaktur)
IF fOUND()
   If left(cFaktur,6)<>'OPNAME'
         Berita(15,40,' Nomor tidak sesuai dengan data yang ada ... ','w/r')
         Return nil
   Endif
       If cFaktur<>bukti
         Berita(15,40,' Nomor tidak sesuai dengan data yang ada ... ','w/r')
         Return nil
        Endif
      dDate:=Tglin
      While cFaktur==Bukti .and. !Eof()
         aAdd(aTmp,{Kodbrg,stk->Nama,Qtt,'T'})
         dbskip(1)
      Enddo
      nArray:=Len(aTmp)
      Setcolor('r/bg')
      cHelp:='Enter->Edit  Esc->Batal Proses Delete->Hapus data "*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=1
Else
      aAdd(aTmp,{space(10),space(20),0,'T'})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=2
Endif
@5,14 get dDate
read
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
Sele Trstk
dbseek(cFaktur)
for j:=1 to len(aTmp)
   If Pilih==2
      //Tambah Stok Gudang
      sele stk
      dbseek(aTmp[j,1])
      REPLACE qtt WITH qtt+aTmp[j,3]

      // Rekam Data Transaksi
      Sele Trstk
      dbappend()
      fieldput(fieldpos('Tglin'),dDate)          // Tglin
      fieldput(fieldpos('Bukti'),cFaktur)        // Nobpb
      fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
      fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
  Else
     sele stk
     If aTmp[j,4]=='T'
        If aTmp[j,1]==Trstk->Kodbrg
           dbseek(aTmp[j,1])
           REPLACE Qtt with qtt+(aTmp[j,3]-trstk->qtt)
        Else
           dbseek(Trstk->Kodbrg)
           REPLACE qtt WITH qtt-Trstk->qtt
           sele stk
           dbseek(aTmp[j,1])
           REPLACE qtt WITH qtt+aTmp[j,3]
        Endif

        // Rekam Data Transaksi
        Sele Trstk
        If nArray>=J
           fieldput(fieldpos('Tglin'),ddate)    // Qpcs
           fieldput(fieldpos('Bukti'),cFaktur)        // Nobpb
           fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
           fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
        else
           dbappend()
           fieldput(fieldpos('Tglin'),ddate)    // Qpcs
           fieldput(fieldpos('Bukti'),cFaktur)        // Nobpb
           fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
           fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
        Endif
     else
        Sele stk
        dbseek(Trstk->Kodbrg)
        REPLACE qtt WITH qtt-Trstk->qtt
        Sele Trstk
        Delete
     endif
  Endif
  dbSkip()
next
dbCommitall()
Return (nil)
