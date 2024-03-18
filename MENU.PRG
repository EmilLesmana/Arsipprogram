#include 'ptMenu.ch'
Memvar Getlist,Menulist
Static horiz
Static vert
Static aTime
Function Menu()
Menuinit()
aTime:={1,70,{||Time()}}
Horiz:=1
Vert:=1
While HORIZ<>0
      SET COLOR TO GR+/B,W/R+
      SET MESSAGE TO 23 CENTER
      SetKeytable(,,,.T.)
      @3,1 PROMPT ' 1.Arsip Data ' POSITION 2 HIGHLITE r/b
      @3,16 PROMPT ' 2.Transaksi   ' POSITION 2 HIGHLITE r/b
      @3,33 PROMPT ' 3.Laporan ' POSITION 2 HIGHLITE r/b
      @3,47 PROMPT ' 4.Koreksi ' POSITION 2 HIGHLITE r/b
      @3,61 PROMPT ' 5.Batal ' POSITION 2 HIGHLITE r/b
      Menumodal(Menulist,@horiz,aTime,'HORIZ');Menulist:={}
      SAVE SCREEN TO Menu
      DO CASE
         CASE HORIZ %6==0
              RETURN
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
      RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

Function Menu1
While .T.
      SetKeytable(19,{||TMLKR()})
      SetKeytable(4,{||TMLKN()})
      set cursor off
      SBOX(5,1,9,21,'n/w+,w+/r')
      PROMPT ' BARANG BARU       ' POSITION 2 HIGHLITE r/w+
      PROMPT ' PEMASOK           ' POSITION 2 HIGHLITE r/w+
      PROMPT ' LANGGANAN         ' POSITION 2 HIGHLITE r/w+
      MenuRowCol(Menulist,6,2)
      MenuPadc(Menulist,19,'.')
      Menumodal(Menulist,@vert,aTime,'vert');Menulist:={}
      SET CURSOR ON
      SetKeytable(,,,.T.)
      DO CASE
         CASE VERT %4=0
              RESTORE SCREEN FROM Menu
              EXIT
         CASE VERT=1
              INBRG()
        CASE VERT=2
              INPMSK()
        CASE VERT=3
              INLGN()
     ENDCASE
     RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

Function Menu2
While .T.
         SetKeytable(19,{||TMLKR()})
         SetKeytable(4,{||TMLKN()})
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
         MenuRowCol(Menulist,6,17)
         MenuPadr(Menulist,21,'.')
         Menumodal(Menulist,@vert,aTime,'vert');Menulist:={}
         SetKeytable(,,,.T.)
         setcursor(1)
         DO CASE
            CASE VERT %9=0
                 RESTORE SCREEN FROM Menu
                 EXIT
            CASE VERT=1
                 IN()
            CASE VERT=2
                 BYR()
            CASE VERT=3
                 OUT()
            CASE VERT=4
                 INVLK()
            CASE VERT=5
                 INVLKR()
            CASE VERT=6
                 LHVLKPRS()
            CASE VERT=7
                 INSS()
            CASE VERT=8
                 POSTK()
         ENDCASE
         RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

