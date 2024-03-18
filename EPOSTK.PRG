*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Postk.prg                  *
* For Input Barang                        *
*******************************************
memvar getlist
Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,Tglin,MUKA,TUNAI,;
      TGLHT,KODPMS,STATUS,sisa,bukti,Qtt,HARGA,TOTALHT
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@e 99,999,999'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static cBukti
Static aTmp
Static eLemen1

Function ePostk()
local ob
Local x,nBrs,nCol
Local mJud,mTpl
Local elemen1,elemen3
Private nElemen
nelemen:=1

geser(3)
buka1()
_mHeader()
_mHelp()
sele Masuk
Set Relation to Kodbrg into Stk
Editheader()
   IF cFaktur=space(8) .or. cbukti=space(8)
      CLOSE ALL
      RETURN nil
   ENDIF

//aAdd(aTmp,{space(10),space(20),0})
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
   X:=EVAL({||Sakti(1,21,'  Koreksi Pemasukan   ','gr+/bg')})
   Devpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2
         ob:right()
         ob:Refreshcurrent()
         loop
      endif
      cTmpData:=aTmp[nElemen,ob:colpos]
      elemen1:=aTmp[nElemen,1]
      elemen3:=aTmp[nElemen,3]
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
            Set order to 1
         ENDIF
      ENDIF

      IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
         aTmp[nElemen,1]:=eLemen1
         ob:refreshcurrent()
         LOOP
      ENDIF

      Sele sem
      IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
         aTmp[nElemen,1]:=eLemen1
         aTmp[nElemen,3]:=elemen3
         ob:refreshcurrent()
         LOOP
      ENDIF
      if ob:colpos # 3
      if sisa < aTmp[nElemen,3]
         Berita(19,39,' Sisa Barang Tidak Mencukupi, Sisa ->'+;
         tran(sisa,'@e 999,999'),'w/r+')
         aTmp[nElemen,1]:=cTmpData
         ob:Refreshall()
         loop
      else
         seek cTmpData
         Replace sisa with sisa + aTmp[nelemen,3]
         seek aTmp[nelemen,1]
         Replace sisa with sisa - aTmp[nelemen,3]
      endif
      endif
      if ob:colpos == 3
         Replace sisa with sisa + cTmpData
      if sisa < aTmp[nElemen,3]
         Berita(19,39,' Sisa Barang Tidak Mencukupi, Sisa ->'+;
         tran(sisa,'@e 999,999'),'w/r+')
         aTmp[nElemen,3]:=cTmpData
         Replace sisa with sisa - cTmpData
         ob:Refreshall()
         loop
      endif
         Replace sisa with sisa - aTmp[nElemen,3]
      endif
      aTmp[nElemen,2]:=stk->Nama
      setcolor('w/r')
      @22,20 say sem->sisa pict '@e 9,999,999'
      if ob:colpos == ob:colcount()
         ob:panhome()
         ob:refreshcurrent()
         loop
       endif
      ob:right()
      ob:refreshall()
   endif

   If x == 42
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
Sakti(1,21,'  Koreksi Pemasukan   ','gr+/bg')
@3,2 SAY ' No.Bukti: '
@4,2 SAY ' Tanggal : '
@5,2 SAY ' No.Bpb  : '

@3,39 SAY ' Nama   : '
@4,39 SAY ' Alamat : '

// Building Work area
sbox(6,1,20,71,'GR+/B,W/R')
@22,2 say ' Sisa Barang --> '
Return (nil)

Static Function EditHeader()
**************************************************************************
Local i
ckodPMSK:=space(3)
sele Masuk
Copy stru to sem.dbf
WHILE .T.
  cBukti:=space(8)
   sele Trstk
   setcolor('n/w,n/w')
   @3,14 get cBukti pict '@!'
   read

   IF cBukti=space(8)
      CLOSE ALL
      RETURN nil
   endif
   seek cBukti
   IF !Found()
      Berita(6,39,' Nomor Tidak ditemukan, ganti nomor lain ...... ','n/bg')
      LOOP
   ELSE
      dDate:=Tglin
      @4,14 get dDate
      read
      cFaktur:=Nobpb
      use sem new
      sele Masuk
      seek cFaktur
      while cFaktur == Nobpb .and. !eof()
         sele sem
         Dbappend()
         For i:=1 to Fcount()
             Fieldput(i,Masuk->(Fieldget(i)))
         next
         sele Masuk
         skip
      end
      sele sem
      index on kodbrg to sem
      set index to sem
      sele masuk
      seek cFaktur
      SELE PMSK
      cKODPMSK:=masuk->PMS
      IF !fFound(6,39,cKODPMSK,'gr+/bg')
         LOOP
      ENDIF
      setcolor('n/w,n/w')
      @3,50 SAY nama
      @4,50 SAY padr(ALAMAT,25)
      @5,14 say cFaktur
      Sele Trstk
      aTmp:={}
      Set Relation to Kodbrg into stk
      While cBukti == Bukti .and. !Eof()
          aAdd(aTmp,{Kodbrg,stk->nama,qtt})
          replace stk->qtt with stk->qtt-qtt
          skip
      enddo
   endif
   exit
ENDDO
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
sele trstk
seek cBukti
sele sem
set order to 0
for j:=1 to len(aTmp)

   //Stok Gudang
   sele stk
   dbseek(aTmp[j,1])
   REPLACE Qtt WITH Qtt+aTmp[j,3]

   // Rekam Data Transaksi
   SELE Trstk
    fieldput(1,dDate)          // Tglin
    fieldput(4,(aTmp[j,3]))    // Qtt
    fieldput(5,(aTmp[j,1]))    // Kodbrg
    skip
next
  SELE SEM
  DBGOTOP()
  SELE MASUK
  SEEK cFaktur
   DO WHILE cFaktur == NOBPB .AND. !EOF()
      replace SISA with SEM->SISA
      SEM->(DBSKIP(1))
      DBSKIP(1)
   ENDDO
Return (nil)