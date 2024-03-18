* ------------------------------------- *
* Nama Program : Demo.PRG               *
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

Function Wijaya()
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
Set Key 9 to Help()
ErrorBlock({|e|Mydeferror(e,Deferr)})
Menulist:={}
 aLogo:=;
        {'     Û   Û  Û     Û  ÜßßÜ  ÛÜÜÛ  ÜßßÜ        Copy Right '       ,;
         '     ÛÜßÜÛ  Û  ÛÜÜÛ  ÛßßÛ  ÜÜÜÛ  ÛßßÛ                   '       ,;
         '                                               1 9 9 5  '       ,;
         '       Û  Û  ßßÛßß  ÜßßÜ  ÛßÜßÛ  ÜßßÜ                   '       ,;
         '       ßÜÜß    Û    ÛßßÛ  Û   Û  ÛßßÛ     by Ir. Emil L '}


bLogo:={||setcolor('r/bg'),devpos(19,11),devout(aLogo[1]),;
          devpos(20,11),devout(aLogo[2]),;
          devpos(21,11),devout(aLogo[3]),;
          devpos(22,11),devout(aLogo[4]),;
          devpos(23,11),devout(aLogo[5])}

geser(1)
IF !SANDI(15,chr(49)+chr(50))
   SET CURSOR ON
   SET COLOR TO
   CLOSE ALL
   CLEAR
   Return (nil)
ENDIF
cTanya:=.n.
if !file('stk.dbf')
   setcolor('')
   cls
   Berita(2,39,' Pembacaan Drive --> '+curdir()+' Gagal ......... ','w+/r')
   setcolor('gr+/b,w/r')
   @5,2 say ' Apakah akan dibuatkan "Data Kosong"  [Y/N] ' get cTanya pict 'Y'
   read
   if !cTanya
      Return nil
   endif
endif

BARU()
setcolor("")

IF !FILE('C:\DOS\TMP.EXE')
   CLOSE ALL
   SETCURSOR(1)
   SET COLOR TO
   CLEAR
   QUIT
ENDIF
      @0,0,24,79 box repli(chr(178),9)
      @1,1,1,78 box repli(chr(255),9)
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
      @3,47 PROMPT ' 4.Koreksi ' POSITION 2 HIGHLITE r/b
      @3,61 PROMPT ' 5.Batal ' POSITION 2 HIGHLITE r/b
      Store Menu to aMenu1
      eval(bLogo)
      setcolor("gr+/b")
      @24,0 say Padl(' "ESC ==> Keluar"        '+;
                     '                                      "TAB ==> Help" ',80)
