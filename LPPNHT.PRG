Function LPPNht()
LOCAL I,ER,BR,TGLAWAL,TGLAKHIR,PIL,MKOD,MJUM
SET COLOR TO
 FOR I:=1 TO 25
     SCROLL(,,,,-1)
 NEXT
Bukabyr()
SELE Ht
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

COPY TO SEM.DBF WHILE TGLin<=TGLAKHIR
use sem New
DBGOTOP()
MKOD:=SPACE(3)

SET COLOR TO GR+/B,W/R
@7,40 SAY ' PEMASOK : ' GET MKOD PICT '@!'
READ
@5,20 SAY ' PILIH DATA YANG AKAN DI TAMPILKAN '
@6,5 PROMPT ' 1. CASH   '
@7,5 PROMPT ' 2. KREDIT '
@8,5 PROMPT ' 3. LUNAS  '
MENU TO PIL
TE=' LAPORAN PPN MASUKAN PERUSAHAAN '
DO CASE
   CASE PIL=1
     IF MKOD=''
       SET FILTER TO STATUS='C' .or. status=='CASH  '.AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR
     ELSE
       SET FILTER TO STATUS='C' .or. Status=='CASH  '.AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR;
      .AND. kodPMSk==MKOD
     ENDIF
     DBGOTOP()
     SET RELATION TO kodPMSk INTO Pmsk

    CASE PIL=2
     IF MKOD=''
       SET FILTER TO STATUS='H' .or. Status=='KREDIT' .AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR
     ELSE
       SET FILTER TO STATUS='H' .or. Status=='KREDIT' .AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR;
      .AND. kodPMSk==MKOD
     ENDIF
     DBGOTOP()
     SET RELATION TO KODPMSK INTO PMSK

    CASE PIL=3
     IF MKOD=''
       SET FILTER TO STATUS='L' .or. Status=='LUNAS ' .AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR
     ELSE
       SET FILTER TO STATUS='L' .or. Status=='LUNAS ' .AND. TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR;
      .AND. kodPMSk==MKOD
     ENDIF
     DBGOTOP()
     SET RELATION TO KODPMSK INTO PMSK
 ENDCASE

SET COLOR TO GR+/B
@1,15 SAY TE

ER=.N.
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
         MJUM+=(Jmlht*0.1)
         SKIP
       ENDDO
    SET COLOR TO W/R
    @23,30 SAY ' TOTAL PPN      ---> '
    @23,56 SAY MJUM PICT '@E 999,999,999,999'
    ELSE
       MJUM:=0
       DO WHILE .NOT. EOF()
         MJUM+=(jmlht*0.1)
         SKIP
       ENDDO

    ENDIF
   DBGOTOP()
    TPL[1] = 'NOBPB'
    TPL[2] = 'TGLIN'
    TPL[3] = 'PMSK->NAMA'
    TPL[4] = 'JMLHT+(jmlht*0.1)'
    TPL[5] = 'TUNAI'
    TPL[6] = '(jmlht*0.1)'
    TPL[7] = 'STATUS'

    APICT[1]='@!'
    APICT[2]='@D'
    APICT[3]='@!'
    APICT[4]='@E 99,999,999,999'
    APICT[5]='@E 99,999,999,999'
    APICT[6]='@E 99,999,999,999'
    APICT[7]='@!'

    AJUD[1]='NOMOR; BPB '
    AJUD[2]='TANGGAL;NOTA'
    AJUD[3]=' PEMASOK '
    AJUD[4]=' JUMLAH UTANG'
    AJUD[5]='NILAI TUNAI'
    AJUD[6]=' P P N '
    AJUD[7]='STATUS'

    SET COLOR TO W/N
    @0,0,24,80 BOX REPLI(CHR(178),9)
    SET COLOR TO W/R
    @23,30 SAY ' TOTAL P P N       ---> '
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
    SBOX(4,4,21,76,'GR+/B,W/R')
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
@4,1 SAY '--------------------------------------------------------------------------------------------'
@5,1 SAY '| NO BPB   | TGL NOTA |        PEMASOK          | JML UTANG |NILAI TUNAI|   P P N   |STATUS|'
@6,1 SAY '--------------------------------------------------------------------------------------------'

   BR:=7
   MJUM:=0
 DO WHILE .NOT. EOF()
   @BR,1 SAY '|'+padr(NOBPB,10)+'|'+tran(TGLIN,'@d')+'|'+PMSK->NAMA+'|'+TRAN(JMLHT+(jmlht*0.1),'@E 999,999,999')
   @BR,PCOL() SAY '|'+TRAN(TUNAI,'@E 999,999,999')+;
   '|'+TRAN((jmlht*0.1),'@E 999,999,999')+'|'+pADC(STATUS,6)+'|'
      MJUM+=(jmlht*0.1)

   IF BR=55
@br+1,1 SAY '--------------------------------------------------------------------------------------------'
     @BR+2,50 SAY ' Total ----> '+Tran(MJUM,'@E 999,999,999,999')
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
           @3,31 SAY TGLAWAL
           @3,40 SAY '-'
           @3,43 SAY TGLAKHIR
@4,1 SAY '--------------------------------------------------------------------------------------------'
@5,1 SAY '| NO BPB   | TGL NOTA |        PEMASOK          | JML UTANG |NILAI TUNAI|   P P N   |STATUS|'
@6,1 SAY '--------------------------------------------------------------------------------------------'
       ENDIF
        BR++
        SKIP
    ENDDO
@br,1 SAY '------------------------------------------------------------------------------------------'
     @BR+1,50 SAY ' Total --> '+tran(MJUM,'@E 999,999,999,999')
        @BR+2,1 SAY ''
        ?? CHR(18)
        SETPRC(0,0)
        SET PRINT OFF
        SET DEVICE TO SCREEN
        CLOSE ALL
        Return (nil)
  ENDIF
Return nil