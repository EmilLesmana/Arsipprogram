*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Kas.prg                    *
* For Output to Pengeluaran               *
*******************************************
memvar getlist
#include 'EE.Inten'
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,Tglin,MUKA,TUNAI,;
      TGLHT,KODPMS,STATUS,QMTR,QYDS,QPCS,HARGA,TOTALHT
Static _u
Static _u1
Static n:=1
Static apict:={'@!','@e 9,999,999,999','@E 9,999,999,999'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static aTmp
Static nElemen
Static Pilih
Static ob
Static x
Static nBrs
Static nCol
Static C
Static nArray

Function Kas1()
geser(2)
dbcloseall()
If !KasS()
   Return Nil
Endif

If !NKasS()
   Return Nil
Endif

If !ACCS()
   Return Nil
Endif

While .t.
   aTmp:={}
   _mHeader()
   Editheader()
   IF cfaktur==space(8)
      exit
   ENDIF
   cBrowse()
   If Pilih==1
      Proses2()
   Else
      Proses1()
   Endif
Enddo
Close all
Return Nil

Static Function cBrowse()
nElemen:=1
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
OB:=TBROWSENEW(7,2,16,77)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}
Ob:Colorspec:='gr+/b,n/g,n/r'
// Add to Objeck Colom
/*c:=TBCOLUMNNEW(' Kode ACC ',{||aTmp[nelemen,1]})
c:Colorblock:={||If(aTmp[nElemen,5]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)*/
c:=TBCOLUMNNEW(' KETERANGAN ',{||aTmp[NELEMEN,1]})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' MASUK ',{||tran(aTmp[NELEMEN,2],'@e 9,999,999,999')})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' KELUAR ',{||tran(aTmp[NELEMEN,3],'@e 9,999,999,999')})
c:Colorblock:={||If(aTmp[nElemen,4]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
SEPARATED OB WITH BSINGLE
Return nil

Static Function Proses1()
Local mJud,mTpl,nbrs,ncol,tanya:=' '
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,17,79)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'  KAS  KECIL ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      /*If ob:colpos==2
         If aTmp[nelemen,2]<>0
            ob:right()
         else
            @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
            read
         endif
      elseif ob:colpos==3
         If aTmp[nelemen,3]<>0
            ob:home()
         else
            @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
            read
         endif
      else*/
         @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
         read
      //endif
      /*   dbcommit()
         unlock
      Endif
      SELE ACC
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(5)
            SAVE SCREEN
            mJud:={'Kode ACC',' URAIAN '}
            mTpl:={'KODACC','URAIAN'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=KODACC
         ENDIF

         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(5)
            LOOP
         ENDIF
      Endif
      setcolor('w/r')
      //@5,5 SAY 'NAMA ACCOUNT --->'+ACC->URAIAN
      @5,5 SAY 'NAMA ACCOUNT --->'+ACC->URAIAN*/
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,2]})
      _u1:=0
      aEval(aTmp,{|e,_au|_u1+=aTmp[_au,3]})
      @18,10 say 'MASUK -->Rp.'+TRAN(_u,'@E 9,999,999,999')+;
             '    KELUAR -->Rp.'+TRAN(_U1,'@E 9,999,999,999')
      ob:right()
      ob:refreshall()
   endif

   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(40)
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{space(40),0,0,'T'})
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
      if aTmp[nelemen,ob:colpos]==space(40)
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] == space(40)
         Berita(15,39,' Prosess tidak dilakukan, tekan sembarang tombol ..','g*/n')
      else
         traRtoFi(aTmp)
         Sele NKAS
         If Reclock()
            Replace Nomor with Nomor+1
            dbcommit()
            unlock
         endif
         Setcolor('w/r,gr+/b')
         Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      endif
      EXIT
   endif
   KEY(X,OB)
END
return(nil)