While .t.
      SET COLOR TO GR+/B,W/R+
      Menu to horiz with aMenu1 Row 1 Col 30 Display " Wijaya - Utama " ;
                        Color w/r
      cSave:=savescreen(0,0,24,79)
      set key 19 to
      set key 4 to
      DO CASE
         CASE HORIZ %6==0
              geser(2)
              exit
         CASE HORIZ=1
              Menu1()
         CASE HORIZ=2
              Menu2()
         CASE HORIZ=3
              Menu3()
         CASE HORIZ=4
              Menu4()
         CASE HORIZ=5
              Menu5()
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
      SBOX(5,1,9,21,'n/w+,w+/r')
      PROMPT ' BARANG        ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMASOK           ' POSITION 2 HIGHLITE r/w+
      PROMPT ' LANGGANAN         ' POSITION 2 HIGHLITE r/w+
      Store Menu to aMenu2
      MenuRowCol(aMenu2,6,2)
      MenuPadr(aMenu2,19,'.')
      Menu to Vert with aMenu2 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                     tRow 1 tCol 70 tColor w/r
      set key 19 to
      set key 4 to
      DO CASE
         CASE VERT %4=0
              restscreen(0,0,24,79,cSave)
              EXIT
         CASE VERT=1
              INBRG()
        CASE VERT=2
              INPMSK()
        CASE VERT=3
              INLGN()
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
      SBOX(5,16,14,38,'n/w+,w+/r')
      PROMPT ' PEMBELIAN           ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMBAYARAN          ' POSITION 5 HIGHLITE r/w+
      PROMPT ' PENJUALAN           ' POSITION 5 HIGHLITE r/w+
      PROMPT ' MASUK KANISIR       ' POSITION 2 HIGHLITE r/w+
      PROMPT ' AMBIL DARI PABRIK   ' POSITION 2 HIGHLITE r/w+
      PROMPT ' DATA VULKANISIR     ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PENYESUAIAN STOK    ' POSITION 14 HIGHLITE r/w+
      PROMPT ' MASUK BARANG        ' POSITION 4 HIGHLITE r/w+
      Store Menu to aMenu3
      MenuRowCol(aMenu3,6,17)
      MenuPadr(aMenu3,21,'.')
    Menu to Vert2 with aMenu3 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                   tRow 1 tCol 70 tColor w/r
    set key 19 to
    set key 4 to
    setcursor(1)
    DO CASE
       CASE VERT2 %9=0
            restscreen(0,0,24,79,cSave)
            EXIT
       CASE VERT2=1
            IN()
       CASE VERT2=2
            BYR()
       CASE VERT2=3
            OUT()
       CASE VERT2=4
            INVLK()
       CASE VERT2=5
            INVLKR()
       CASE VERT2=6
            LHVLKPRS()
       CASE VERT2=7
            INSS()
       CASE VERT2=8
            POSTK()
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
     SBOX(5,31,17,51,'n/w+,w+/r')
      PROMPT '  VULKANISIR       ' POSITION 3 HIGHLITE r/w+
      PROMPT '  PEMBAYARAN       ' POSITION 3 HIGHLITE r/w+
      PROMPT '  HUTANG           ' POSITION 3 HIGHLITE r/w+
      PROMPT '  PEMBELIAN        ' POSITION 4 HIGHLITE r/w+
      PROMPT '  PENJUALAN        ' POSITION 5 HIGHLITE r/w+
      PROMPT '  CTK FAKTUR JUAL  ' POSITION 7 HIGHLITE r/w+
      PROMPT '  CTK NOTA VULK    ' POSITION 7 HIGHLITE r/w+
      PROMPT '  PENYESUAIAN STOK ' POSITION 6 HIGHLITE r/w+
      PROMPT '  KARTU BARANG     ' POSITION 3 HIGHLITE r/w+
      PROMPT '  KARTU PIUTANG    ' POSITION 4 HIGHLITE r/w+
      PROMPT '  MASUK BARANG     ' POSITION 14 HIGHLITE r/w+
      Store Menu to aMenu4
      MenuRowCol(aMenu4,6,32)
      MenuPadr(aMenu4,19,'.')
   Menu to Vert3 with aMenu4 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                  tRow 1 tCol 70 tColor w/r
     save screen to smn3
     set key 19 to
     set key 4 to
     VERT11:=1
     IF VERT3 %12==0
        restscreen(0,0,24,79,cSave)
        EXIT
     ENDIF
     setcursor(1)
     IF SANDI(12,chr(50)+chr(49))
        DO CASE
         CASE VERT3=1
         RESTORE SCREEN FROM SMN3
           While .T.
           // eval(bLogo)
           SBOX(7,50,10,78,'n/w+,w+/r')
           PROMPT ' DATA BRG VULKANISIR       ' POSITION 2 HIGHLITE r/w+
           PROMPT ' TOTAL BARANG VULKANISIR   ' POSITION 2 HIGHLITE r/w+
           Store Menu to aMenu41
           MenuRowCol(aMenu41,8,51)
           MenuPadr(aMenu41,25,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu41 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
           SET KEY 19 TO
           SET KEY 4 TO
           DO CASE
                  CASE VERT11 %3=0
                       RESTSCREEN(0,0,24,79,cSave)
                       EXIT
                  CASE VERT11=1
                     LVLKABL()
                  CASE VERT11=2
                     LTOTPRS()
           ENDCASE
           RESTORE SCREEN FROM SMN3
           ENDDO

        CASE VERT3=2
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

        CASE VERT3=3
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

        CASE VERT3=4
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(10,50,14,72,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' SELURUH PEMBELIAN   ' POSITION 2 HIGHLITE r/w+
          PROMPT ' URUT NO PEMBELIAN   ' POSITION 2 HIGHLITE r/w+
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
                 LIN()
            CASE VERT11=2
                 LNOBPB()
            CASE VERT11=3
                 LTOTIN()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT3=5
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(11,50,15,72,'n/w+,w+/r')
          // eval(bLogo)
          PROMPT ' SELURUH PENJUALAN   ' POSITION 2 HIGHLITE r/w+
          PROMPT ' URUT NO FAKTUR      ' POSITION 2 HIGHLITE r/w+
          PROMPT ' SELURUH BAN         ' POSITION 2 HIGHLITE r/w+
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
             CASE VERT11 %4=0
                  RESTSCREEN(0,0,24,79,cSave)
                  EXIT
             CASE VERT11=1
                  LOUT()
             CASE VERT11=2
                  LNOUT()
             CASE VERT11=3
                  LBAN()
          ENDCASE
             RESTORE SCREEN FROM SMN3
          ENDDO
        CASE VERT3=6
             CTKFKT()
        CASE VERT3=7
             CTKNT()
        CASE VERT3=8
             LSS()
        CASE VERT3=9
             KRTPSD()
        CASE VERT3=10
             KRTUT()
        CASE VERT3==11
          RESTORE SCREEN FROM SMN3
          While .T.
            SBOX(11,40,15,62,'n/w+,w+/r')
            // eval(bLogo)
            PROMPT ' SELURUH PEMASUKAN   ' POSITION 2 HIGHLITE r/w+
            PROMPT ' URUT NO PEMASUKAN   ' POSITION 2 HIGHLITE r/w+
            PROMPT ' LIHAT TOTAL MASUK   ' POSITION 2 HIGHLITE r/w+
            Store Menu to aMenu46
           MenuRowCol(aMenu46,12,41)
           MenuPadr(aMenu46,21,'.')
           SET KEY 19 TO STMLKR()
           SET KEY 4 TO STMLKN()
           Menu to Vert11 with aMenu46 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                           tRow 1 tCol 70 tColor w/r
           SET KEY 19 TO
           SET KEY 4 TO
            DO CASE
               CASE VERT11 %4=0
                    RESTSCREEN(0,0,24,79,cSave)
                    EXIT
               CASE VERT11=1
                    LPOSTK()
               CASE VERT11=2
                    LNOpostk()
               CASE VERT11=3
                    LTOTPO()
            ENDCASE
            RESTORE SCREEN FROM SMN3
          ENDDO
        ENDCASE
     ELSE
        RESTORE SCREEN FROM SMN3
     ENDIF
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
      PROMPT ' PEMBELIAN         ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMBAYARAN        ' POSITION 5 HIGHLITE r/w+
      PROMPT ' PENJUALAN         ' POSITION 5 HIGHLITE r/w+
      PROMPT ' VULKANISIR        ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PENYESUAIAN STOK  ' POSITION 3 HIGHLITE r/w+
      PROMPT ' MASUK BARANG      ' POSITION 2 HIGHLITE r/w+
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
           EDITIN()
      CASE VERT4=2
           EDITBYR()
      CASE VERT4=3
           EDITOUT()
      CASE VERT4=4
           EVLK()
      CASE VERT4=5
           EDITSS()
      CASE VERT4=6
           EPOSTK()
   ENDCASE
   RESTSCREEN(0,0,24,79,cSave)
ENDDO
Return (nil)

Static Function Menu5
Static vert5:=1
While .t.
      SET COLOR TO GR+/B,W/R+
       set key 19 to tmlkr()
       set key 4 to tmlkn()
       // eval(bLogo)
      SBOX(5,57,12,77,'n/w+,w+/r')
      PROMPT ' PEMBELIAN         ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMBAYARAN        ' POSITION 5 HIGHLITE r/w+
      PROMPT ' PENJUALAN         ' POSITION 5 HIGHLITE r/w+
      PROMPT ' VULKANISIR        ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PENYESUAIAN STOK  ' POSITION 3 HIGHLITE r/w+
      PROMPT ' MASUK BARANG      ' POSITION 2 HIGHLITE r/w+
      Store Menu to aMenu6
      MenuRowCol(aMenu6,6,58)
      MenuPadr(aMenu6,19,'.')
   Menu to Vert5 with aMenu6 Row 19 Col 10 Display aLogo Color 'gr+/bg,r/bg' ;
                  tRow 1 tCol 70 tColor w/r
   set key 19 to
   set key 4 to
   setcursor(1)
   DO CASE
      CASE VERT5 %7=0
           RESTSCREEN(0,0,24,79,cSave)
           EXIT
      CASE VERT5=1
           BTLIN()
      CASE VERT5=2
           BTLBYR()
      CASE VERT5=3
           BTLOUT()
      CASE VERT5=4
           BTLVLK()
      CASE VERT5=5
           BTLSS()
      CASE VERT5=6
           BPOSTK()
    ENDCASE
    restscreen(0,0,24,79,cSave)
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
Return