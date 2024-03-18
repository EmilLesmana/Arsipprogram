Function Inbrg()
* program pemasukan data BARANG
LOCAL MNAMA,MHRG,MGRP,MMIN,I,KOL:={},APICT:={},mbrs,mcol,CCHAR:=''
SET COLOR TO
FOR I:=1 TO 80
    SCROLL(,,,,,1)
NEXT
#INCLUDE 'INKEY.CH'
dbcloseall()
USE STK.DMT INDEX STKX.MLX,NAMABRG.MLX,GRPX.MLX NEW
set delete off
sele stk

  AADD(APICT,{'@!','@!','@e 999,999','@e 99,999,999','@e 9,999','@!'})
  AADD(KOL,{'KODBRG','NAMA','QTT','HaRGa','MIN','GRP'})
  TABEL:=TBROWSEDB(4,2,17,75)
  DISPBEGIN()
  SET COLOR TO W/N
  @0,0,24,79 BOX REPLI(CHR(178),79)
  SET COLOR TO W/R
  sbox(19,1,23,78,'n+/w')
  @20,2 say '0-9,A-Z->Cari'+chr(179)+'Enter->Edit'
  @20,COL() SAY chr(179)+'Esc->Keluar'+chr(179)
  @21,2 say 'F7->Delete'+chr(179)+'F8->Undelete'+chr(179)
  @21,COL() SAY 'F9->Packing'+chr(179)
  @21,COL()  SAY 'F3->Tambah Data'+chr(179)
  @22,2 say 'F2->Cetak Seluruh Data'+'Ё'+'F5->Cetak Barang > 0'+;
            'Ё'+'F6->Cetak Yang Perlu Dipesan'+'Ё'
  setcolor("gr+/n")
  @ 1,2 SAY 'щдддддд DAFTAR DATA BARANGддддддддддддддддддддддддддддддддщ '
  SBOX(3,1,18,76,'GR+/B,W/R')
  DISPEND()
  SAVE SCREEN TO KL
  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  C:=tbcolumnnew('KOD BRG',{||KODBRG})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('NAMA BARANG',{||NAMA})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('QTT',{||TRAN(QTT,'@E 999,999')})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('HaRGa',{||TRAN(HaRGa,'@E 99,999,999')})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('MIN',{||TRAN(MIN,'@E 9,999')})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('GRP',{||GRP})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(QTT<MIN,{3,4},{1,4}))}
  tabel:addcolumn(C)
  SETCURSOR(0)
  TABEL:HEADSEP:='мям'
  TABEL:COLSEP:= ' Ё '
  tabel:footsep:='мом'
  //tabel:freeze:=1
  //tabel:colpos:=2
