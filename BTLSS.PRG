*******************************************
* Compile    : /m/n/a/z/v/w/b             *
* Name       : Inss.prg                   *
* For Input Penyesuaian Stok              *
*******************************************
memvar getlist
//Field Kodbrg,Kodpmsk,Nama,Alamat,Nobpb,Tglin,MUKA,TUNAI,;
//      TGLHT,KODPMS,STATUS,QMTR,QYDS,QPCS,HARGA,TOTALHT
Static _u
Static n:=1
Static apict:={'@!','@!','@e 9,999','@e 9,999,999','@!'}
Static dDate
Static cFaktur
Static ckodPMSK
Static cTmpData
Static cStatus
Static aTmp
Function Btlss()
local ob,c
Local x,nBrs,nCol
Local mJud,mTpl
Private nElemen
nelemen:=1

geser(2)
buka1()
While .t.
_mHeader()
_mHelp()
sele Trss
Set Relation to Kodbrg into Stk
Editheader()
   IF cFaktur=space(6)
      CLOSE ALL
      RETURN nil
   ENDIF

//aAdd(aTmp,{space(10),space(20),0,0,space(15)})
// Trio Block Tbrowse
Setcolor('gr+/b,w/r')
ob:=TBROWSENEW(7,2,16,70)
OB:GOTOPBLOCK:={||NELEMEN:=1}
OB:GOBOTTOMBLOCK:={||NELEMEN:=LEN(aTmp)}
OB:skipblock:={|N|SKIPARRAY(LEN(aTmp),@NELEMEN,n)}

// Add to Objeck Colom
ob:ColorSpec:='gr+/b,g/n,w/r,g/n'
c:=TBCOLUMNNEW(' Kode Brg ',{||Tran(aTmp[nelemen,1],'@!')})
c:Colorblock:={||if(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Nama Barang ',{||tran(aTmp[nelemen,2],'@!')})
c:Colorblock:={||if(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Qtt ',{||tran(aTmp[NELEMEN,3],'@e 9,999')})
c:Colorblock:={||if(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Harga ',{||tran(aTmp[NELEMEN,4],'@e 9,999,999')})
c:Colorblock:={||if(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
OB:ADDCOLUMN(c)
c:=TBCOLUMNNEW(' Keterangan ',{||tran(padr(aTmp[NELEMEN,5],15),'@!')})
c:Colorblock:={||if(aTmp[nElemen,6] # 'F',{1,2},{3,4})}
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
   if cStatus == 'INSTK'
      X:=EVAL({||Putar(1,23,'  Batal Penambahan Stok  ','gr+/bg')})
   else
      X:=EVAL({||Putar(1,23,'  Batal Pengurangan Stok  ','gr+/bg')})
   endif

   Devpos(nBrs,nCol)

   IF X==7
      if(aTmp[nElemen,6] # 'F',aTmp[nElemen,6]:='F',;
                     aTmp[nElemen,6]:='T')
      ob:refreshcurrent()
   endif

   If x == 42
      traRtoFi(aTmp)
      Berita(5,39,' Prosess Selesai, tekan sembarang tombol .... ','g/n')
      EXIT
   endif
   KEY(X,OB)
END
Enddo
return(nil)

Static Function _mheader()
**************************************************************************
// HEADER FORM
@0,0,23,79 BOX REPLI(CHR(178),9)
sBox(0,21,2,49,'r/bg')
Keyboard(chr(13))
   Putar(1,23,'  Batal Penyesuaian  ','gr+/bg')
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

   IF cFaktur # Bukti
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
      While cFaktur == Bukti .and. dDate == Tglss .and. ! Eof()
          aAdd(aTmp,{kodbrg,stk->nama,qtt,harga,ket,' '})
          skip
       enddo
      exit
   ENDIF
ENDDO
Return (nil)


Static Function _mHelp()
**************************************************************************
Local cData
Setcolor('r/bg')
cData:=' "DELETE ==> Pembatalan"  '+;
        chr(24)+' '+chr(25)+' '+chr(26)+' '+chr(27)+'   '+'"*" -> Proses Data'
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
   IF AtMP[J,6] == 'F'
      dbseek(aTmp[j,1])
      if cStatus # 'INSTK'
         REPLACE qtt with qtt+aTmp[j,3]
      ELSE
         REPLACE qtt with qtt-aTmp[j,3]
      endif
   endif
   
      SELE Trss
   IF AtMP[J,6] == 'F'
      Delete
   endif
   skip
next
Return (nil)