Static Function Proses2()
Local mJud,mTpl,nbrs,ncol,tanya:=' '
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,17,79)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'  KAS  KECIL ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      /*If ob:colpos==2
         If aTmp[nelemen,2]<>0
            ob:right()
         else
            @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
            read
         endif
      elseif ob:colpos==3
         If aTmp[nelemen,3]<>0
            ob:home()
         else
            @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
            read
         endif
      else*/
         @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
         read
      //endif
     /* SELE ACC
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(5)
            SAVE SCREEN
            mJud:={'Kode ACC',' URAIAN '}
            mTpl:={'KODACC','URAIAN'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=kodACC
         ENDIF

         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(5)
            LOOP
         ENDIF
      Endif
      setcolor('w/r')
      @5,5 SAY 'NAMA ACCOUNT --->'+ACC->URAIAN*/
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u+=aTmp[_au,2],_u)})
      _u1:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u1+=aTmp[_au,3],_u1)})
      @18,10 say 'MASUK -->Rp.'+TRAN(_u,'@E 9,999,999,999')+;
             '    KELUAR -->Rp.'+TRAN(_U1,'@E 9,999,999,999')

      ob:right()
      ob:refreshall()
   endif

   if x==43
      ob:gobottom()
      ob:panhome()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(40)
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aAdd(aTmp,{space(40),0,0,'T'})
      ob:panhome()
      ob:gobottom()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

   If x ==7
      If(aTmp[nElemen,4]=='F',aTmp[nElemen,4]:='T',aTmp[nElemen,4]:='F')
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u+=aTmp[_au,2],_u)})
      _u1:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u1+=aTmp[_au,3],_u1)})
      @18,10 say 'MASUK -->Rp.'+TRAN(_u,'@E 9,999,999,999')+;
             '    KELUAR -->Rp.'+TRAN(_U1,'@E 9,999,999,999')
      ob:panhome()
      ob:refreshall()
   endif

   If x ==42
      ob:panhome()
      ob:gobottom()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(40)
         berita(row()+1,39,'  Data terakhir masih kosong, Lakukan pengisian Data  ','gr/n')
         LOOP
      endif

      if len(aTmp) == 1  .and. aTmp[nElemen,1] == space(40)
         Berita(15,39,' Prosess tidak dilakukan, tekan sembarang tombol ..','g*/n')
      else
         traRtoFi(aTmp)
         Setcolor('w/r,gr+/b')
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
SETCOLOR('')
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,47,'r/bg')
Keyboard(chr(13))
Sakti(1,21,'   KAS KECIL ','gr+/bg')
@3,2 SAY ' Faktur  : '
@4,2 SAY ' Tanggal : '
// Building Work area
sbox(6,1,17,78,'GR+/B,W/R')
//sbox(17,37,21,71,'GR+/B,W/R')
//@18,38 say ' Jumlah   :Rp.'
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl,cHelp
dDate:=Date()
cFaktur:=space(8)
WHILE .T.
   Sele kas
   //Set Relation To kodACC into ACC
   cJadi:='KAS'

If NKAS->nomor==10000
   Replace NKAS->Nomor with 1
endif

   cNomor:=Ltrim(str(NKAS->Nomor))
   if len(cnomor)==1
      cNomor:='0000'+cNomor
   elseif len(cnomor)==2
      cNomor:='000'+cNomor
   elseif len(cnomor)==3
      cNomor:='00'+cNomor
   elseif len(cnomor)==4
      cNomor:='0'+cNomor
   endif

