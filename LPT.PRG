Function Lpt()
LOCAL I,ER,BR,TGLAWAL,TGLAKHIR,PIL,MKOD,MJUM
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
Buka2()
SELE put
set order to 2

SET COLOR TO GR+/B
@3,15 SAY ' TANGGAL : '
@3,35 SAY '  SAMPAI '
@3,45 SAY ' TANGGAL : '
TGLAWAL:=CTOD(' - - ')
TGLAKHIR:=CTOD(' - - ')
@3,26 GET TGLAWAL
READ

IF TGLAWAL=CTOD(' - - ')
  SET COLOR TO
  CLOSE ALL
  CLEAR
  Return (nil)
ENDIF

@3,56 GET TGLAKHIR
READ

IF TGLAKHIR=CTOD(' - - ')
  TGLAKHIR:=DATE()
  @3,56 SAY TGLAKHIR
ENDIF

IF !CARITGL(TGLAWAL)
   KOMENTAR(15,' DATA TIDAK DITEMUKAN ....... ')
     @15,0
     CLOSE ALL
     Return (nil)
ENDIF
copy to sem while Tglout>=Tglawal .and. Tglout<=Tglakhir .and. !Eof()
USE SEM new
DBGOTOP()

MKOD:=SPACE(3)

SET COLOR TO GR+/B,W/R
@7,40 SAY ' KODE LGN  : ' GET MKOD PICT '@!'
READ
@5,20 SAY ' PILIH DATA YANG AKAN DI TAMPILKAN '
@6,5 PROMPT ' 1. CASH   '
@7,5 PROMPT ' 2. KREDIT '
@8,5 PROMPT ' 3. LUNAS  '
MENU TO PIL
TE=' LAPORAN DATA HUTANG LANGGANAN '
DBGOTOP()
DO CASE
   CASE PIL=1
     IF MKOD=='   '
        SET FILTER TO STATUS='C     ' 
     else
       set filter to KODELGN==MKOD .and. STATUS='C     ' 
     ENDIF
    CASE PIL=2
     IF MKOD=='   '
        SET FILTER TO STATUS='H     ' 
     else
       set filter to KODELGN==MKOD .and. STATUS='H     ' 
     ENDIF
    CASE PIL=3
     IF MKOD=='   '
        SET FILTER TO STATUS='L     ' 
     else
       set filter to KODELGN==MKOD .and. STATUS='L     ' 
     ENDIF
 ENDCASE
     //dbgotop()
     //IF MKOD<>'   '
     //   set filter to KODELGN==MKOD 
     //ENDIF
dbgotop()
set relation to Kodelgn into Lgn

SET COLOR TO GR+/B
@1,15 SAY TE

ER:=.N.
SET COLOR TO W/R,N*/G
@11,1 SAY ' APAKAH DATA AKAN DI CETAK [Y/N]? ' GET ER PICT 'Y'
READ


SET COLOR TO
CLEAR
IF EOF()
   KOMENTAR(10,' DATA TIDAK ADA ........ ')
   CLOSE ALL
   Return (nil)
ENDIF

