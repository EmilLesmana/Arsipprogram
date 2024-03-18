* ------------------------------------- *
* Nama Program : SBB.PRG                *
* Judul        : Program Utama          *
* Deskripsi    : Menu utama             *
* ------------------------------------- *
Memvar Getlist
Static Menulist
Static cSave
Static aMenu1
Static aMenu2
Static aMenu3
Static aMenu4
Static aMenu5
Static aLogo
Static bLogo
#include "EE.INTEN"

Function Ljjy(cKey)
Local Deferr := ErrorBlock()
Local cTanya
Static horiz:=1
set status off
set score off
set date itali
set exact on
set confirm on
set wrap on
SET DELE ON
SET CURSOR OFF
SET CENTURY ON
Set Key 9 to Help()
ErrorBlock({|e|Mydeferror(e,Deferr)})
Request DbfCdx
RddSetDefault("DbfCdx")
Menulist:={}
 aLogo:=;
        {' Ë             Ë        Ë   Ë     Ë          Copy Right '       ,;
         ' º             º        º   º     º                     '       ,;
         ' º             º        º   ÈÍÍËÍÍ¼            1 9 9 9  '       ,;
         ' º        Ë    º   Ë    º      º                        '       ,;
         ' ÊÍÍÍÍ¼   ÈÍÍÍÍ¼   ÈÍÍÍÍ¼      Ê          by Ir. Emil L '}
bLogo:={||setcolor('r/bg'),devpos(19,11),devout(aLogo[1]),;
          devpos(20,11),devout(aLogo[2]),;
          devpos(21,11),devout(aLogo[3]),;
          devpos(22,11),devout(aLogo[4]),;
          devpos(23,11),devout(aLogo[5])}

If !File('No.dbf')
   dBcreate('No.Dbf',{{'NOMOR','N',5,0},;
                      {'Sandi','m',10,0},;
                      {'Sandi1','m',10,0},;
                      {'Sandi2','m',10,0}},'dbfcdx')
   Use No.dbf
   DbAppend()
   Replace NOMOR WITH 3800,Sandi with '58',Sandi1 with '20',Sandi2 with '08'
   use
   If !Kunci('No.dbf',1)
      mylogo(,2)
      Return nil
   endif
Else
   If !Kunci('No.dbf',1)
      mylogo(,2)
      Return nil
   endif
Endif

geser(1)
Use No.dbf
IF !SANDI(15,Sandi1)
   SET CURSOR ON
   SET COLOR TO
   CLOSE ALL
   Kunci('No.dbf',0)
   CLEAR
   Return (nil)
ENDIF
Use
cTanya:=.n.
if !file('stk.dmt') .or. !File('Trin.Dtr')
   If cKey=='EE'
   setcolor('')
   cls
   Berita(2,39,' Pembacaan Drive --> '+curdir()+' Gagal ......... ','w+/r')
   setcolor('gr+/b,w/r')
   @5,2 say ' Apakah akan dibuatkan "Data Kosong"  [Y/N] ' get cTanya pict 'Y'
   read
   if !cTanya
      Return nil
   endif
   else
      Mylogo(,4)
      close all
      Kunci('no.dbf',0)
      geser(3)
      return nil
   endif
endif

BARU()
setcolor("")

/*IF !FILE('C:\DOS\TMP.EXE') .AND. !FILE('C:\WINDOWS\COMMAND\TMP.EXE')
      Mylogo(,4)
      close all
      Kunci('no.dbf',0)
      geser(3)
   SETCURSOR(1)
   QUIT
ELSEIF !FILE('C:\DOS\ARJ.EXE') .AND. !FILE('C:\WINDOWS\COMMAND\ARJ.EXE')
      Mylogo(,4)
      close all
      Kunci('no.dbf',0)
      geser(3)
   SETCURSOR(1)
   QUIT
ENDIF*/
      setcolor('n+/n')
      @0,0,24,79 box repli(chr(178),9)
      @1,1,1,78 box repli(chr(219),9)
      setcolor('gr')
      @0,0 to 24,79 double
      @2,0 to 4,79 double
      SET COLOR TO GR+/B,W/R+
      sDate(1,2,date())
      set key 19 to
      set key 4 to
      @3,1 PROMPT ' 1.Arsip Data ' POSITION 2 HIGHLITE r/b
      @3,16 PROMPT ' 2.Transaksi   ' POSITION 2 HIGHLITE r/b
      @3,33 PROMPT ' 3.Laporan ' POSITION 2 HIGHLITE r/b
      @3,47 PROMPT ' 4.Utility ' POSITION 2 HIGHLITE r/b
      Store Menu to aMenu1
      eval(bLogo)
      setcolor("gr+/b")
      @24,0 say Padl(' "ESC ==> Keluar"        '+;
                     '                                      "TAB ==> Help" ',80)
