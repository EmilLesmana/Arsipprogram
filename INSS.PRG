*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Inss.prg                   *
* For Input Penyesuaian Stok              *
*******************************************
memvar getlist
Field Tglss,Bukti,Nama,Kodbrg,qtt,;
      kode1,kode2,grp,tgl1,status,harga,ket
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 99,999,999','@!','@!'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static nBrs
Static nCol
Static cStatus
Static Ob
Static aTmp
Static nElemen
Static x
Static Pilih
Static cData

Function Inss()
local Pil,te

geser(2)
buka1()
set color to gr+/b,w/r
@1,2 prompt ' 1. PENAMBAHAN STOK '
@1,col()+2 prompt ' 2. PENGURANGAN STOK '
@1,col()+2 prompt ' 3. keluar '
menu to PIL
IF PIL %3=0
   CLOSE ALL
   RETURN nil
ENDIF

SETCOLOR('')
@1,0
DO CASE
  CASE PIL=1
   TE:=' PENAMBAHAN STOK GUDANG '
   cStatus:='INSTK'
  CASE PIL=2
     cStatus:='OTSTK'
   TE:=' PENGURANGAN STOK GUDANG '
  OTHERWISE
     CLOSE ALL
     RETURN nil
ENDCASE

While .T.
    nElemen:=1
    aTmp:={}
    setcolor('')
    _mHeader()
    sele Trss
    Set Relation to Kodbrg into Stk
    Editheader()
   IF cFaktur=space(6)
      CLOSE ALL
      RETURN nil
   ENDIF
   cBrowse()
   If Pilih==1
      Proses1()
   else
      Proses2()
   endif
Enddo
close all
Return Nil

Static Function cBrowse()
Local c
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
OB:=TBROWSENEW(7,2,16,70)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}
Ob:Colorspec:='Gr+/b,n/g,w/r'