cFaktur:=cJadi+cNomor
   setcolor('n/w,n/w')
   @3,14 Get cFaktur pict '@!'
   Read

   If LASTKEY()==27
      cFaktur:=Space(8)
      Return nil
   Endif
   seek cFaktur
   If Found()
      dDate:=Tglout
      While Faktur==Cfaktur .and. !Eof()
         Aadd(aTmp,{URAIAN,DEBIT,KREDIT,'T'})
         Skip
      Enddo
      nArray:=len(aTmp)
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u+=aTmp[_au,2],_u)})
      _u1:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,4]=='T',_u1+=aTmp[_au,3],_u1)})
      @18,10 say 'MASUK -->Rp.'+TRAN(_u,'@E 9,999,999,999')+;
             '    KELUAR -->Rp.'+TRAN(_U1,'@E 9,999,999,999')
      Pilih:=1
      Setcolor('r/bg')
      cHelp:='"+" -> Tambah  Enter -> Edit   Esc -> Batal Proses  '+;
      chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Simpan Data'
      @24,0 say padr(cHelp,80)
   Else
      aAdd(aTmp,{space(40),0,0,'T'})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @24,0 say padc(cHelp,80)
      Pilih:=2
   Endif

   @4,14 get dDate
   read
   exit
ENDDO
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
Sele Kas
Dbseek(cFaktur)
for j:=1 to len(aTmp)
   If Pilih==2
      // Rekam Kas
      SELE ACC
      if Reclock()
      REPLACE JUMLAH WITH JUMLAH+aTmp[j,2],Jumlah with Jumlah-aTmp[j,3]
      dbcommit()
      unlock
      endif
      Sele Kas
      // Rekam Data Transaksi
      dbappend()
      If Reclock()
         fieldput(1,dDate)          // Tglout
         fieldput(2,cFaktur)        // Faktur
         //fieldput(fieldpos('kodACC'),(aTmp[j,1]))    // Kodbrg
         fieldput(fieldpos('URAIAN'),(aTmp[j,1]))    // Kodbrg
         fieldput(fieldpos('DEBIT'),(aTmp[j,2]))    // Qtt
         fieldput(fieldpos('KREDIT'),(aTmp[j,3]))    // Qtt
         dbcommit()
         unlock
      endif
   Else
      If aTmp[j,4]=='T'
         If nArray>=j
             SELE ACC
             If Reclock()
             REPLACE JUMLAH WITH JUMLAH+(aTmp[j,2]-Kas->Debit),;
                     Jumlah with Jumlah-(aTmp[j,3]-Kas->Kredit)
             dbcommit()
             unlock
             endif
            // Rekam Data Transaksi
            Sele Kas
            If Reclock()
               fieldput(fieldpos('Tglout'),ddate)    // Qpcs
               //fieldput(fieldpos('kodACC'),(aTmp[j,1]))    // Kodbrg
               fieldput(fieldpos('URAIAN'),(aTmp[j,1]))    // Kodbrg
               fieldput(fieldpos('DEBIT'),(aTmp[j,2]))    // Qtt
               fieldput(fieldpos('KREDIT'),(aTmp[j,3]))    // Qtt
               Dbcommit()
               unlock
            endif
         else
            SELE ACC
             If Reclock()
             REPLACE JUMLAH WITH JUMLAH+aTmp[j,2],;
                     Jumlah with Jumlah-aTmp[j,3]
             dbcommit()
             unlock
             endif
             sele kas
            dbappend()
            If Reclock()
               fieldput(1,dDate)          // Tglout
               fieldput(2,cFaktur)        // Faktur
               //fieldput(fieldpos('kodACC'),(aTmp[j,1]))    // Kodbrg
               fieldput(fieldpos('URAIAN'),(aTmp[j,1]))    // Kodbrg
               fieldput(fieldpos('DEBIT'),(aTmp[j,2]))    // Qtt
               fieldput(fieldpos('KREDIT'),(aTmp[j,3]))    // Qtt
               dbcommit()
               unlock
            Endif
         endif
      else
         SELE ACC
             If Reclock()
             REPLACE JUMLAH WITH JUMLAH-aTmp[j,2],;
                     Jumlah with Jumlah+aTmp[j,3]
             dbcommit()
             unlock
             endif
         sele kas
         If Reclock()
            Delete
            dbcommit()
            unlock
         Endif
      endif
   Endif
   dbSkip()
next
Return (nil)