While .t.
      SET COLOR TO GR+/B,W/R+
      Menu to horiz with aMenu1 Row 1 Col 30 Display " Laju - Jaya " ;
                        Color w/r
      cSave:=savescreen(0,0,24,79)
      set key 19 to
      set key 4 to
      DO CASE
         CASE HORIZ %5==0
              mylogo(,4)
              geser(2)
              use no
              //browse()
              close all
              Kunci('no.dbf',0)
              quit
         CASE HORIZ=1
              Menu1()
         CASE HORIZ=2
              Menu2()
         CASE HORIZ=3
              Menu3()
         CASE HORIZ=4
              Menu4()
      ENDCASE
      restscreen(0,0,24,79,cSave)
ENDDO
Return (nil)

Static Function Menu1
Static vert:=1
While .t.
      SET COLOR TO GR+/B,W/R+
       set key 19 to tmlkr()
       set key 4 to tmlkn()
       // eval(bLogo)
      SBOX(5,1,11,21,'n/w+,w+/r')
      PROMPT ' BARANG        ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMASOK           ' POSITION 2 HIGHLITE r/w+
      PROMPT ' LANGGANAN         ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Rubah Sandi       ' POSITION 8 HIGHLITE r/w+
      PROMPT ' Pengeluaran Kas   ' POSITION 3 HIGHLITE r/w+
      Store Menu to aMenu2
      MenuRowCol(aMenu2,6,2)
      MenuPadr(aMenu2,19,'.')
      Menu to Vert with aMenu2 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                     tRow 1 tCol 70 tColor w/r
      set key 19 to
      set key 4 to
      DO CASE
         CASE VERT %6=0
              restscreen(0,0,24,79,cSave)
              EXIT
         CASE VERT=1
              INBRG()
        CASE VERT=2
              INPMSK()
        CASE VERT=3
              INLGN()
        CASE VERT=4
              Use no.dbf
              Rsandi()
              Use
        CASE VERT=5
              Kas1()
     ENDCASE
     restscreen(0,0,24,79,cSave)
ENDDO
Return (nil)

Static Function Menu2
Static vert2:=1
While .t.
    SET COLOR TO GR+/B,W/R+
       set key 19 to tmlkr()
       set key 4 to tmlkn()
       // eval(bLogo)
      set cursor off
      SBOX(5,16,15,38,'n/w+,w+/r')
      PROMPT ' PEMBELIAN           ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMASUKAN BARANG    ' POSITION 8 HIGHLITE r/w+
      PROMPT ' PENJUALAN           ' POSITION 5 HIGHLITE r/w+
      PROMPT ' PENYESUAIAN STOK    ' POSITION 14 HIGHLITE r/w+
      PROMPT ' PEMBAYARAN          ' POSITION 5 HIGHLITE r/w+
      PROMPT ' BATAL PEMBAYARAN    ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMASUKAN STOK AWAL ' POSITION 8 HIGHLITE r/w+
      PROMPT ' HUTANG  AWAL        ' POSITION 10 HIGHLITE r/w+
      PROMPT ' PIUTANG  AWAL       ' POSITION 8 HIGHLITE r/w+
      Store Menu to aMenu3
      MenuRowCol(aMenu3,6,17)
      MenuPadr(aMenu3,21,'.')
    Menu to Vert2 with aMenu3 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                   tRow 1 tCol 70 tColor w/r
    set key 19 to
    set key 4 to
    setcursor(1)
    DO CASE
       CASE VERT2 %10=0
            restscreen(0,0,24,79,cSave)
            EXIT
       CASE VERT2=1
            IN()
       CASE VERT2=2
            INSTK()
       CASE VERT2=3
            OUT()
       CASE VERT2=4
            INSS()
       CASE VERT2=5
            byr()
       CASE VERT2=6
            Btlbyr()
       CASE VERT2=7
            STKAWAL()
        CASE VERT2=8
            HTAWAL()
        CASE VERT2=9
            PTAWAL()
    ENDCASE
    restscreen(0,0,24,79,cSave)
