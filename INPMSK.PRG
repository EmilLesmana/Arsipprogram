Function Inpmsk()
* program pemasukan data Langganan
LOCAL MKODE,MNAMA,MAL,MTEL,HAL,BR,KOL:={},APICT:={},MEDIT,CCHAR:='',;
      nbrs,ncol
SET COLOR TO
for I:=1 TO 25
  SCROLL(,,,,1)
NEXT
#INCLUDE 'INKEY.CH'
SET COLOR TO GR+/B
DBCLOSEALL()
USE PMSK.DMT INDEX PMSKX.MLX,NAMAPMSK.MLX NEW
set delete off
sele pmsk
  DISPBEGIN()
  AADD(KOL,{'KODPMSK','NAMA','ALAMAT','TELP','Totalht'})
  AADD(APICT,{'@!','@!','@!','@!','@E 999,999,999,999'})
  SET COLOR TO n+/N
  @0,0,24,79 BOX REPLI(CHR(219),79)
  SET COLOR TO W/R
  sbox(20,1,23,78,'n+/w')
  @21,2 say chr(179)+'Enter->Koreksi'
  @21,COL() SAY chr(179)+'Esc->Keluar'+chr(179)+'A-Z,0-9->Cari'
  @22,2 say 'F7->Delete'+chr(179)+'F8->Undelete'+chr(179)
  @22,COL() SAY 'F9->Packing'+chr(179)
  @22,COL()  SAY 'F3->Tambah Data'+chr(179)+'F2->Cetak Data'+CHR(179)

  SBOX(4,1,19,76,'GR+/B,W/R')
  setcolor('gr+/n')
  @ 2,2 SAY ' ÝÄÄÄÄÄÄÄÄDAFTAR DATA PEMASOK ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝ'
  TABEL:=TBROWSEDB(5,2,18,75)
  DISPEND()
  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  C:=tbcolumnnew('KODE',{||KODPMSK})
  c:Colorblock:={||If(Delete(),{2,4},If(Totalht>0,{3,4},{1,2}))}
  tabel:addcolumn(c)
  C:=tbcolumnnew('NAMA PEMASOK',{||NAMA})
  c:Colorblock:={||If(Delete(),{2,4},If(Totalht>0,{3,4},{1,2}))}
  tabel:addcolumn(c)
  C:=tbcolumnnew('ALAMAT PEMASOK',{||ALAMAT})
  c:Colorblock:={||If(Delete(),{2,4},If(Totalht>0,{3,4},{1,2}))}
  tabel:addcolumn(c)
  C:=tbcolumnnew('TELEPONE',{||TELP})
  c:Colorblock:={||If(Delete(),{2,4},If(Totalht>0,{3,4},{1,2}))}
  tabel:addcolumn(c)
  C:=tbcolumnnew('TOTAL HUTANG',{||TRAN(TOTALHT,'@E 999,999,999,999')})
  c:Colorblock:={||If(Delete(),{2,4},If(Totalht>0,{3,4},{1,2}))}
  tabel:addcolumn(c)
  SET CURSOR OFF
  TABEL:HEADSEP:='ÍÑÍ'
  TABEL:COLSEP:= ' ³ '
  tabel:footsep:='ÍÏÍ'
//  tabel:freeze:=1
  //tabel:colpos:=2
  do while .t.
   /*  if tabel:colpos>tabel:colcount
        tone(200,1)
        tone(400,1)
     elseif tabel:colpos<=tabel:freeze
        tone(200,1)
        tone(400,1)
        tabel:colpos:=2
     endif
     */
     //do while !tabel:stabilize()
     //enddo
     Tabel:Forcestable()
     nBrs:=Row();nCol:=Col()
     IF TABEL:HITTOP
        BERITA(7,39,' Awal data .............','w/n+')
     elseif TABEL:HITBOTTOM
        BERITA(17,39,' Akhir data ..............','w/r+')
     ENDIF
     x:=eval({||waktu()})
     Devpos(nbrs,nCol)
     if x==27
        SET CURSOR ON
        CLOSE ALL
        exit
     endif
     IF X==13
        IF TABEL:COLPOS==1
           tone(200,1)
           tone(400,1)
           tabel:colpos:=2
           tabel:refreshall()
           loop
        elseif Tabel:colpos==5
           tone(200,1)
           tone(400,1)
           tabel:colpos:=2
           tabel:refreshall()
           LOOP
        ENDIF
        SETCURSOR(1)
        MEDIT:=KOL[1][TABEL:COLPOS]
        If Reclock()
           @ROW(),COL() GET &MEDIT PICT APICT[1][TABEL:COLPOS]
           READ
           dbcommit()
           Unlock
        endif
        TABEL:RIGHT()
        SETCURSOR(0)
        TABEL:REFRESHALL()
     ENDIF
     if x== -1
       TABEL:GOTOP()
         IF !CEKPRINT()
            EXIT
         ENDIF
        CTKPMSK()
        EXIT
     ENDIF

     If UPPER(chr(X)) $ ".,1234567890QWERTYUIOPASDFGHJKLZXCVBNM-*/+' "
        Do case
           case tabel:colpos==1
                set order to 1
           case tabel:colpos==2
                set order to 2
           otherwise
           tone(1000,2)
           loop
        endcase
        tabel:gotop()
        tabel:refreshall()
        //do while !tabel:stabilize()
        //enddo
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

     IF X==-2
        TBDATAP()
        TABEL:COLPOS:=2
        TABEL:REFRESHALL()
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
RETURN nil

FUNCTION TBDATAP()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MKODE:=SPACE(3)
SAVE SCREEN TO MSCREEN
DO WHILE .T.
MKODE:=SPACE(3)
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Kode Pmsk : ' GET MKODE PICT '@!'
READ
IF MKODE==SPACE(3)
   EXIT
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
     REPLACE KODPMSK WITH MKODE
     dbcommit()
     unlock
     EXIT
   Endif
ENDIF
ENDDO
SETCURSOR(0)
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MKODE


FUNCTION CTKPMSK()
LOCAL HAL:=1,BR,UL
 CLEAR
 @1,1 SAY 'LEMBAR KE - '
 @1,13 SAY HAL PICT '999'
 @ 3,15 SAY '   DAFTAR DATA PEMASOK   '
@4,0 SAY '--------------------------------------------------------------------------------'
@5,0 SAY '|KOD|      NAMA PEMASOK       |        ALAMAT                  |   TELEPON     |'
@6,0 SAY '--------------------------------------------------------------------------------'

BR := 7
UL:=0
DO WHILE .NOT. EOF()
    @ BR,0 SAY '|'+KODPMSK+'|'+NAMA+'|'+ALAMAT+'|'+TELP+'|'
IF BR=60
@BR+1,0 SAY '--------------------------------------------------------------------------------'
    @br+3,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
       RETURN NIL
    ENDIF
    HAL++
    @1,1 SAY 'LEMBAR KE - '
    @1,13 SAY HAL PICT '999'
 @ 3,15 SAY '   DAFTAR DATA PEMASOK   '
@4,0 SAY '--------------------------------------------------------------------------------'
@5,0 SAY '|KOD|      NAMA PEMASOK       |        ALAMAT                  |   TELEPON     |'
@6,0 SAY '--------------------------------------------------------------------------------'
    BR:=6
    UL:=0
ENDIF
    BR++
    UL++
    SKIP
ENDD
@BR,0 SAY '--------------------------------------------------------------------------------'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO GR+/B
 @ 23,20 SAY '  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!'
 WAIT ''
RETURN NIL