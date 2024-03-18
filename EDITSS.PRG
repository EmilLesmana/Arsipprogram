*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Inss.prg                   *
* For Input Penyesuaian Stok              *
*******************************************
Memvar getlist
Field Tglin,tglout,nobpb,Faktur,Nama,Kodbrg,catat,tgl1,bukti,;
      mobil,qtt,harga,min,status,ket,harga3,tglss,kodelgn,pms
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@!'}
Static dDate
Static akDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static cStatus
Static aTmp

Function Editss()
local ob
Local x,nBrs,nCol
Local mJud,mTpl
Private nElemen
nelemen:=1

geser(2)
buka1()
_mHeader()
_mHelp()
Editheader()
   IF cFaktur=space(6)
      CLOSE ALL
      RETURN nil
   ENDIF

//aAdd(aTmp,{space(10),space(20),0,0,space(15)})
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
OB:ADDCOLUMN(TBCOLUMNNEW(' Keterangan ',{||tran(padr(aTmp[NELEMEN,5],15),'@!')}))


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
   if cStatus == 'INSTK'
      X:=EVAL({||Sakti(1,21,'   Penambahan Stok   ','gr+/bg')})
   else
      X:=EVAL({||Sakti(1,21,'   Pengurangan Stok   ','gr+/bg')})
   endif

   Devpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2
         ob:right()
         ob:Refreshcurrent()
         loop
      endif
      cTmpData:=aTmp[nElemen,1]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      sele stk
      if ob:colpos==1
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            Set order to 2
            mJud:={'KODBRG','NAMA BARANG'}
            mTpl:={'KODBRG','NAMA'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
            aTmp[nElemen,4]:=stk->Harga
            Set order to 1
         ENDIF
      ENDIF

      IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
         ob:refreshcurrent()
         LOOP
      ENDIF

      aTmp[nElemen,2]:=stk->Nama
      setcolor('w/r')
      @22,20 say stk->Qtt pict '@e 9,999,999'
      if ob:colpos == ob:colcount()
         ob:panhome()
         ob:refreshcurrent()
         loop
       endif
      ob:right()
      ob:refreshall()
   endif

   If x == 42
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
close all
return(nil)

Static Function _mheader()
**************************************************************************
// HEADER FORM
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,44,'r/bg')
   Sakti(1,21,'  Penyesuaian Stok   ','gr+/bg')
@3,2 SAY ' Tanggal : '
@4,2 SAY ' Nota    : '

// Building Work area
sbox(6,1,20,71,'GR+/B,W/R')
@22,5 say ' Stok Gudang = '
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl
dDate:=Date()

WHILE .T.
   cFaktur:=space(6)
   setcolor('n/w,n/w')
   @3,14 get dDate
   @4,14 get cFaktur pict '@!'
   Read
   Sele Trss
   IF cFaktur=space(6)
      CLOSE ALL
      RETURN nil
   endif

   seek dDate
   While dDate == Tglss .and. cFaktur # Bukti .and. !eof()
       skip
   enddo

   IF cFaktur # Bukti .or. dDate # Tglss
      Berita(5,30,' Nomor Tidak ditemukan, Ganti Nomor Lain ..... ','n/g')
      LOOP
   ELSE
      if Status == 'INSTK'
         cStatus := 'INSTK'
      else
         cStatus := 'OTSTK'
      endif
      Sele Trss
      Set Relation to Kodbrg into Stk
          aTmp:={}
      While Bukti == cFaktur .and. Tglss == dDate
          aAdd(aTmp,{kodbrg,stk->nama,qtt,harga,ket})
          //Rubah Harga Barang
          if cStatus # 'INSTK'
             REPLACE stk->qtt with stk->qtt+qtt
          ELSE
             REPLACE stk->qtt with stk->qtt-qtt
          endif
          skip
       enddo
      exit
   ENDIF
ENDDO
   setcolor('n/w,n/w')
   akDate:=dDate
   @3,14 get akDate
   read
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:=' Enter -> Edit  '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Simpan Data'
@24,0 say padc(cData,80)
return (nil)



// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
sele trss
seek dDate
   While dDate == Tglss .and. cFaktur # Bukti .and. !eof()
       skip
   enddo
for j:=1 to len(aTmp)

   //Rubah Harga Barang
   sele stk
   dbseek(aTmp[j,1])
   if cStatus == 'INSTK'
      REPLACE Harga WITH aTmp[j,4],qtt with qtt+aTmp[j,3]
   ELSE
      REPLACE Harga WITH aTmp[j,4],qtt with qtt-aTmp[j,3]
   endif

   // Rekam Data Transaksi
   SELE Trss
    fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
    fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
    fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
    fieldput(fieldpos('Ket'),aTmp[j,5])       // Keterangan
    skip
next
If akDate<> dDate
 While .t. 
   seek dDate
   While dDate == Tglss .and. cFaktur # Bukti .and. !eof()
       skip
   enddo
   if Tglss == dDate .and. cFaktur == Bukti
    fieldput(fieldpos('Tglss'),akDate)       // Keterangan
   else
    exit
   endif
 enddo
endif
Return (nil)