Function Menu3
While .T.
     SetKeytable(19,{||TMLKR()})
     SetKeytable(4,{||TMLKN()})
     setcursor(0)
     SBOX(5,31,17,51,'n/w+,w+/r')
     @6,32 PROMPT '  VULKANISIR       ' POSITION 3 HIGHLITE r/w+
     @7,32 PROMPT '  PEMBAYARAN       ' POSITION 3 HIGHLITE r/w+
     @8,32 PROMPT '  HUTANG           ' POSITION 3 HIGHLITE r/w+
     @9,32 PROMPT '  PEMBELIAN        ' POSITION 4 HIGHLITE r/w+
     @10,32 PROMPT '  PENJUALAN        ' POSITION 5 HIGHLITE r/w+
     @11,32 PROMPT '  CTK FAKTUR JUAL  ' POSITION 7 HIGHLITE r/w+
     @12,32 PROMPT '  CTK NOTA VULK    ' POSITION 7 HIGHLITE r/w+
     @13,32 PROMPT '  PENYESUAIAN STOK ' POSITION 6 HIGHLITE r/w+
     @14,32 PROMPT '  KARTU BARANG     ' POSITION 3 HIGHLITE r/w+
     @15,32 PROMPT '  KARTU PIUTANG    ' POSITION 4 HIGHLITE r/w+
     @16,32 PROMPT '  MASUK BARANG     ' POSITION 14 HIGHLITE r/w+
     Menumodal(Menulist,@vert,aTime,'vert');Menulist:={}
     SetKeytable(,,,.T.)
     SETCURSOR(1)
     SAVE SCREEN TO SMN3

     VERT1:=1
     IF VERT %12==0
        RESTORE SCREEN FROM Menu
        EXIT
     ENDIF
     setcursor(1)
     IF SANDI(12,chr(56)+chr(48)+chr(54))
        DO CASE
         CASE VERT=1
           RESTORE SCREEN FROM SMN3
           While .T.
           setcursor(0)
           SBOX(7,50,10,78,'n/w+,w+/r')
           @8,51 PROMPT ' DATA BRG VULKANISIR       ' POSITION 2 HIGHLITE r/w+
           @9,51 PROMPT ' TOTAL BARANG VULKANISIR   ' POSITION 2 HIGHLITE r/w+
           Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
           SETCURSOR(1)
           DO CASE
                  CASE VERT1 %3=0
                       RESTORE SCREEN FROM Menu
                       EXIT
                  CASE VERT1=1
                     LVLKABL()
                  CASE VERT1=2
                     LTOTPRS()
           ENDCASE
           RESTORE SCREEN FROM SMN3
           ENDDO

        CASE VERT=2
          RESTORE SCREEN FROM SMN3
          While .T.
          setcursor(0)
          SBOX(8,50,12,73,'n/w+,w+/r')
          @9,51 PROMPT ' P P N PERUSAHAAN    ' POSITION 2 HIGHLITE r/w+
          @10,51 PROMPT ' HUTANG PERUSAHAAN    ' POSITION 2 HIGHLITE r/w+
          @11,51 PROMPT ' PIUTANG LANGGANAN    ' POSITION 2 HIGHLITE r/w+
          Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
          SETCURSOR(1)
          DO CASE
             CASE VERT1 %4=0
                  RESTORE SCREEN FROM Menu
                  EXIT
             CASE VERT1=1
                  LPPNHT()
             CASE VERT1=2
                  LBYRHT()
             CASE VERT1=3
                  LBYRPT()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT=3
          RESTORE SCREEN FROM SMN3
          While .T.
          setcursor(0)
          SBOX(9,50,12,66,'n/w+,w+/r')
          @10,51 PROMPT ' PERUSAHAAN    ' POSITION 2 HIGHLITE r/w+
          @11,51 PROMPT ' LANGGANAN     ' POSITION 2 HIGHLITE r/w+
          Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
          setcursor(1)
          DO CASE
             CASE VERT1 %3=0
                  RESTORE SCREEN FROM Menu
                  EXIT
             CASE VERT1=1
                  LHT()
             CASE VERT1=2
                  LPT()
          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT=4
          RESTORE SCREEN FROM SMN3
          While .T.
          setcursor(0)
          SBOX(10,50,14,72,'n/w+,w+/r')
          @11,51 PROMPT ' SELURUH PEMBELIAN   ' POSITION 2 HIGHLITE r/w+
          @12,51 PROMPT ' URUT NO PEMBELIAN   ' POSITION 2 HIGHLITE r/w+
          @13,51 PROMPT ' TOTAL BRG MASUK     ' POSITION 2 HIGHLITE r/w+
          Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
          setcursor(1)
          DO CASE
            CASE VERT1 %4=0
              RESTORE SCREEN FROM Menu
              EXIT
            CASE VERT1=1
              LIN()
            CASE VERT1=2
              LNOBPB()
            CASE VERT1=3
              LTOTIN()

          ENDCASE
          RESTORE SCREEN FROM SMN3
          ENDDO

        CASE VERT=5
          RESTORE SCREEN FROM SMN3
          While .T.
          SBOX(11,50,16,72,'n/w+,w+/r')
          setcursor(0)
          @12,51 PROMPT ' SELURUH PENJUALAN   ' POSITION 2 HIGHLITE r/w+
          @13,51 PROMPT ' URUT NO FAKTUR      ' POSITION 2 HIGHLITE r/w+
          @14,51 PROMPT ' SELURUH BAN         ' POSITION 2 HIGHLITE r/w+
          @15,51 PROMPT ' PAJAK               ' POSITION 2 HIGHLITE r/w+
          Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
          setcursor(1)
          DO CASE
            CASE VERT1 %5=0
              RESTORE SCREEN FROM Menu
              EXIT
            CASE VERT1=1
                 LOUT()
            CASE VERT1=2
                 LNOUT()
            CASE VERT1=3
                 LBAN()
            CASE VERT1=4
                 PAJAKS()
          ENDCASE
             RESTORE SCREEN FROM SMN3
          ENDDO
        CASE VERT=6
             CTKFKT()
        CASE VERT=7
             CTKNT()
        CASE VERT=8
             LSS()
        CASE VERT=9
             KRTPSD()
        CASE VERT=10
             KRTUT()
        CASE VERT==11
          RESTORE SCREEN FROM SMN3
          While .T.
            setcursor(0)
            SBOX(17,50,21,72,'n/w+,w+/r')
            @18,51 PROMPT ' SELURUH PEMASUKAN   ' POSITION 2 HIGHLITE r/w+
            @19,51 PROMPT ' URUT NO PEMASUKAN   ' POSITION 2 HIGHLITE r/w+
            @20,51 PROMPT ' LIHAT TOTAL MASUK   ' POSITION 2 HIGHLITE r/w+
            Menumodal(Menulist,@vert1,aTime,'vert1');Menulist:={}
            setcursor(1)
            DO CASE
               CASE VERT1 %4=0
                    RESTORE SCREEN FROM Menu
                    EXIT
               CASE VERT1=1
                    LPOSTK()
               CASE VERT1=2
                    LNOpostk()
               CASE VERT1=3
                    LTOTPO()
            ENDCASE
            RESTORE SCREEN FROM SMN3
          ENDDO
        ENDCASE
     ELSE
        RESTORE SCREEN FROM SMN3
     ENDIF
  RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