// Add to Objeck Colom
c:=TbColumnNew(' Kode Brg ',{||Tran(aTmp[nelemen,1],'@!')})
c:ColorBlock:={||If(aTmp[nElemen,6]=='T',{1,2},{3,2})}
OB:ADDCOLUMN(c)
c:=TbColumnNew(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')})
c:ColorBlock:={||If(aTmp[nElemen,6]=='T',{1,2},{3,2})}
OB:ADDCOLUMN(c)
c:=TbColumnNew(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:ColorBlock:={||If(aTmp[nElemen,6]=='T',{1,2},{3,2})}
OB:ADDCOLUMN(c)
c:=TbColumnNew(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 99,999,999')})
c:ColorBlock:={||If(aTmp[nElemen,6]=='T',{1,2},{3,2})}
OB:ADDCOLUMN(c)
c:=TbColumnNew(' Keterangan ',{||tran(padr(aTmp[NELEMEN,5],15),'@!')})
c:ColorBlock:={||If(aTmp[nElemen,6]=='T',{1,2},{3,2})}
OB:ADDCOLUMN(c)


OB:HEADSEP:='мям'
OB:COLSEP:= ' Ё '
OB:FOOTSEP:='мом'
Return nil

Static Function Proses1()
Local mjud,Mtpl
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

      if ob:colpos==1
         SELE STK
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KODBRG','NAMA BARANG'}
            mTpl:={'KODBRG','NAMA'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF
         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            ob:refreshcurrent()
            LOOP
         ENDIF
         aTmp[nElemen,2]:=stk->Nama
      ENDIF

      If ob:colpos == 1
         aTmp[nElemen,4]:=stk->Harga
      endif
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

   if x==43
      ob:gobottom()
      ob:home()
      while !ob:stabilize() ; end
      if aTmp[nelemen,ob:colpos]==space(10)
         berita(row()+1,39,' Penambahan, Tidak Bisa dilakukan ','gr/n')
         LOOP
      endif
      aadd(aTmp,{space(10),space(20),0,0,space(15),'T'})
      ob:panhome()
      ob:gobottom()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

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
return(nil)

Static Function Proses2()
Local mjud,Mtpl
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

      if ob:colpos==1
         SELE STK
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KODBRG','NAMA BARANG'}
            mTpl:={'KODBRG','NAMA'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF

         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            ob:refreshcurrent()
            LOOP
         ENDIF
         aTmp[nElemen,2]:=stk->Nama
      Endif


      If ob:colpos == 1
         aTmp[nElemen,4]:=stk->Harga
      endif
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

   if x==7
      If(aTmp[nElemen,6]=='T',aTmp[nElemen,6]:='F',aTmp[nElemen,6]:='T')
      ob:Panhome()
      ob:Refreshcurrent()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

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
return(nil)

Static Function _mheader()
**************************************************************************
// HEADER FORM
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,44,'r/bg')
keyboard(chr(13))
if cStatus == 'INSTK'
   Sakti(1,21,'   Penambahan Stok   ','gr+/bg')
else
   Sakti(1,21,'   Pengurangan Stok   ','gr+/bg')
endif
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
cFaktur:=space(6)
WHILE .T.
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

   IF cFaktur==Bukti
      If cStatus#Status
         Berita(5,30,' Nomor Sudah terpakai Ganti Nomor Lain .....  ','n/g')
         cFaktur:=space(6)
         exit
      endif
      While cFaktur==Bukti .and. dDate==Tglss .and. ! Eof()
          aAdd(aTmp,{Kodbrg,stk->Nama,Qtt,Harga,Ket,'T'})
          skip
     enddo
     Setcolor('r/bg')
     cData:='Delete->Hapus data  Enter->Edit   Esc->Batal Proses  '+;
     '"*"->Simpan Data'
     @24,0 say padr(cData,80)
     Pilih:=2
   ELSE
     aAdd(aTmp,{space(10),space(20),0,0,space(15),'T'})
     Setcolor('r/bg')
     cData:='"+"->Tambah data  Enter->Edit   Esc->Batal Proses  '+;
     '"*"->Simpan Data'
     @24,0 say padr(cData,80)
     Pilih:=1
  endif
  exit
enddo
Return Nil


// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
Sele Trss
seek dDate
WHILE dDate=TGLss .AND. cFaktur#Bukti .AND. !EOF()
    SKIP
ENDDO

for j:=1 to len(aTmp)
    If Pilih==1
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
       dbappend()
       fieldput(1,dDate)          // Tglin
       fieldput(2,cFaktur)        // Bukti
       fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
       fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
       fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
       fieldput(fieldpos('status'),cStatus)
       fieldput(fieldpos('Ket'),aTmp[j,5])       // Keterangan
   else
      If aTmp[J,6]=='F'
         //Rubah Harga Barang
         sele stk
         dbseek(aTmp[j,1])
         if cStatus == 'INSTK'
            REPLACE qtt with qtt-aTmp[j,3]
         ELSE
            REPLACE qtt with qtt+aTmp[j,3]
         endif

         // Rekam Data Transaksi
         SELE Trss
         delete
      else
         If Trss->Kodbrg==aTmp[J,1]
            //Rubah Harga Barang
            sele stk
            dbseek(aTmp[j,1])
            if cStatus == 'INSTK'
               REPLACE qtt with qtt+(aTmp[j,3]-Trss->qtt)
            ELSE
               REPLACE qtt with qtt-(aTmp[j,3]-Trss->qtt)
            endif
        else
            //Rubah Harga Barang
            sele stk
            dbseek(aTmp[j,1])
            if cStatus == 'INSTK'
               dbseek(aTmp[j,1])
               REPLACE qtt with qtt+aTmp[j,3]
               dbseek(TRSS->Kodbrg)
               REPLACE qtt with qtt-aTmp[j,3]
            ELSE
               dbseek(aTmp[j,1])
               REPLACE qtt with qtt-aTmp[j,3]
               dbseek(TRSS->Kodbrg)
               REPLACE qtt with qtt+aTmp[j,3]
            endif
        endif

         // Rekam Data Transaksi
         SELE Trss
         fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
         fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
         fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
         fieldput(fieldpos('status'),cStatus)
         fieldput(fieldpos('Ket'),aTmp[j,5])       // Keterangan
      Endif
   endif
   skip
next
Return (nil)