ENDDO
Return (nil)

Static Function Menu3
Static vert3:=1
While .t.
    SET COLOR TO GR+/B,W/R+
    set key 19 to tmlkr()
    set key 4 to tmlkn()
    // eval(bLogo)
     setcursor(0)
     SBOX(5,31,16,51,'n/w+,w+/r')
      PROMPT '  PEMBAYARAN       ' POSITION 3 HIGHLITE r/w+
      PROMPT '  HUTANG           ' POSITION 3 HIGHLITE r/w+
      PROMPT '  PEMBELIAN        ' POSITION 4 HIGHLITE r/w+
      PROMPT '  PENJUALAN        ' POSITION 5 HIGHLITE r/w+
      PROMPT '  PENYESUAIAN STOK ' POSITION 6 HIGHLITE r/w+
      PROMPT '  KARTU PIUTANG    ' POSITION 4 HIGHLITE r/w+
      PROMPT '  CTK NOTA JUAL    ' POSITION 12 HIGHLITE r/w+
      PROMPT '  ARUS  BARANG     ' POSITION 12 HIGHLITE r/w+
      PROMPT '  PEMASUKAN BARANG ' POSITION 12 HIGHLITE r/w+
      PROMPT '  PENGELUARAN KAS  ' POSITION 12 HIGHLITE r/w+
      Store Menu to aMenu4
      MenuRowCol(aMenu4,6,32)
      MenuPadr(aMenu4,19,'.')
   Menu to Vert3 with aMenu4 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                  tRow 1 tCol 70 tColor w/r
     save screen to smn3
     set key 19 to
     set key 4 to
     VERT11:=1
     IF VERT3 %11==0
        restscreen(0,0,24,79,cSave)
        EXIT
     ENDIF
     setcursor(1)
     Use no.dbf
     IF SANDI(12,Sandi2)
        use
        DO CASE
        CASE VERT3=1
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(8,50,11,73,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' HUTANG PERUSAHAAN    ' POSITION 2 HIGHLITE r/w+
          PROMPT ' PIUTANG LANGGANAN    ' POSITION 2 HIGHLITE r/w+
          Store Menu to aMenu42
           MenuRowCol(aMenu42,9,51)
           MenuPadr(aMenu42,21,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu42 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
           SET KEY 19 TO
           SET KEY 4 TO
          DO CASE
             CASE VERT11 %3=0
                  RESTSCREEN(0,0,24,79,cSave)
                  EXIT
             CASE VERT11=1
                  LBYRHT()
             CASE VERT11=2
                  LBYRPT()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT3=2
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(9,50,12,64,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' PERUSAHAAN    ' POSITION 2 HIGHLITE r/w+
          PROMPT ' LANGGANAN     ' POSITION 2 HIGHLITE r/w+
          Store Menu to aMenu43
           MenuRowCol(aMenu43,10,51)
           MenuPadr(aMenu43,13,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu43 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
           SET KEY 19 TO
           SET KEY 4 TO
          DO CASE
             CASE VERT11 %3=0
                  RESTSCREEN(0,0,24,79,cSave)
                  EXIT
             CASE VERT11=1
                  LHT()
             CASE VERT11=2
                  LPT()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT3=3
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(10,50,14,72,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' PPN PERUSAHAAN      ' POSITION 2 HIGHLITE r/w+
          PROMPT ' SELURUH PEMBELIAN   ' POSITION 2 HIGHLITE r/w+
          PROMPT ' TOTAL BRG MASUK     ' POSITION 2 HIGHLITE r/w+
          Store Menu to aMenu44
           MenuRowCol(aMenu44,11,51)
           MenuPadr(aMenu44,21,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu44 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
           SET KEY 19 TO
           SET KEY 4 TO
          DO CASE
            CASE VERT11 %4=0
                 RESTSCREEN(0,0,24,79,cSave)
                 EXIT
            CASE VERT11=1
                  LPPNHT()
            CASE VERT11=2
                 LIN()
            CASE VERT11=3
                 LTOTIN()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT3=4
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(11,50,16,72,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' SELURUH PENJUALAN   ' POSITION 2 HIGHLITE r/w+
          PROMPT ' Pajak Keluaran      ' POSITION 8 HIGHLITE r/w+
          PROMPT ' SELURUH BAN         ' POSITION 2 HIGHLITE r/w+
          PROMPT ' Pajak               ' POSITION 2 HIGHLITE r/w+
          Store Menu to aMenu45
           MenuRowCol(aMenu45,12,51)
           MenuPadr(aMenu45,21,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu45 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
          SET KEY 19 TO
          SET KEY 4 TO
          DO CASE
             CASE VERT11 %5=0
                  RESTSCREEN(0,0,24,79,cSave)
                  EXIT
             CASE VERT11=1
                  LOUT()
             CASE VERT11=2
                  LpjkOUT()
             CASE VERT11=3
                  Use no.dbf
                  IF SANDI(12,Sandi)
                     use
                     LBAN()
                  endif
             CASE VERT11=4
                  pajaks()
          ENDCASE
             RESTORE SCREEN FROM SMN3
          ENDDO
        CASE VERT3=5
             LSS()
        CASE VERT3=6
             KRTUT()
        CASE VERT3=7
             CTKFKT()
        CASE VERT3=8
             krtpsd()
        CASE VERT3=9
             LPOSTK()
        CASE VERT3=10
             LKAS()
        ENDCASE
     ELSE
        RESTORE SCREEN FROM SMN3
     ENDIF
     Use
     RESTSCREEN(0,0,24,79,cSave)
ENDDO
Return (nil)

Static Function Menu4
Static vert4:=1
While .t.
      SET COLOR TO GR+/B,W/R+
       set key 19 to tmlkr()
       set key 4 to tmlkn()
       // eval(bLogo)
      SBOX(5,43,12,63,'n/w+,w+/r')
      PROMPT ' Index        ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Backup       ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Restore      ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Stok         ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Hutang       ' POSITION 2 HIGHLITE r/w+
      PROMPT ' Piutang      ' POSITION 2 HIGHLITE r/w+
      Store Menu to aMenu5
      MenuRowCol(aMenu5,6,44)
      MenuPadr(aMenu5,19,'.')
   Menu to Vert4 with aMenu5 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                  tRow 1 tCol 70 tColor w/r
   set key 19 to
   set key 4 to
   setcursor(1)
   DO CASE
      CASE VERT4 %7=0
           RESTSCREEN(0,0,24,79,cSave)
           EXIT
      CASE VERT4=1
           Util1()
      CASE VERT4=2
           Menu43()
      CASE VERT4=3
           Menu44()
      CASE VERT4=4
           HitStk() //Menu45s()
      CASE VERT4=5
           Menu45h()
      CASE VERT4=6
           Menu45P()
   ENDCASE
   RESTSCREEN(0,0,24,79,cSave)
ENDDO
Return (nil)

Procedure Help()
Local cColor:=Setcolor()                                                   ,;
      mLyr:=Savescreen(0,50,21,79)                                         ,;
      cCursor:=Setcursor()
      Setcursor(1)
Setcolor('gr+/b')
@1,51 say ' Petunjuk Pemakaian Program '
Setcolor('gr/w')
@0,50 to 2,78 Double
sBox(2,50,20,78,'gr/w')
Setcolor("gr/n")
Memoedit(If(File('Help.Txt'),MemoRead('Help.txt'),;
                     'File "Help.Txt" harus ada '),3,51,19,77,.f.)
Restscreen(0,50,21,79,mLyr)
Setcolor(cColor)
Setcursor(cCursor)
Return

// SECURITY FOR MY DATABASE ----------------------------------
Static FUNCTION Kunci(NAMAFILE,tes)
Local HANDLE
HANDLE:=FOPEN(NAMAFILE,2)
 IF FERROR() # 0
    ? 'ERROR OPEN FILE '
    RETURN .F.
 ENDIF
BYTE_AWAL:=FREADSTR(HANDLE,1) // baca byte awal
FSEEK(HANDLE,0,0)
If Tes==0
   FWRITE(HANDLE,chr(254),1)
ElseIf Tes==1
   FWRITE(HANDLE,chr(245),1)
Endif

IF FERROR() # 0
   ? 'ERROR PENULISAN '
   RETURN .F.
ENDIF
FCLOSE(HANDLE)
IF FERROR() # 0
   ? 'ERROR PENULISAN '
   RETURN .F.
ENDIF
RETURN .T.