While .t.
    /* if tabel:colpos>tabel:colcount
        tone(200,1)
        tone(400,1)
     elseif tabel:colpos<=tabel:freeze
        tone(200,1)
        tone(400,1)
        tabel:colpos:=2
     endif
      */
     do while !tabel:stabilize()
     enddo
     IF TABEL:HITTOP .OR. TABEL:HITBOTTOM
        tone(200,1)
        tone(400,1)
     ENDIF
      mbrs:=row();mcol:=col()
      x:={||waktu()};x:=eval(x)
      @mbrs,mcol say ''
     if x==27
        SET CURSOR ON
        CLOSE ALL
        exit
     endif
     IF X==13
        IF TABEL:COLPOS==3 .or. tabel:colpos==1
           tabel:right()
           LOOP
        ENDIF
        Sele Stk
        SETCURSOR(1)
        MEDIT:=KOL[1][TABEL:COLPOS]
        If Reclock()
           @ROW(),COL() GET &MEDIT pict APICT[1][TABEL:COLPOS]
           READ
           dbcommit()
           unlock
        endif
        TABEL:RIGHT()
        SETCURSOR(0)
        TABEL:REFREShCURRENT()
     ENDIF

     if x== -4
       set order to 1
       set filter to
       dbgotop()
       Set Filter to Qtt#0
       do while !tabel:stabilize()
       enddo
       TABEL:GOTOP()
       TABEL:REFRESHALL()
         IF !CEKPRINT()
            RESTORE SCREEN FROM KL
            loop
         ENDIF
        CTK1(x)
        EXIT
     ENDIF

     if x== -5
       set filter to
       set order to 1
       set filter to qtt<min

       do while !tabel:stabilize()
       enddo
       TABEL:GOTOP()
       TABEL:REFRESHALL()
         IF !CEKPRINT()
            RESTORE SCREEN FROM KL
            LOOP
         ENDIF
        CTK1(x)
        EXIT
     ENDIF

     if x==-6
        If Reclock()
           delete
           dbcommit()
           unlock
        endif
        tabel:Refreshall()
     endif

     if x==-7
        If Reclock()
           recall
           dbcommit()
           unlock
        endif
        tabel:Refreshall()
     endif

     if x==-8
        If Reclock()
            pack
            dbcommitall()
        endif
        tabel:Refreshall()
     endif

     if x== -1
       cgrp:='  '
       @2,1 say ' Group : ' get cgrp pict '@!'
       read
       set order to 3
       set filter to cgrp==substr(grp,1,2)
       TABEL:GOTOP()
       TABEL:REFRESHALL()
       do while !tabel:stabilize()
       enddo
         IF !CEKPRINT()
            EXIT
         ENDIF
        CTK1(x)
        EXIT
     ENDIF

     IF X==-2
        SET ORDER TO 1
        SET FILTER TO
        TBDTBRG()
        RESTORE SCREEN FROM KL
        tabel:colpos:=2
        TABEL:REFRESHALL()
     ENDIF

     If UPPER(chr(X)) $ ".,1234567890QWERTYUIOPASDFGHJKLZXCVBNM-*/+' "
        Do case
           case tabel:colpos==1
                set order to 1
           case tabel:colpos==2
                set order to 2
           case tabel:colpos==6
                set order to 3
           otherwise
           tone(1000,2)
           loop
        endcase
        tabel:gotop()
        tabel:refreshall()
        B:=1
        cChar:=cChar+UPPER(CHR(X))
        @7,19 SAY cChar
        dbseek(UPPER(cChar))
        do while .not. found() .and. B<=len(cChar)
           dbseek(left(cChar,len(cChar)-B))
           B++
        enddo
        Tabel:refreshAll()
      Endif

     If x==K_UP
        cChar:=''
        tabel:UP()
     elseif x==K_DOWN
        cChar:=''
        tabel:DOWN()
     elseif x==K_LEFT
        cChar:=''
        tabel:LEFT()
     elseif x==K_RIGHT
        cChar:=''
        tabel:RIGHT()
     elseif x==K_PGUP
        cChar:=''
        tabel:PAGEUP()
     elseif x==K_PGDN
        cChar:=''
        tabel:PAGEDOWN()
     elseif x==K_HOME
        cChar:=''
        tabel:HOME()
     elseif x==K_END
        cChar:=''
        tabel:END()
     elseif x==K_CTRL_HOME
        cChar:=''
        tabel:PANHOME()
     elseif x==K_CTRL_END
        cChar:=''
      tabel:PANEND()
     elseif x==K_TAB
        cChar:=''
      tabel:PANRIGHT()
     elseif x==K_SH_TAB
         cChar:=''
      tabel:PANLEFT()
     elseif x==K_CTRL_PGUP
        cChar:=''
      tabel:GOTOP()
     elseif x==K_CTRL_PGDN
        cChar:=''
      tabel:GOBOTTOM()
     endif
  enddo
  set delete on
  CLOSE ALL
Return (nil)

FUNCTION TBDTBRG()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MKODE:=SPACE(10)
SAVE SCREEN TO MSCREEN
DO WHILE .T.
MKODE:=SPACE(10)
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Kode Brg : ' GET MKODE PICT '@!'
READ
IF MKODE==SPACE(10)
    SETCURSOR(0)
    REST SCREEN FROM MSCREEN
    SETCOLOR(MCOLOR)
   RETURN NIL
ENDIF
SETCURSOR(0)
DBSEEK(MKODE)
IF FOUND()
  @11,21 SAY 'KODE SUDAH TERPAKAI .........'
  INKEY(0)
  LOOP
ELSE
  DBAPPEND()
  If Reclock()
     REPLACE KODbrg WITH MKODE
     dbcommit()
     unlock
  endif
  EXIT
ENDIF
ENDDO
SETCURSOR(0)
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MKODE

FUNCTION CRGRP()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MNAMA:=SPACE(6)
SAVE SCREEN TO MSCREEN
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Group : ' GET MNAMA PICT '@!'
READ
SETCURSOR(0)
IF MNAMA==''
   SET ORDER TO 1
   REST SCREEN FROM MSCREEN
   SETCOLOR(MCOLOR)
   RETURN NIL
