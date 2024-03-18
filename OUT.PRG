*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Out.prg                    *
* For Output to Penjualan  Laju-Jaya      *
*******************************************
memvar getlist
#include 'EE.Inten'
Field Kodbrg,Kodelgn,Nama,Alamat,Faktur,Tglout,MUKA,TUNAI,;
      STATUS,QTT,HARGA,TOTALUT
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 99,999,999.99','@e 999,999,999','@e 99,999,999'}
Static dDate
Static nPPN
Static mjumlah
Static nkartu
Static nGiro
Static cBank
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

Function Out()
geser(2)
buka2()
use no.dbf new
While .t.
   aTmp:={}
   _mHeader()
   Editheader()
   IF cfaktur=0
      exit
   ENDIF
   IF cKodpmsk=space(3)
      exit
   ENDIF
   cBrowse()
   If Pilih==1
      Proses2()
   Else
      Proses1()
   Endif
Enddo
dbCommitall()
dbCloseall()
Return Nil

Static Function cBrowse()
nElemen:=1
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
OB:=TBROWSENEW(7,2,15,70)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}
Ob:Colorspec:='gr+/b,n/g,n/r'
// Add to Objeck Colom
c:=TBCOLUMNNEW(' Kode Brg ',{||aTmp[nelemen,1]})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||aTmp[NELEMEN,2]})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 99,999,999.99')})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Jumlah ',{||tran(aTmp[nElemen,3]*aTmp[NELEMEN,4],'@e 999,999,999')})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Hrg+PPN ',{||tran(aTmp[NELEMEN,6],'@e 99,999,999')})
c:Colorblock:={||If(aTmp[nElemen,7]=='F',{3,2},{1,2})}
OB:ADDCOLUMN(c)
SEPARATED OB WITH BSINGLE
Return nil

Static Function Proses1()
Local mJud,mTpl,Tanya:=.N.
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,16,71)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'   Faktur Penjualan   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2 .and. (aTmp[nElemen,1]#'003       ' .and. aTmp[nELemen,1]#'005       ')
         ob:right()
         Loop
      endif

      If ob:Colpos==5
         ob:PanHome()
         loop
      endif

      If ob:Colpos==4
         ob:PanHome()
         loop
      endif

      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read

      If ob:Colpos==6
         aTmp[nElemen,4]:=aTmp[nElemen,ob:colpos]*(100/(nPPN+100))
      endif


      
      SELE STK
      if ob:colpos==1
         if aTmp[nElemen,1]=='001       ' .or. aTmp[nElemen,1]=='002       ';
            .or. aTmp[nElemen,1]=='003       '
         else
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','Nama'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF
         endif

         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            LOOP
         ENDIF
         If aTmp[nElemen,1]#'003       ' .and. aTmp[nElemen,1]#'005       '
            aTmp[nElemen,2]:=stk->Nama
         endif
      Endif
      setcolor('w/r')
      @22,20 say TRAN(stk->qtt,'@e 9,999')
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
      @18,57 say _u pict apict[5]
      @19,57 say (_u*((nppn+100)/100))-_u pict apict[5]
      @20,57 say _u+((_u*((nppn+100)/100))-_u) pict apict[5]
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
      aAdd(aTmp,{space(10),space(20),0,0,0,0,'T'})
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
         Setcolor('w/r,gr+/b')
         @5,15 say ' Apakah Data akan di Cetak [Y/N] ?' Get Tanya Pict 'Y'
         Read
         If Tanya
            Cetak(aTmp)
         Endif
         Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      endif
      EXIT
   endif
   KEY(X,OB)
END
return(nil)

