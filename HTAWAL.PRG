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
Static apict:={'@!','@!','@e 999,999,999','@e 9,999,999','@e 99,999,999'}
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
Static cTmpData

Function Htawal()
geser(1)
dbcloseall()
buka1()
While .T.
   aTmp:={}
   _mHeader()
   Editheader()
   IF cFaktur=space(3)
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
c:=TBCOLUMNNEW(' No BPB ',{||aTmp[nelemen,1]})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Tgl BPB ',{||aTmp[NELEMEN,2]})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[NELEMEN,3],'@e 999,999,999')})
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Hutang awal   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      If Ob:ColPos==1
         dbseek(aTmp[nElemen,1])
         If Found() .or. left(aTmp[nElemen,1],3)<>'OPM'
            berita(row()+1,39,' Data sudah ada, Tidak Bisa dilakukan ','gr/n')
            aTmp[nElemen,1]:=cTmpData
            LOOP
         ENDIF
         if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == 'OPM     '
                         ob:up()
                      endif
                      ob:Refreshcurrent()
                      loop
                   endif
               Next i
            else
               for i:=nElemen+1 to len(aTmp)
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i

               for i:=1 to nElemen-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i
            endif
         endif
      Endif
      ob:refreshall()
   endif
   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]=='OPM     '
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{'OPM     ',date(),0,'T'})
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
      if aTmp[nelemen,ob:colpos]=='OPM     '
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] == 'OPM     '
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Hutang awal   ','w/r')})
   Setpos(nBrs,nCol)
   IF X==13
      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      If Ob:ColPos==1
         dbseek(aTmp[nElemen,1])
         If Found() .or. left(aTmp[nElemen,1],3)<>'OPM'
            berita(row()+1,39,' Data sudah ada, Tidak Bisa dilakukan ','gr/n')
            aTmp[nElemen,1]:=cTmpData
            LOOP
         ENDIF
         if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == 'OPM     '
                         ob:up()
                      endif
                      ob:Refreshcurrent()
                      loop
                   endif
               Next i
            else
               for i:=nElemen+1 to len(aTmp)
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i

               for i:=1 to nElemen-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i
            endif
         endif
      Endif
      ob:refreshall()
   endif

   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]=='OPM     '
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{'OPM     ',date(),0,'T'})
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
      if aTmp[nelemen,ob:colpos]=='OPM     '
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] =='OPM     '
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
sBox(0,21,2,56,'r/bg')
Keyboard(chr(13))
Sakti(1,23,'   Pemasukan Hutang Awal   ','gr+/bg')
@3,2 SAY ' Kode Pemasok: '
@4,2 say ' Nama Pemasok: '
// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl
dDate:=date()
cFaktur:=space(3)
setcolor('n/w,n/w')
@3,18 get cFaktur pict '@!'
Read
SEle Pmsk
IF cFaktur=space(3)
   SAVE SCREEN
   MJUD:={'KODPMSK','NAMA '}
   MTPL:={'KODpmsk','NAMA'}
   SBOX(4,29,21,69,'R/Bg,W/R')
   DBEDIT(5,30,20,68,MTPL,'','',MJUD)
   RESTORE SCREEN
   IF LASTKEY()=27
      RETURN nil
   ENDIF
   cFaktur:=Pmsk->KODpmsk
ENDIF

IF !fFound(6,39,cFaktur,'gr+/bg')
   cFaktur:=space(3)
   Return nil
ENDIF
@3,18 say CfAKTUR
@4,18 say nama
sele ht
dbseek(left('OPM',3))
While left(Nobpb,3)=='OPM'.and. kODPMSK<>CfAKTUR .AND. !eOF()
  skip
Enddo
If Kodpmsk==cFaktur
   While left(Nobpb,3)=='OPM'.and. kODPMSK==CfAKTUR .AND. !eOF()
       aAdd(aTmp,{nobpb,tglin,jmlht,'T'})
       dbskip(1)
   Enddo
  /*    berita(row()+1,39,'  Data tidak ditemukan, Lakukan pengisian Data  ','gr/n')
      cFaktur:=space(3)
      Return nil
   Endif*/

      nArray:=Len(aTmp)
      Setcolor('r/bg')
      cHelp:='Enter->Edit  Esc->Batal Proses Delete->Hapus data "*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=1
Else
      aAdd(aTmp,{'OPM     ',date(),0,'T'})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=2
Endif
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
sele ht
dbseek(left('OPM',3))
While left(Nobpb,3)=='OPM'.and. kODPMSK<>CfAKTUR .AND. !eOF()
  skip
Enddo
sele Pmsk
dbseek(cFaktur)
for j:=1 to len(aTmp)
   If Pilih==2
      sele pmsk
      //Tambah Hutang awal
      REPLACE Totalht WITH Totalht+aTmp[j,3]

      // Rekam Data Transaksi
      Sele Ht
      dbappend()
      fieldput(fieldpos('Kodpmsk'),cFaktur)          // Tglin
      fieldput(fieldpos('Tglin'),aTmp[j,2])          // Tglin
      fieldput(fieldpos('Nobpb'),(aTmp[j,1]))    // Qyds
      fieldput(fieldpos('Jmlht'),(aTmp[j,3]))    // Kodbrg
  Else
     sele pmsk
     If aTmp[j,4]=='T'
        If aTmp[j,1]==Ht->nobpb
           dbseek(cFaktur)
           REPLACE Totalht with Totalht+(aTmp[j,3]-Ht->Jmlht)
        Else
           dbseek(Ht->kodpmsk)
           REPLACE Totalht WITH Totalht-Ht->Jmlht
           dbseek(cFaktur)
           REPLACE Totalht WITH Totalht+aTmp[j,3]
        Endif

        // Rekam Data Transaksi
        Sele HT
        If nArray>=J
           fieldput(fieldpos('Tglin'),aTmp[j,2])    // Qpcs
           fieldput(fieldpos('Kodpmsk'),cFaktur)          // Tglin
           fieldput(fieldpos('Nobpb'),(aTmp[j,1]))    // Qyds
           fieldput(fieldpos('Jmlht'),(aTmp[j,3]))    // Kodbrg
        else
           dbappend()
           fieldput(fieldpos('Tglin'),aTmp[j,2])    // Qpcs
           fieldput(fieldpos('Kodpmsk'),cFaktur)          // Tglin
           fieldput(fieldpos('Nobpb'),(aTmp[j,1]))    // Qyds
           fieldput(fieldpos('Jmlht'),(aTmp[j,3]))    // Kodbrg
        Endif
     else
        Sele Pmsk
        dbseek(HT->kodpmsk)
        REPLACE Totalht WITH Totalht-Ht->Jmlht
        Sele Ht
        Delete
     endif
  Endif
  dbSkip()
next
dbCommitall()
Return (nil)