DECLARE TPL[10],APICT[10],AJUD[10]

  IF .NOT. ER
    IF PIL=1 .AND. PIL=3
       MJUM:=0
       DO WHILE .NOT. EOF()
         MJUM+=JMLPT
         SKIP
       ENDDO
    SET COLOR TO W/R
    @23,30 SAY ' TOTAL LUNAS / CASH ---> '
    @23,56 SAY MJUM PICT '@E 999,999,999,999'
    ELSE
       MJUM:=0
       DO WHILE .NOT. EOF()
         MJUM+=(JMLPT-TUNAI)
         SKIP
       ENDDO

    ENDIF
   DBGOTOP()
    TPL[1] = 'FAKTUR'
    TPL[2] = 'Tglout'
    TPL[3] = 'LGN->NAMA'
    TPL[4] = 'JMLPT'
    TPL[5] = 'TUNAI'
    TPL[6] = 'JMLPT-TUNAI'
    TPL[7] = 'STATUS'

    APICT[1]='@!'
    APICT[2]='@D'
    APICT[3]='@!'
    APICT[4]='@E 99,999,999,999'
    APICT[5]='@E 99,999,999,999'
    APICT[6]='@E 99,999,999,999'
    APICT[7]='@!'

    AJUD[1]='NOMOR; FAKTUR '
    AJUD[2]='TANGGAL;NOTA'
    AJUD[3]=' KREDITUR '
    AJUD[4]=' JUMLAH UTANG'
    AJUD[5]='NILAI TUNAI'
    AJUD[6]='SISA UTANG'
    AJUD[7]='STATUS'

    SET COLOR TO W/N
    @0,0,24,80 BOX REPLI(CHR(178),9)
    SET COLOR TO W/R
    @23,30 SAY ' TOTAL SISA HUTANG ---> '
    @23,56 SAY MJUM PICT '@E 999,999,999,999.99'
    SET COLOR TO GR+/B
     @1,15 SAY TE
     @2,20 SAY ' PERIODE :'
    SET COLOR TO W/R
     @2,COL()+2 SAY TGLAWAL
    SET COLOR TO GR+/B
     @2,COL()+2 SAY '-'
    SET COLOR TO W/R
     @2,COL()+2 SAY TGLAKHIR
    DO SBOX WITH 4,4,21,76,'GR+/B,W/R'
    DBEDIT(5,5,20,75,TPL,'FUNGSI',APICT,AJUD)
    Return (nil)

  ELSE
      IF !cekprint()
         CLOSE ALL
         Return (nil)
      ENDIF
       ?? CHR(15)
       @1,15 SAY TE
       @3,20 SAY ' PERIODE :'
       @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '------------------------------------------------------------------------------------------'
@5,1 SAY '|FAKTUR  | TGL NOTA |        KREDITUR         | JML UTANG |NILAI TUNAI|SISA UTANG |STATUS|'
@6,1 SAY '------------------------------------------------------------------------------------------'
   BR:=7;MJUM:=0
DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+Padr(FAKTUR,8)+'|'+tran(Tglout,'@d')+'|'+LGN->NAMA+'|'+TRAN(JMLPT,'@E 999,999,999')
   @BR,PCOL() SAY '|'+TRAN(TUNAI,'@E 999,999,999')+;
   '|'+TRAN(JMLPT-(GIRO+TUNAI),'@E 999,999,999')+'|'+STATUS+'|'
   IF PIL=1 .AND. PIL=3
      MJUM+=JMLPT
   ELSE
      MJUM+=(JMLPT-TUNAI)
   ENDIF

   IF BR=55
@BR+1,1 SAY '------------------------------------------------------------------------------------------'
   IF PIL=1 .AND. PIL=3
     @BR+2,44 SAY MJUM PICT '@E 999,999,999,999'
   ELSE
     @BR+2,90 SAY MJUM PICT '@E 999,999,999,999'
   ENDIF
     ? ''
     SETPRC(0,0)
     SET PRINT OFF
     SET DEVICE TO SCREEN
     KOMENTAR(1,' DATA MASIH ADA, SIAPKAN PRINTER ANDA ..... ')
        ?? CHR(18)
     IF !CEKPRINT()
        CLOSE ALL
        Return (nil)
     ENDIF
     BR:=6
     ?? CHR(15)
           @1,15 SAY TE
           @3,20 SAY ' PERIODE :'
           @3,31 SAY Tran(TGLAWAL,'@d')+' - '+Tran(TGLAKHIR,'@d')
@4,1 SAY '------------------------------------------------------------------------------------------'
@5,1 SAY '|FAKTUR  | TGL NOTA |        KREDITUR         | JML UTANG |NILAI TUNAI|SISA UTANG |STATUS|'
@6,1 SAY '------------------------------------------------------------------------------------------'
       ENDIF
        BR++
        SKIP
    ENDDO
@BR,1 SAY '------------------------------------------------------------------------------------------'
   IF PIL=1 .AND. PIL=3
     @BR+1,44 SAY MJUM PICT '@E 999,999,999,999'
   ELSE
     @BR+1,90 SAY MJUM PICT '@E 999,999,999,999'
   ENDIF
        @BR+2,1 SAY ''
        ?? CHR(18)
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
  ENDIF
Return Nil