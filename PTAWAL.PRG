*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : In.prg                     *
* For Input Pemasukan Barang              *
*******************************************

memvar getlist
#include "ee.intan"
Field Kodbrg,KodLgn,Nama,Alamat,Faktur,PMS,Tglout,MUKA,TUNAI,;
      DP,TGLHT,STATUS,Qtt,HARGA,TOTALHT,Jmlpt
Static _u
Static n:=1
Static apict:={'@e 99999','@d','@e 99,999,999'}
Static dDate
Static cFaktur
Static cBukti
Static ckodlgn
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

Function Ptawal()
geser(1)
dbcloseall()
buka2()
While .T.
   aTmp:={}
   _mHeader()
   Editheader()
   IF Lastkey()=27
      dbcloseall()
      return nil
   endif
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
c:=TBCOLUMNNEW(' Faktur ',{||aTmp[nelemen,1]})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Tanggal ',{||aTmp[NELEMEN,2]})
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Piutang awal   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      If Ob:ColPos==1
         dbseek(aTmp[nElemen,1])
         If Found() 
            berita(19,39,' Data sudah ada, Tidak Bisa dilakukan ','gr/n')
            aTmp[nElemen,1]:=cTmpData
            LOOP
         ENDIF
         if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == 0
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
      ob:right()
      ob:refreshall()
   endif
   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==0
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{0,date(),0,'T'})
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
      if aTmp[nelemen,ob:colpos]==0
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] ==0
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
   X:=EVAL({||Putar(1,23,'   Pemasukan Piutang awal   ','w/r')})
   Setpos(nBrs,nCol)
   IF X==13
      cTmpData:=aTmp[nelemen,ob:colpos]
      @row(),col() get aTmp[nelemen,ob:colpos] pict '@e 99999'
      read
      If Ob:ColPos==1
         dbseek(aTmp[nElemen,1])
         If Found() 
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
                      if cTmpData ==0
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
      if aTmp[nelemen,ob:colpos]==0
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{0,date(),0,'T'})
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
      if aTmp[nelemen,ob:colpos]==0
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] ==0
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
Sakti(1,23,'   Pemasukan Piutang Awal   ','gr+/bg')
@3,2 SAY ' Kode Langganan: '
@4,2 say ' Nama Langganan: '
// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl
dDate:=date()
ckodlgn:=space(3)
setcolor('n/w,n/w')
@3,19 get ckodlgn pict '@!'
Read

If lastkey()=27
   dbcloseall()
   return nil
endif

SEle Lgn
IF ckodlgn=space(3)
   SAVE SCREEN
   MJUD:={'KODeLGN','NAMA '}
   MTPL:={'KODeLGN','NAMA'}
   SBOX(4,29,21,69,'R/Bg,W/R')
   DBEDIT(5,30,20,68,MTPL,'','',MJUD)
   RESTORE SCREEN
   IF LASTKEY()=27
      RETURN nil
   ENDIF
   ckodlgn:=Lgn->KODeLgn
ENDIF

IF !fFound(6,39,ckodlgn,'gr+/bg')
   ckodlgn:=space(3)
   Return nil
ENDIF
@3,19 say Ckodlgn
@4,19 say nama
sele Put
      aAdd(aTmp,{0,date(),0,'T'})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=2
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
Local j
sele Lgn
dbseek(ckodlgn)
for j:=1 to len(aTmp)
   If Pilih==2
      sele Lgn
      //Tambah Hutang awal
      REPLACE Totalut WITH Totalut+aTmp[j,3]

      // Rekam Data Transaksi
      Sele Put
      dbappend()
      fieldput(fieldpos('Kodelgn'),cFaktur)          // Tglout
      fieldput(fieldpos('Tglout'),aTmp[j,2])          // Tglout
      fieldput(fieldpos('Faktur'),(aTmp[j,1]))    // Qyds
      fieldput(fieldpos('Jmlpt'),(aTmp[j,3]))    // Kodbrg
  Else
     sele Lgn
     If aTmp[j,4]=='T'
        If aTmp[j,1]==Put->Faktur
           dbseek(cFaktur)
           REPLACE Totalut with Totalut+(aTmp[j,3]-Put->Jmlpt)
        Else
           dbseek(Put->Kodelgn)
           REPLACE Totalut WITH Totalut-Put->Jmlpt
           dbseek(cFaktur)
           REPLACE Totalut WITH Totalut+aTmp[j,3]
        Endif

        // Rekam Data Transaksi
        Sele put
        If nArray>=J
           fieldput(fieldpos('Kodelgn'),cFaktur)          // Tglout
           fieldput(fieldpos('Tglout'),aTmp[j,2])    // Qpcs
           fieldput(fieldpos('Faktur'),(aTmp[j,1]))    // Qyds
           fieldput(fieldpos('Jmlpt'),(aTmp[j,3]))    // Kodbrg
        else
           dbappend()
           fieldput(fieldpos('Tglout'),aTmp[j,2])    // Qpcs
           fieldput(fieldpos('Kodelgn'),cFaktur)          // Tglout
           fieldput(fieldpos('Faktur'),(aTmp[j,1]))    // Qyds
           fieldput(fieldpos('Jmlpt'),(aTmp[j,3]))    // Kodbrg
        Endif
     else
        Sele Lgn
        dbseek(HT->Kodelgn)
        REPLACE Totalut WITH Totalut-Put->Jmlpt
        Sele Put
        Delete
     endif
  Endif
  dbSkip()
next
dbCommitall()
Return (nil)