ENDIF
DBSEEK(MNAMA)
DO WHILE !FOUND() .AND. X<=LEN(MNAMA)
   DBSEEK(LEFT(MNAMA,LEN(MNAMA)-X))
   X++
ENDDO
SET FILTER TO GRP=MNAMA
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MNAMA

FUNCT CTK1()
LOCAL HAL:=1,BR,NO,MJUM:=MJUM1:=0
IF !CEKPRINT()
   dbcloseALL()
   RETURN nil
ENDIF
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@3,1 SAY DATE()
@ 3,15 SAY '   DAFTAR DATA BARANG   '
@4,0 SAY '------------------------------------------------------------------------------'
@5,0 SAY '| NO  | KODE BARANG |    NAMA BARANG      |  QTT  |  HARGA   | MIN |  GRUP   |'
@6,0 SAY '------------------------------------------------------------------------------'
BR := 7
NO := 1
DO WHILE .NOT. EOF()
 IF X==-4
  IF QTT>0
   @ BR,0 SAY '|'+TRAN(NO,'9,999')+'|'+PADR(KODBRG,13)+'|'+PADR(NAMA,21)+'|'
   @ BR,PCOL() SAY TRAN(QTT,'999,999')+'|'+TRAN(HARGA,'99,999,999')+'|'
   @ BR,PCOL() SAY TRAN(MIN,'9,999')+'|'+PADC(GRP,9)+'|'
   MJUM+=QTT*HARGA
   BR++;NO++
  ENDIF
 ELSEIF X==-5
  IF QTT<MIN
   @ BR,0 SAY '|'+TRAN(NO,'9,999')+'|'+PADR(KODBRG,13)+'|'+PADR(NAMA,21)+'|'
   @ BR,PCOL() SAY TRAN(QTT,'999,999')+'|'+TRAN(HARGA,'99,999,999')+'|'
   @ BR,PCOL() SAY TRAN(MIN,'9,999')+'|'+PADC(GRP,9)+'|'
   MJUM+=QTT*HARGA
   BR++;NO++
  ENDIF
 ELSE
   @ BR,0 SAY '|'+TRAN(NO,'9,999')+'|'+PADR(KODBRG,13)+'|'+PADR(NAMA,21)+'|'
   @ BR,PCOL() SAY TRAN(QTT,'999,999')+'|'+TRAN(HARGA,'99,999,999')+'|'
   @ BR,PCOL() SAY TRAN(MIN,'9,999')+'|'+PADC(GRP,9)+'|'
   MJUM+=QTT*HARGA
   BR++;NO++
 ENDIF
IF BR==61
@bR,0 SAY '------------------------------------------------------------------------------'
@BR+1,10 SAY 'Jumlah Uang Rp.'+tran(mjum,'@e 999,999,999,999')
    @br+3,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
       CLOSE ALL
       RETURN nil
    ENDIF
    HAL++
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,15 SAY '   DAFTAR DATA BARANG   '
@4,0 SAY '------------------------------------------------------------------------------'
@5,0 SAY '| NO  | KODE BARANG |    NAMA BARANG      |  QTT  |  HARGA   | MIN |  GRUP   |'
@6,0 SAY '------------------------------------------------------------------------------'
    BR:=7
ENDIF

SKIP
ENDD
SET COLOR TO GR
@bR,0 SAY '------------------------------------------------------------------------------'
@BR+1,10 SAY 'Jumlah Uang Rp.'+tran(mjum,'@e 999,999,999,999')
    @br+3,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
 KOMENTAR(3,'  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!')
    CLOSE ALL
RETURN NIL

FUNCTION CRJNS()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MNAMA:=SPACE(10)
SAVE SCREEN TO MSCREEN
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Cari Jenis Brg : ' GET MNAMA PICT '@!'
READ
SETCURSOR(0)
IF MNAMA==''
   REST SCREEN FROM MSCREEN
   SETCOLOR(MCOLOR)
   RETURN NIL
ENDIF
DBSEEK(MNAMA)
DO WHILE !FOUND() .AND. X<=LEN(MNAMA)
   DBSEEK(LEFT(MNAMA,LEN(MNAMA)-X))
   X++
ENDDO
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MNAMA