Static Function Proses2()
Local mJud,mTpl,Tanya:=.N.
WHILE .T.
   WHILE !OB:STABILIZE()
   END
   nBrs:=ROW() ; nCol:=COL()
   if ob:hitbottom
      berita(15,39,' Akhir Data .............  ','gr+/bg')
   elseif ob:hittop
      berita(15,39,' Awal Data ........  ','n/g')
   endif
   Showind(ob,len(aTmp),nElemen,16,71)
   setcolor('R/bg')
   X:=EVAL({||Putar(1,23,'   Faktur Penjualan   ','w/r')})
   Setpos(nBrs,nCol)

   IF X==13
      if ob:colpos==2 .and. (aTmp[nElemen,1]#'003       ' .and. aTmp[nElemen,1]#'005       ')
         ob:right()
         Loop
      endif

      If ob:Colpos==5
         ob:PanHome()
         loop
      endif

      If ob:Colpos==4
         ob:PanHome()
         loop
      endif


      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read

      If ob:Colpos==6
         aTmp[nElemen,4]:=aTmp[nElemen,ob:colpos]*(100/(nppn+100))
      endif


      SELE STK
      if ob:colpos==1
         if aTmp[nElemen,1]=='001       ' .or. aTmp[nElemen,1]=='002       ';
            .or. aTmp[nElemen,1]=='003       ' .or. aTmp[nElemen,1]=='005       '
         else
         IF aTmp[nElemen,1]=space(10)
            SAVE SCREEN
            mJud:={'KodBrg','Nama Barang'}
            mTpl:={'KODBRG','Nama'}
            sBox(9,1,21,60,'R/Bg,W/R')
            dBedit(10,2,20,59,MTPL,'','',MJUD)
            RESTORE SCREEN
            aTmp[nElemen,1]:=stk->KODBRG
         ENDIF
         endif

         IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
            aTmp[nElemen,1]:=space(10)
            LOOP
         ENDIF
         if aTmp[nElemen,1]#'003       ' .and. aTmp[nElemen,1]#'005       '
            aTmp[nElemen,2]:=stk->Nama
         endif
      Endif
      setcolor('w/r')
      @22,20 say TRAN(stk->qtt,'@e 9,999')
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,7]=='T',_u+=aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,57 say _u pict apict[5]
      @19,57 say (_u*((nppn+100)/100))-_u pict apict[5]
      @20,57 say _u+((_u*((nppn+100)/100))-_u) pict apict[5]
      ob:right()
      ob:refreshall()
   endif

   IF X==27
      Berita(15,39,' Tidak ada Prosess penyimpanan data, tekan sembarang tombol ... ','br/n')
      EXIT
   ENDIF

   If x ==7
      If(aTmp[nElemen,7]=='F',aTmp[nElemen,7]:='T',aTmp[nElemen,7]:='F')
      _u:=0
      aEval(aTmp,{|e,_au|If(aTmp[_au,7]=='T',_u+=aTmp[_au,3]*aTmp[_au,4],_u)})
      @18,57 say _u pict apict[5]
      @19,57 say (_u*((nppn+100)/100))-_u pict apict[5]
      @20,57 say _u+((_u*((nppn+100)/100))-_u) pict apict[5]
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
      aAdd(aTmp,{space(10),space(20),0,0,0,0,'T'})
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
         Setcolor('w/r,gr+/b')
         @5,15 say ' Apakah Data akan di Cetak [Y/N] ?' Get Tanya Pict 'Y'
         Read
         If Tanya
            Cetak(aTmp)
         Endif
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
sBox(0,21,2,48,'r/bg')
Keyboard(chr(13))
Sakti(1,21,'   Faktur Penjualan   ','gr+/bg')
@3,2 SAY ' Faktur  : '
@3,17 SAY ' PPN  : '
@4,2 SAY ' Tanggal : '
@5,2 SAY ' Kod Lgn : '

@3,39 SAY ' Nama   : '
@4,39 SAY ' Alamat : '
@5,39 SAY ' P P N  : '

/* Building Work area
sbox(18,0,23,36,'GR+/B,W/R')
@19,1 say ' Keterangan : '*/
// Building Work area
sbox(6,1,17,71,'GR+/B,W/R')
sbox(17,37,21,71,'GR+/B,W/R')
@18,38 say ' Jumlah   :Rp.'
@19,38 say ' P P N    :Rp.'
@20,38 say ' Total    :Rp.'
@22,5 say ' Stok Gudang = '
Return (nil)

