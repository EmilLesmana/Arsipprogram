*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Out.prg                    *
* For Output to Penjualan                 *
*******************************************
memvar getlist
Field Tglout,Faktur,Nama,alamat,Kodbrg,Kodelgn,tglpt,tunai,giro,;
      mobil,qtt,harga,jmlpt,muka,totalut
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@e 99,999,999'}
Static dDate
Static akDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static aTmp
Function Editout()
local ob
Local x,nBrs,nCol
Local mJud,mTpl
Private nElemen
nelemen:=1

geser(2)
buka2()
_mHeader()
_mHelp()
sele Keluar
Set Relation to Kodbrg into Stk
Editheader()
   IF cFAKTUR == 0
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
   X:=EVAL({||Sakti(1,21,'   Faktur Penjualan   ','gr+/bg')})
   Devpos(nBrs,nCol)

   IF X==13
      if ob:colpos==ob:colcount()
         ob:panhome()
         loop
      endif

      if ob:colpos==2 .and. aTmp[nelemen,1] # '003      '
         ob:right()
         ob:Refreshcurrent()
         loop
      endif
      cTmpData:=aTmp[nElemen,1]
      @row(),col() get aTmp[nelemen,ob:colpos] pict apict[ob:colpos]
      read
      sele stk
      if ob:colpos==1
         if aTmp[nelemen,1] == '001      ' .or. aTmp[nelemen,1] == '002      ' ;
            .or. aTmp[nelemen,1] == '003      '
         else
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
         endif
      ENDIF

      IF !fFound(12,39,aTmp[nElemen,1],'gr+/br')
         aTmp[nElemen,1]:=cTmpData
         ob:refreshcurrent()
         LOOP
      ENDIF
      if aTmp[nelemen,1] # '003      '
         aTmp[nElemen,2]:=stk->Nama
      endif
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
         _Hutang()
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
Sakti(1,21,'  Koreksi Penjualan   ','gr+/bg')
@3,2 SAY ' Tanggal : '
@4,2 SAY ' Faktur  : '
@5,2 SAY ' Kod Lgn : '

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
dDate:=Date()
WHILE .T.
   cFaktur:=0
   setcolor('n/w,n/w')
   @3,14 get dDate
   @4,14 get cFaktur pict '@b 99999'
   read
   IF CfAKTUR == 0
      RETURN NIL
   ENDIF
   Sele Keluar
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglout .and. ! Eof()
        skip
   enddo
   If cFaktur # Faktur .or. dDate # Tglout
      Berita(5,39,' No Faktur tidak ditemukan, Ganti Nomor Lain .... ','g/n')
      loop
   endif
   akDate:=dDate
   @3,14 get akDate
   read
   @5,14 say kodeLgn
   SELE Lgn
   IF !fFound(6,39,Keluar->KODelgn,'gr+/bg')
       LOOP
   ENDIF
      setcolor('n/w,n/w')
      @3,50 SAY nama
      @4,50 SAY padr(ALAMAT,25)

   SELE Piutang
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglpt .and. ! Eof()
        skip
   enddo

   If cFaktur==Faktur .and. dDate==Tglpt
   If Keluar->Muka <> Tunai+giro
      Berita(5,39,' Batalkan Pembayaran Piutang .... ','g/n')
      cFaktur:=0
      Return nil
   endif
   else
      Berita(5,39,' Faktur Piutang tidak ditemukan.. ','g/n')
      cFaktur:=0
      Return nil
   endif

   Sele Keluar
   Set Relation to Kodbrg into stk
   aTmp:={}
   While cFaktur == Faktur .and. dDate == Tglout .and. ! Eof()
      aAdd(aTmp,{Kodbrg,If(Kodbrg#'003       ',stk->nama,mobil),qtt,harga,0})
      //Tambah Stok Gudang
      if Kodbrg # '001       ' .and. Kodbrg # '002       ' .and. ;
         Kodbrg # '003       '
         REPLACE stk->Qtt WITH stk->Qtt + qtt
      endif
      skip
   enddo
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglout .and. ! Eof()
        skip
   enddo
   _u:=0
   aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})
   SELE Lgn
   seek Keluar->Kodelgn
   REPLACE TOTALUT WITH TOTALUT - (_u-keluar->MUKA)
   Sele Piutang
   REPLACE JMLPT WITH jmlpt - _u,TUNAI WITH Tunai - Keluar->MUKA
   exit
ENDDO
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:=' Enter -> Edit '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Proses'
@23,2 say ' Isi Kode Barang ---> 001 = Spooring   002 = Balancing  003 = Lain - lain  '
@24,0 say padc(cData,80)
return (nil)



// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
for j:=1 to len(aTmp)

   //Kurangi Stok Gudang
   sele stk
   dbseek(aTmp[j,1])
   if aTmp[j,1] # '001       ' .and. aTmp[j,1] # '002       ' .and. ;
      aTmp[j,1] # '003       '
      REPLACE Qtt WITH Qtt-aTmp[j,3]
   endif

   // Rekam Data Transaksi
   SELE Keluar
    fieldput(fieldpos('qtt'),(aTmp[j,3]))    // Qtt
    fieldput(fieldpos('kodbrg'),(aTmp[j,1]))    // Kodbrg
    fieldput(fieldpos('harga'),(aTmp[j,4]))    // Harga
    if aTmp[j,1] == '003       '
       fieldput(fieldpos('mobil'),(aTmp[j,2]))  // Mobil
    endif
    skip
next
Return (nil)

// proses uang muka
Static Function _Hutang()
**************************************************************************
Local mmuka
Sele Keluar
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglout .and. ! Eof()
        skip
   enddo
MMUKA:=Muka
   _u:=0
   aEval(aTmp,{|e,_au|_u+=aTmp[_au,3]*aTmp[_au,4]})

@19,57 GET MMUKA PICT '@E 99,999,999'
READ
setcolor('w/r')
@20,57 SAY _u-MMUKA PICT '@E 99,999,999'

WHILE dDate == Tglout .and. cFaktur=Faktur .AND. !EOF()
   REPLACE MUKA WITH MMUKA
   SKIP
ENDDO
If akDate <> dDate
While .t.
   seek dDate
   While cFaktur # Faktur .and. dDate == Tglout .and. ! Eof()
        skip
   enddo
    if cFaktur == Faktur .and. dDate == Tglout
       fieldput(fieldpos('tglout'),akDate)    // tglout akhir
    else
       exit
    endif
enddo
endif
SELE Lgn
seek Kodelgn
REPLACE TOTALUT WITH TOTALUT+(_u-MMUKA)

IF (_u-MMUKA)=0
   SELE Piutang
   REPLACE JMLPT WITH _u,TUNAI WITH Tunai+MMUKA,STATUS WITH 'CASH  ',;
           TGLPT with akDate
ELSE
   SELE Piutang
   REPLACE JMLPT WITH _u,TUNAI WITH Tunai+MMUKA,STATUS WITH 'KREDIT',;
           TGLPT with akDate
ENDIF
Return (Nil)