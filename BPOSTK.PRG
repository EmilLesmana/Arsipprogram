*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Postk.prg                  *
* For Input Barang                        *
*******************************************
Memvar getlist
Field Alamat,Sisa,Tglin,nobpb,Faktur,Nama,Kodbrg,catat,tgl1,bukti,;
      mobil,qtt,harga,min,harga1,harga2,harga3,tglss,kodelgn,pms
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

Function BPostk()
local ob,c
Local x,nBrs,nCol
Local mJud,mTpl
Private nElemen
nelemen:=1

geser(3)
buka1()
_mHeader()
_mHelp()
sele Masuk
Set Relation to Kodbrg into Stk
Editheader()
   IF cFaktur=space(8) .or. cBukti=space(8)
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
ob:Colorspec:='gr+/b,n/bg,w/r,g/n'
c:=TBCOLUMNNEW(' Kode Brg ',{||Tran(aTmp[nelemen,1],'@!')})
c:Colorblock:={||If(aTmp[nElemen,4] == 'T',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')})
c:Colorblock:={||If(aTmp[nElemen,4] == 'T',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||If(aTmp[nElemen,4] == 'T',{1,2},{3,4})}
OB:ADDCOLUMN(c)

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
   X:=EVAL({||Putar(1,23,'  Batal Pemasukan  ','gr+/bg')})
   Devpos(nBrs,nCol)

   IF X==7
      If(aTmp[nElemen,4] == 'T',aTmp[nElemen,4] := 'F',aTmp[nElemen,4] := 'T')
      ob:refreshcurrent()
   endif

   If x == 42
      traRtoFi(aTmp)
      Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
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
Putar(1,23,'  Batal Pemasukan  ','gr+/bg')
@3,2 SAY ' No.Bukti: '
@4,2 SAY ' Tanggal : '
@5,2 SAY ' No.Bpb  : '

@3,39 SAY ' Nama   : '
@4,39 SAY ' Alamat : '

// Building Work area
sbox(6,1,20,71,'GR+/B,W/R')
Return (nil)

Static Function EditHeader()
**************************************************************************
Local i
ckodPMSK:=space(3)
sele Masuk
copy stru to sem.dbf
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
      @4,14 say dDate
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
          aAdd(aTmp,{Kodbrg,stk->nama,qtt,'T'})
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
cData:=' Delete -> Pembatalan  '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Proses'
@24,0 say padc(cData,80)
return (nil)



// PUT TO FIELD
Static FUNCTION TRARTOFI(aTmp)
**************************************************************************
Local j
sele trstk
seek cBukti
sele masuk
seek cFaktur
for j:=1 to len(aTmp)

   //Stok Gudang
   sele stk
   If aTmp[j,4] == 'F'
      dbseek(aTmp[j,1])
      REPLACE Qtt WITH Qtt-aTmp[j,3]
   endif

   // Rekam Data Transaksi
   SELE Trstk
    If aTmp[j,4] == 'F'
       Delete
    endif
    sele sem
    If aTmp[j,4] == 'F'
       dbseek(aTmp[j,1])
       Replace sisa with sisa+aTmp[j,3]
    endif
    trstk->(dbskip(1))
next
  SELE SEM
  set order to 0
  DBGOTOP()
  SELE MASUK
  SEEK cFaktur
   DO WHILE cFaktur == NOBPB .AND. !EOF()
      replace SISA with SEM->SISA
      SEM->(DBSKIP(1))
      DBSKIP(1)
   ENDDO
Return (nil)