Static Function EditHeader()
**************************************************************************
Local mJud,mTpl,cHelp
dDate:=Date()
ckodPMSK:=space(3)
nPPn:=11
WHILE .T.
   Sele Trout
   Set Relation To Faktur into Put,to Kodbrg into stk
   cFaktur:=no->Nomor
   setcolor('n/w,n/w')
   @3,14 Get cFaktur pict '99999'
   @3,25 Get nPPN pict '99'
   Read

   If cFaktur==0
      Return nil
   Endif
   Sele Trout
   seek cFaktur
   If Found()
      Sele Trpt
      Dbseek(CFaktur)
      If Found()
         Berita(5,39,' Batalkan Pembayaran Piutang .... ','g/n')
         cFaktur:=0
         Return Nil
      Endif
      Sele Trout
      dDate:=Tglout
      cKodpmsk:=Put->Kodelgn
      While Tglout==dDate .and. Faktur==Cfaktur .and. !Eof()
         Aadd(aTmp,{Kodbrg,If(Kodbrg#'003       ' .and. kodbrg#'005       ',stk->Nama,Mobil),qtt,Hargat*(100/(nPpn+100)),0,hargat,'T'})
         Skip
      Enddo
      nArray:=Len(aTmp)
      _u:=0
      aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
      @18,57 say _u pict apict[5]
      @19,57 say (_u*((nPPN+100)/100))-_u pict apict[5]
      @20,57 say _u+((_u*((nPPN+100)/100))-_u) pict apict[5]
      Pilih:=1
      Setcolor('r/bg')
      cHelp:='"+" -> Tambah  Enter -> Edit   Esc -> Batal Proses  '+;
      chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Simpan Data'
      @23,2 say ' Isi Kode Barang ---> 001 = Spooring   002 = Balancing  003 = Lain - lain  '
      @24,0 say padr(cHelp,80)
   Else
      If Trout->(LastRec())#0 .and. cFaktur#No->Nomor
         cFaktur:=0
         return nil
      Endif
      aAdd(aTmp,{space(10),space(20),0,0,0,0,'T'})
      Setcolor('r/bg')
      cHelp:='"+"->Tambah data  Enter->Edit  Esc->Batal Proses  '+;
             '"*"->Simpan Data'
      @23,2 say ' Isi Kode Barang ---> 001 = Spooring   002 = Balancing  003 = Lain - lain  '
      @24,0 say padc(cHelp,80)
      Pilih:=2
   Endif

   @4,14 get dDate
   @5,14 get ckodPMSK pict '@!'
   read
   SELE Lgn
   set order to 2
      IF cKODPMSK=space(3)
         SAVE SCREEN
         MJUD:={'Kode','Nama','Alamat'}
         MTPL:={'KODelgn','NAMA','Alamat'}
         SBOX(4,29,21,69,'R/Bg,W/R')
         DBEDIT(5,30,20,68,MTPL,'','',MJUD)
         RESTORE SCREEN
         IF LASTKEY()=27
            CLOSE ALL
            RETURN nil
         ENDIF
         cKODPMSK:=KODelgn
      ENDIF
   set order to 1
      IF !fFound(6,39,cKODPMSK,'gr+/bg')
         LOOP
      ENDIF
      setcolor('n/w,n/w')
      @5,14 SAY ckodPMSK pict '@!'
      @3,50 SAY nama
      @4,50 SAY substr(ALAMAT,1,25)
      @5,50 SAY substr(ALAMAT,26,15)
   exit
ENDDO
Return (nil)

// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
Sele Trout
Dbseek(cFaktur)
for j:=1 to len(aTmp)
   If Pilih==2
      //Kurangi Stok Gudang
      sele stk
      dbseek(aTmp[j,1])
      if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
         aTmp[j,1] # '003       ' .and. aTmp[j,1] # '005       '
         REPLACE Qtt WITH Qtt-aTmp[j,3]
      endif
      // Rekam Data Transaksi
      SELE Trout
      dbappend()
      fieldput(1,dDate)          // Tglout
      fieldput(2,cFaktur)        // Faktur
      fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
      fieldput(fieldpos('Mobil'),(aTmp[j,2]))    // Kodbrg
      fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
      fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
      fieldput(fieldpos('hargaT'),(aTmp[j,6]))    // Harga
   Else
      sele stk
      If aTmp[j,7]=='T'
         If aTmp[j,1]==Trout->Kodbrg
            dbseek(aTmp[j,1])
            if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
               aTmp[j,1] # '003       ' .and. aTmp[j,1] # '005       '
               REPLACE Qtt with qtt-(aTmp[j,3]-trout->qtt)
            Endif
         Else
            dbseek(Trout->Kodbrg)
            if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
               aTmp[j,1] # '003       ' .and. aTmp[j,1] # '005       '
               REPLACE qtt WITH qtt+Trout->qtt
            Endif
            dbseek(aTmp[j,1])
            if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
               aTmp[j,1] # '003       ' .and. aTmp[j,1] # '005       '
               REPLACE qtt WITH qtt-aTmp[j,3]
            Endif
         Endif

         // Rekam Data Transaksi
         SELE Trout
         If nArray>=J
            fieldput(fieldpos('Tglout'),ddate)    // Qpcs
            fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
            fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
            fieldput(fieldpos('Mobil'),(aTmp[j,2]))    // Qyds
            fieldput(fieldpos('Harga'),(aTmp[j,4]))    // Harga
            fieldput(fieldpos('HargaT'),(aTmp[j,6]))    // Harga
         Else
            dbappend()
            fieldput(1,dDate)          // Tglout
            fieldput(2,cFaktur)        // Faktur
            fieldput(fieldpos('Qtt'),(aTmp[j,3]))    // Qyds
            fieldput(fieldpos('Kodbrg'),(aTmp[j,1]))    // Kodbrg
            fieldput(fieldpos('Mobil'),(aTmp[j,2]))    // Qyds
            fieldput(fieldpos('Harga'),(aTmp[j,4]))    // Harga
            fieldput(fieldpos('HargaT'),(aTmp[j,6]))    // Harga
         Endif
      else
         Sele stk
         dbseek(TrOUT->Kodbrg)
         if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
            aTmp[j,1] # '003       ' .and. aTmp[j,1] # '005       '
            REPLACE qtt WITH qtt+TrOUT->qtt
         Endif
         Sele Trout
         Delete
      endif
   Endif
   dbSkip()
next
Return (nil)

// proses uang muka
Static Function _Hutang(dDate,cFaktur,cKodpmsk,sJUMLAH)
**************************************************************************
Local MMUKA
mjumlah:=sjumlah*((nPPN+100)/100)
mmuka:=0
Sele Put
dbseek(cFaktur)

/*If Found()
   if mjumlah==0
      mmuka:=0
   else
      mmUKA:=Tunai
   endif
else
      mmuka:=0
Endif
@19,57 get MMUKA PICT '@E 999,999,999'
read
*/

setcolor('w/r')
@20,57 SAY MJUMLAH PICT '@E 999,999,999'
If Pilih==2
   SELE Lgn
   dbseek(cKodpmsk)
   REPLACE Totalut WITH Totalut+(mjumlah-MMUKA)
else
      SELE Lgn
   If cKodpmsk==Put->Kodelgn
      dbseek(Put->Kodelgn)
      REPLACE Totalut WITH Totalut+((mjumlah-MMUKA)-;
      (Put->JmlPt-Put->Tunai))
   Else
      dbseek(Put->Kodelgn)
      REPLACE Totalut WITH Totalut-(Put->Jmlpt-Put->Tunai)
      dbseek(cKodpmsk)
      REPLACE Totalut WITH Totalut+(mJumlah-MMUKA)
   endif
endif

SELE Put
If Pilih==2
   If mJumlah-mMuka<=0
      DBAPPEND()
      REPLACE TGLout WITH DDATE,Faktur WITH CFAKTUR,Tunai WITH MMUKA,;
      kodelgn with ckodpmsk,JmlPt WITH MJUMLAH,Status with 'L'
   else
      DBAPPEND()
      REPLACE TGLout WITH DDATE,Faktur WITH CFAKTUR,Tunai WITH MMUKA,;
      kodelgn with ckodpmsk,JmlPt WITH MJUMLAH,Status with 'H'
   endif
   Replace No->Nomor with cFaktur+1
Else
   Sele Trout
   Dbseek(cFaktur)
   If !Found()
      SELE PUT
      dbseek(cFaktur)
      If Found()
         delete
      endif
   else
      SELE PUT
      REPLACE Tunai WITH MMUKA,kodelgn with ckodpmsk,;
      JmlPt WITH MJUMLAH,Tglout with dDate
   endif
Endif
dbCommitaLL()
Return (Nil)

Static Function Cetak(aTmp)
Local j

Sele Trout
dbseek(cFaktur)
IF !found()
   Berita(15,39,' Faktur sudah Kosong, tekan sembarang tombol .... ','br/n')
   Return nil
ENDIF
IF !CEKPRINT()
   return nil
ENDIF
sele put
set relation To Kodelgn into Lgn
dbseek(cFaktur)
nPot:=Tunai
Sele Lgn
cNama:=Nama
cNpwp:=NPWP
cAlamat:=Alamat
sele Trout
@0,28 SAY ' FAKTUR PENJUALAN '
@1,0 say 'LAJU JAYA, CV'
@1,39 say 'Pembeli      :'+padr(cNama,25)
@2,39 say 'Alamat       :'+substr(cAlamat,1,25)
@3,0 SAY 'Jl.PLN Dalam 208/203 B, Bandung '
@3,39 say '              '+substr(cAlamat,26,15)
@4,0 say 'NPWP/NPPKP   :02.235.508.5.424.000'
//@4,0 SAY 'Tgl.Pengukuhan : 23 Juli 2003'
@4,39 say 'NPWP/NPPKP   :'+PADR(cNpwp,25)

@5,0 SAY 'NO.Invoice   :'+TRAN(cFaktur,'@B 99999')
@5,39 say 'Tanggal Beli :'+dtoc(dDate)
BR:=9;JUM:=0;TOT:=0;MTOT:=0;I:=11
@6,0 SAY REPLI('-',79)
@7,0 SAY '| NO |      NAMA BARANG        |HARGA NETTO|  QTT  |   HARGA   |   JUMLAH     |'
@8,0 SAY REPLI('-',79)
NO:=0
j:=0
DO WHILE ! EOF() .AND. cFAKtur==FAKTUR
   NO++
   j++
   @BR,0 SAY '|'+TRAN(NO,'@B 9999')+'|'
   @BR,7 SAY (IF(KODBRG#'003       ',PADR(STK->NAMA,24),PADR(MOBIL,24)))+'|'
   @BR,33 SAY TRAN(aTmp[J,6],'@E 99,999,999')+'|'
   @BR,45 SAY TRAN(QTT,'@E 99,999')+'|'
   @BR,53 SAY HARGA PICT '@E 99,999,999'+'|'
   TOT:=QTT*HARGA
   @BR,65 SAY TOT PICT '@E 9,999,999,999'+'|'
   MTOT+=TOT
   I++
   BR++
   SKIP
ENDDO

@BR,0 SAY '|'
@BR,5 SAY '|'
@BR,31 SAY '|'
@BR,43 SAY '|'
@BR,51 SAY '|'
@BR,63 SAY '|'
@BR,64 SAY REPLI('-',14)
@BR,78 SAY '|'

BR++
@BR,0 SAY '|'
@BR,5 SAY '|'
@BR,31 SAY '|'
@BR,43 SAY '|'
@BR,51 SAY '|'
@BR,63 SAY '|'
@BR,64 SAY 'Rp'
@BR,67 SAY MTOT PICT '@E 999,999,999'
@BR,78 SAY '|'

BR++
DO WHILE I<24
   @BR,0 SAY '|'
   @BR,5 SAY '|'
   @BR,31 SAY '|'
   @BR,43 SAY '|'
   @BR,51 SAY '|'
   @BR,63 SAY '|'
   @BR,78 SAY '|'
   BR++
   I++
ENDDO

@BR,0 SAY REPLI('-',79)
@BR+1,3 SAY ' Tanda - Terima '
@BR+1,53 SAY 'JUMLAH     Rp.'
@BR+1,67 SAY MTOT PICT '@E 999,999,999'
@BR+2,3 SAY '                   Barang yang sudah dibeli '
@BR+2,53 SAY 'P P N      Rp.'
@BR+2,67 SAY (mtot*((nPPn+100)/100))-MTOT PICT '@E 999,999,999'
@BR+3,3 SAY '                   tidak dpt dikembalikan '
@BR+3,46 SAY 'Jml Yg Harus diBAYAR '
@BR+3,67 SAY ((mtot*((nPPN+100)/100))-MTOT)+mTot PICT '@E 999,999,999'
@BR+4,3 SAY '                   Jatuh Tempo: ......... '
@BR+4,67 SAY '============'
@br+5,0 say ' '
@BR+6,0 SAY ' '
@BR+7,0 SAY ' '
@BR+8,0 SAY ' '
SETPRC(0,0)
SET PRINT OFF
SET DEVICE TO SCREEN
SET COLOR TO
RETURN nil
