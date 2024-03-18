Function Inlgn()
* program pemasukan data Langganan
LOCAL MKODE,MNAMA,MAL,MTEL,HAL,BR,KOL:={},APICT:={},MEDIT,CCHAR:=''
SET COLOR TO
for I:=1 TO 25
  SCROLL(,,,,1)
NEXT
#INCLUDE 'INKEY.CH'
DBCLOSEALL()
SET COLOR TO GR+/B
USE LGN.DMT INDEX LGN.MLX,NAMAX.MLX NEW
  set delete off
  sele lgn
  set order to 1
  DISPBEGIN()
  AADD(KOL,{'KODELGN','NAMA','ALAMAT','ALAMAT2','ALAMAT3','NPWP','TELP','TOTALUT'})
  AADD(APICT,{'@!','@!','@!','@!','@!','@!','@!','@E 999,999,999'})
  SET COLOR TO N+/N
  @0,0,24,79 BOX REPLI(CHR(219),9)
  SET COLOR TO W/R
  sbox(20,1,23,78,'n+/w')
  @21,2 say '0-9,A-Z->Cari'+chr(179)+'Enter->Koreksi'
  @21,COL() SAY chr(179)+'Esc->Keluar'+chr(179)+'F7->Delete'
  @22,2 say 'F8->Undelete'+chr(179)+'F9->Packing'+chr(179)
  @22,COL()  SAY 'F3->Tambah Data'+chr(179)+'F2->Cetak Data'+CHR(179)

  SBOX(4,1,19,76,'GR+/B,W/R')
  setcolor('gr+/n')
  @ 2,2 SAY 'ÝÄÄÄÄ DAFTAR DATA PELANGGAN ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝ'
  TABEL:=TBROWSEDB(5,2,18,75)
  DISPEND()
  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  C:=tbcolumnnew('KODE',{||KODELGN})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('NAMA LANGGANAN',{||NAMA})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('ALAMAT LANGGANAN',{||ALAMAT})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('ALAMAT 2',{||ALAMAT2})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('ALAMAT 3',{||ALAMAT3})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('N P W P',{||NPWP})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('TELEPONE',{||TELP})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  C:=tbcolumnnew('TOTAL UTANG',{||TRAN(TOTALUT,'@E 999,999,999')})
  C:COLORBLOCK:={||If(Delete(),{2,4},IF(TOTALUT=0,{3,4},{1,4}))}
  tabel:addcolumn(C)
  SET CURSOR OFF
  TABEL:HEADSEP:='ÍÑÍ'
  TABEL:COLSEP:= ' ³ '
  tabel:footsep:='ÍÏÍ'
//  tabel:freeze:=1
//  tabel:colpos:=2
  do while .t.
   /*  if tabel:colpos>tabel:colcount
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
     elseif tabel:colpos<=tabel:freeze
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
        tabel:colpos:=2
     endif
     */
     do while !tabel:stabilize()
     enddo
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
        cChar:=''
        IF TABEL:COLPOS==8
           tone(200,1)
           tone(400,1)
           tone(200,1)
           tone(400,1)
           tabel:colpos:=1
           tabel:Refreshall()
           LOOP
        elseif Tabel:colpos==1
           tone(200,1)
           tone(400,1)
           tabel:colpos:=2
           tabel:Refreshall()
           LOOP
        ENDIF
        SETCURSOR(1)
        MEDIT:=KOL[1][TABEL:COLPOS]
        If Reclock()
           @ROW(),COL() GET &MEDIT PICT APICT[1][TABEL:COLPOS]
           READ
           dbcommit()
           unlock
        endif
        TABEL:RIGHT()
        SETCURSOR(0)
        TABEL:REFRESHALL()
     ENDIF

     if x== -1
       TABEL:GOTOP()
       TABEL:REFRESHALL()
       do while !tabel:stabilize()
       enddo
         IF !CEKPRINT()
            EXIT
         ENDIF
        CTKLGN()
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

     IF X==-2
        cChar:=''
        SET ORDER TO 1
        TBHDATA()
        TABEL:COLPOS:=2
        TABEL:REFRESHALL()
     ENDIF
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

FUNCTION TBHDATA()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MKODE:=SPACE(3)
SAVE SCREEN TO MSCREEN
DO WHILE .T.
MKODE:=SPACE(3)
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Kode Lgn : ' GET MKODE PICT '@!'
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
     REPLACE KODELGN WITH MKODE
     unlock
  endif
  EXIT
ENDIF
ENDDO
SETCURSOR(0)
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MKODE


FUNCTION CTKLGN()
LOCAL HAL:=1,BR,UL
 CLEAR
 @1,1 SAY 'LEMBAR KE - '
 @1,13 SAY HAL PICT '999'
 @ 3,15 SAY '   DAFTAR DATA LANGGANAN   '
@4,0 SAY '--------------------------------------------------------------------------------'
@5,0 SAY '|            NAMA LANGGANAN             |        ALAMAT                        |'
@6,0 SAY '--------------------------------------------------------------------------------'

BR := 7
UL:=0
DO WHILE .NOT. EOF()
    @ BR,0 SAY '|'+Padl(NAMA,39)+'|'+Padl(ALAMAT,38)+'|'
IF BR=60
@br+1,0 SAY '--------------------------------------------------------------------------------'
    @br+3,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO
    CLEAR
    KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
    IF !CEKPRINT()
       RETURN NIL
    ENDIF
    HAL++
    @1,1 SAY 'LEMBAR KE - '
    @1,13 SAY HAL PICT '999'
    @ 3,15 SAY '   DAFTAR DATA LANGGANAN   '
@4,0 SAY '--------------------------------------------------------------------------------'
@5,0 SAY '|            NAMA LANGGANAN             |        ALAMAT                        |'
@6,0 SAY '--------------------------------------------------------------------------------'
    BR:=6
    UL:=0
ENDIF
    BR++
    UL++
    SKIP
ENDD
@br,0 SAY '--------------------------------------------------------------------------------'
?' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
    SET COLOR TO GR+/B
 @ 23,20 SAY '  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!'
 WAIT ''
RETURN NIL

static function CRnama()
LOCAL MSCREEN,MCOLOR:=SETCOLOR(),X:=1,MNAMA:=SPACE(3)
SAVE SCREEN TO MSCREEN
sbox(10,20,12,60,'W/N+,W/N+')
SETCURSOR(1)
@11,21 SAY 'Kode Langganan : ' GET MNAMA PICT '@!'
READ
SETCURSOR(0)
IF MNAMA==''
   close all
   RETURN NIL
ENDIF
DBSEEK(MNAMA)
DO WHILE !FOUND() .AND. X<=LEN(MNAMA)
   DBSEEK(LEFT(MNAMA,LEN(MNAMA)-X))
   X++
ENDDO
REST SCREEN FROM MSCREEN
SETCOLOR(MCOLOR)
RETURN MNAMA