Function Menu4
While .T.
   SetKeytable(19,{||TMLKR()})
   SetKeytable(4,{||TMLKN()})
   setcursor(0)
   SBOX(5,43,12,63,'n/w+,w+/r')
   @6,44 PROMPT ' PEMBELIAN         ' POSITION 2 HIGHLITE r/w+
   @7,44 PROMPT ' PEMBAYARAN        ' POSITION 5 HIGHLITE r/w+
   @8,44 PROMPT ' PENJUALAN         ' POSITION 5 HIGHLITE r/w+
   @9,44 PROMPT ' VULKANISIR        ' POSITION 2 HIGHLITE r/w+
   @10,44 PROMPT ' PENYESUAIAN STOK  ' POSITION 3 HIGHLITE r/w+
   @11,44 PROMPT ' MASUK BARANG      ' POSITION 2 HIGHLITE r/w+
   Menumodal(Menulist,@vert,aTime,'vert');Menulist:={}
   SetKeytable(,,,.T.)
   set cursor on
   DO CASE
      CASE VERT %7=0
           RESTORE SCREEN FROM Menu
           EXIT
      CASE VERT=1
           EDITIN()
      CASE VERT=2
           EDITBYR()
      CASE VERT=3
           EDITOUT()
      CASE VERT=4
           EVLK()
      CASE VERT=5
           EDITSS()
      CASE VERT=6
           EPOSTK()
   ENDCASE
   RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

Function Menu5
While .T.
   SetKeytable(19,{||TMLKR()})
   SetKeytable(4,{||TMLKN()})
   set cursor off
   SBOX(5,57,12,77,'n/w+,w+/r')
   @6,58 PROMPT ' PEMBELIAN         ' POSITION 2 HIGHLITE r/w+
   @7,58 PROMPT ' PEMBAYARAN        ' POSITION 5 HIGHLITE r/w+
   @8,58 PROMPT ' PENJUALAN         ' POSITION 5 HIGHLITE r/w+
   @9,58 PROMPT ' VULKANISIR        ' POSITION 2 HIGHLITE r/w+
   @10,58 PROMPT ' PENYESUAIAN STOK  ' POSITION 3 HIGHLITE r/w+
   @11,58 PROMPT ' MASUK BARANG      ' POSITION 2 HIGHLITE r/w+
   Menumodal(Menulist,@vert,aTime,'vert');Menulist:={}
   SetKeytable(,,,.T.)
   SET CURSOR ON
   DO CASE
      CASE VERT %7=0
           RESTORE SCREEN FROM Menu
           EXIT
      CASE VERT=1
           BTLIN()
      CASE VERT=2
           BTLBYR()
      CASE VERT=3
           BTLOUT()
      CASE VERT=4
           BTLVLK()
      CASE VERT=5
           BTLSS()
      CASE VERT=6
           BPOSTK()
    ENDCASE
    RESTORE SCREEN FROM Menu
ENDDO
Return (nil)

FUNCTION TMLKR
 KEYBOARD CHR(27)+CHR(5)+CHR(13)
RETURN NIL

FUNCTION TMLKN
  KEYBOARD CHR(27)+CHR(24)+CHR(13)
RETURN NIL

FUNC FUNGSI
DO CASE
  CASE LASTKEY()=27
    CLOSE ALL
    RETURN 0
  OTHERWISE
    RETURN 1
  ENDCASE
  RETURN 1
