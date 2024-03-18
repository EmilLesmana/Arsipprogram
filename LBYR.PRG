* program LIHAT PABRIK
LOCAL I,TGLAWAL,TGLAKHIR,BR,MPMSK
 SET COLOR TO
  FOR I:=1 TO 25
     SCROLL(,,,,1)
 NEXT
 SET COLOR TO GR,W/N
 @5,10 SAY 'ISI KODE PEMASOK '
 @6,10 SAY 'JIKA KODE DIKOSONGKAN SELURUH PEMBAYARAN AKAN TAMPIL'
 @7,1 SAY '------------------------------------------------------------------------'
TGLAWAL := CTOD(' // ')
TGLAKHIR := CTOD(' // ')
MPMSK:=SPACE(3)
  @ 8,7 SAY '  TANGGAL : 'GET TGLAWAL
  @ 8,28 SAY '   SAMPAI'
  @ 8,38 SAY '   TANGGAL :'GET TGLAKHIR
  READ
  IF TGLAKHIR=CTOD(' / / ')
     TGLAKHIR:=DATE()
   SET COLOR TO GR+
   @8,51 SAY TGLAKHIR
   SET COLOR TO GR+/B
  ENDIF
  @9,27 SAY 'PEMASOK' GET  MPMSK PICT '@!'
  READ
SELE A
IF !CARITGL(TGLAWAL)
   KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
   CLOSE ALL
   RETURN
ENDIF

ER:=.N.
 SET COLOR TO
 CLEAR
 SET COLOR TO W+/R+
 @1,1 SAY ' APAKAH DATA AKAN DICETAK ?(Y/N) 'GET ER PICT 'Y'
 SET COLOR TO
 READ
IF ER
   IF !CEKPRINT()
      CLOSE ALL
      RETURN
   ENDIF
   HAL:=1
   CLEAR
   SET COLOR TO
@1,1 SAY 'LEMBAR KE - '+TRAN(HAL,'999')
@ 3,2 SAY ' DAFTAR DATA PEMBAYARAN TANGGAL '
@ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '------------------------------------------------------------------------------------'
@5,0 SAY '| TANGGAL  | NO BPB |PMS|  JML HTG  | TGL BYR  |   GIRO    |   TUNAI   |   SISA    |'
@6,0 SAY '------------------------------------------------------------------------------------'

BR := 7
NO:=1
DO WHILE TGLBYR<=TGLAKHIR .AND. .NOT. EOF()
SELE A
IF BR>=21 .AND..NOT.ER
SET COLOR TO GR
@BR,0 say '------------------------------------------------------------------------------------'
    SET COLOR TO GR+/B
    @BR+1,3 SAY ' TEKAN ENTER UNTUK DATA BERIKUTNYA '
 SET COLOR TO W/R
 @1,30 SAY ' TOMBOL [ESC] : UNTUK KEMBALI KE MENU '
 @2,30 SAY ' --#--- [F1]  : UNTUK DATA SEBELUMNYA '
    SET COLOR TO
    K=0
    SET ESCA OFF
    DO WHILE K=0
    K=INKEY()
    ENDDO
    IF K=27
      SET ESCA ON
      SET COLOR TO
      CLEAR
      CLOSE ALL
      RETURN
    ELSE
    IF K=28
     SET ESCA ON
     SKIP -28
     HAL=HAL-1
    ELSE
     HAL=HAL+1
    ENDIF
    ENDIF
    IF HAL<1
      HAL=1
    ENDIF
    SET ESCA ON
    @1,30 CLEAR TO 1,79
    @2,30 CLEAR TO 2,79
    @23,0 CLEAR
    @ 7,0 CLEAR TO 22,78
    SET COLOR TO GR+
@1,13 SAY HAL PICT '999'
    BR=7
ENDIF
SET COLOR TO W/N
  IF MPMSK=''
    @BR,0 SAY '|'
    @ BR,1 SAY TGLHT
    @BR,9 SAY '|'
    @ BR,10 SAY NOBPB
    @BR,18 SAY '|'
    @ BR,19 SAY PMS
    @BR,22 SAY '|'
    SELE B
    SEEK A->NOBPB
    @BR,23 SAY JMLHT PICT '999,999,999'
    @BR,34 SAY '|'
    SELE A
    @ BR,35 SAY TGLBYR
    @BR,43 SAY '|'
    @ BR,44 SAY GIRO PICT '999,999,999'
    @BR,55 SAY '|'
    @ BR,56 SAY TUNAI PICT '999,999,999'
    @BR,67 SAY '|'
    SELE B
    MSISA=JMLHT-(GIRO+TUNAI)
    @ BR,68 SAY MSISA PICT '999,999,999'
    @BR,79 SAY '|'
    BR=BR+1
    UL=UL+1
    SELE A
   ELSE
     IF MPMSK=PMS
    @BR,0 SAY '|'
    @ BR,1 SAY TGLHT
    @BR,9 SAY '|'
    @ BR,10 SAY NOBPB
    @BR,18 SAY '|'
    @ BR,19 SAY PMS
    @BR,22 SAY '|'
    SELE B
    SEEK A->NOBPB
    @BR,23 SAY JMLHT PICT '999,999,999'
    @BR,34 SAY '|'
    SELE A
    @ BR,35 SAY TGLBYR
    @BR,43 SAY '|'
    @ BR,44 SAY GIRO PICT '999,999,999'
    @BR,55 SAY '|'
    @ BR,56 SAY TUNAI PICT '999,999,999'
    @BR,67 SAY '|'
    SELE B
    MSISA=JMLHT-(GIRO+TUNAI)
    @ BR,68 SAY MSISA PICT '999,999,999'
    @BR,79 SAY '|'
    BR=BR+1
    UL=UL+1
    SELE A
     ENDIF
   ENDIF

IF ER
IF UL>=49
@BR,0 say '------------------------------------------------------------------------------------'
    @br+3,0 say ' '
    @br+4,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SREEN
    A2¨@†ž˜ž¤@¨ž