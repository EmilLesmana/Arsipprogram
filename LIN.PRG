Function Lin()
* program LIHAT PABRIK
LOCA I,TGLAWAL,TGLAKHIR,MPMS,ER,BR,TOT,HAL,MJUM,C
 SET COLOR TO
 for i:=1 to 25
   scroll(,,,,-1)
 next

BUKA1()

 SET COLOR TO GR,W/N
 @5,10 SAY 'ISI KODE PEMASOK '
 @6,10 SAY 'JIKA KODE DIKOSONGKAN SELURUH PEMBELIAN AKAN TAMPIL'
 @7,1 SAY '----------------------------------------------------------------------'
TGLAWAL = CTOD(' // ')
TGLAKHIR = CTOD(' // ')
MPMS=SPACE(3)
@ 8,7 SAY '  TANGGAL : 'GET TGLAWAL
@ 8,28 SAY '   SAMPAI'
@ 8,38 SAY '   TANGGAL :'GET TGLAKHIR
READ
IF TGLAKHIR=CTOD(' / / ')
   TGLAKHIR=DATE()
   SET COLOR TO GR+
   @8,51 SAY TGLAKHIR
   SET COLOR TO GR+/B
ENDIF

@9,27 SAY 'PEMASOK' GET  MPMS PICT '@!'
READ

SELE PMSK
IF MPMS#''
   IF !CARI(10,MPMS)
      CLOSE ALL
      Return (nil)
   ENDIF
ENDIF
Sele Ht
Set relation to kodpmsk into pmsk
SELE Trin
SET ORDER TO 2
IF !CARITGL(TGLAWAL)
   KOMENTAR(15,'  DATA TIDAK DITEMUKAN  ')
   @15,0
   CLOSE ALL
   Return (nil)
ENDIF

COPY TO SEM.DBF WHILE TGLIN<=TGLAKHIR
USE SEM NEW
DBGOTOP()

IF MPMS=''
   SET FILTER TO TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR
   DBGOTOP()
   SET RELATION TO KODBRG INTO STK,TO Nobpb INTO Ht
ELSE
   SET FILTER TO TGLIN>=TGLAWAL .AND. TGLIN<=TGLAKHIR .and. mpms==ht->Kodpmsk
   DBGOTOP()
   SET RELATION TO KODBRG INTO STK,TO Nobpb INTO Ht
ENDIF
DBGOTOP()

IF EOF()
   KOMENTAR(15,' DATA TIDAK DITEMUKAN ......... ')
   CLOSE ALL
   Return (nil)
ENDIF
SET COLOR TO
CLEAR
ER:=.N.
SETCOLOR('W/R,GR+/B')
@1,2 SAY ' APAKAH DATA AKAN DICETAK [Y/N] ?' GET ER PICT 'Y'
READ

IF ER
   IF !CEKPRINT()
      close all
      Return (nil)
   ENDIF
   HAL:=1
   @1,1 SAY 'LEMBAR KE - '
   @1,13 SAY HAL PICT '@E 999'
   @ 3,2 SAY ' DAFTAR DATA PEMBELIAN TANGGAL '
   @ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '----------------------------------------------------'
@5,0 SAY '|TANGGAL | NO BPB |   NAMA BARANG      | QTT |SISA |'
@6,0 SAY '----------------------------------------------------'
   BR:=7
DO WHILE ! EOF()
   @ BR,0 SAY '|'+tran(TGLIN,'@d')+'|'+NOBPB+'|'+STK->NAMA+'|'+;
                TRAN(QTT,'@E 9,999')+'|'+TRAN(SISA,'@E 9,999')+'|'
     BR++
  IF BR==60
      @BR,0 SAY '----------------------------------------------------'
      @BR+1,0 SAY ''
      @br+2,0 say ' '
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
      SET COLOR TO
      CLEAR
      KOMENTAR(5,' DATA MASIH ADA, SIAPKAN POSISI KERTAS BARU ')
      @5,0
      IF !CEKPRINT()
         close all
         Return (nil)
      ENDIF
      HAL++
   HAL:=1
   @1,1 SAY 'LEMBAR KE - '
   @1,13 SAY HAL PICT '@E 999'
   @ 3,2 SAY ' DAFTAR DATA PEMBELIAN TANGGAL '
   @ 3,34 SAY Tran(TGLAWAL,'@d')+' SAMPAI TANGGAL '+Tran(TGLAKHIR,'@d')
@4,0 SAY '----------------------------------------------------'
@5,0 SAY '|TANGGAL | NO BPB |   NAMA BARANG      | QTT |SISA |'
@6,0 SAY '----------------------------------------------------'
   BR:=7
   ENDIF
   SKIP
ENDD
@BR,0 SAY '----------------------------------------------------'
@BR+1,0 SAY ''
? ''
      SETPRC(0,0)
      SET PRINT OFF
      SET DEVICE TO SCREEN
KOMENTAR(15,'  DATA SUDAH HABIS,TEKAN ENTER KEMBALI KE MENU !!')
CLOSE ALL
Return (nil)
ENDIF

MJUM:=0
DO WHILE ! EOF()
   MJUM+=(QTT*harga)
   SKIP
ENDDO
DBGOTOP()

  DISPBEGIN()
  SET COLOR TO W/N
  @0,0,24,79 BOX REPLI(CHR(178),79)
  sbox(20,1,23,78,'n+/w')

  @21,2 say chr(179)+'Esc->Keluar'+chr(179)+'CTRL+HOME->Data Kiri'
  @22,2 say 'CTRL+END->Data Kanan'+chr(179)+'PGUP'+chr(179)
  @22,COL() SAY 'PGDN'+chr(179)+'HOME'+chr(179)+'END'+CHR(179)

  SBOX(4,1,17,76,'GR+/B,W/R')
  @ 2,2 SAY ' DAFTAR DATA PEMBELIAN TANGGAL '
  SET COLOR TO W/R
  @ 2,34 SAY TGLAWAL
  SET COLOR TO W/B
  @ 2,col() SAY ' SAMPAI TANGGAL '
  SET COLOR TO W/R
  @ 2,col() SAY TGLAKHIR
  @19,53 SAY 'JUMLAH Rp.'
  @19,COL() SAY MJUM PICT '@E 9,999,999,999'

  TABEL:=TBROWSEDB(5,2,16,75)
  DISPEND()

  tabel:COLORSPEC:='GR+/b,w/R,n/bg,n+/g'
  tabel:addcolumn(tbcolumnnew('TGLIN',{||TGLIN}))
  C:=tbcolumnnew('NO BPB',{||NOBPB})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew('NAMA PEMASOK',{||PMSK->NAMA})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew('NAMA BARANG',{||STK->NAMA})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew(' QTT ',{||TRAN(QTT,'@E 9,999')})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew(' HARGA ',{||TRAN(HARGA,'@e 99,999,999')})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew(' JUMLAH ',{||TRAN(QTT*HARGA,'@E 99,999,999,999')})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)
  c:=tbcolumnnew(' SISA ',{||TRAN(SISA,'@E 9,999')})
  c:ColorBlock:={||If(Sisa>0,{1,2},{3,2})}
  tabel:addcolumn(C)

  SETCURSOR(0)
  TABEL:HEADSEP:=CHR(205)
  TABEL:COLSEP:=CHR(179)
  tabel:footsep:=chr(205)
  tabel:freeze:=2
  tabel:colpos:=3
  do while .t.
     if tabel:colpos>tabel:colcount
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
     elseif tabel:colpos<=tabel:freeze
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
        tabel:colpos:=3
     endif

     do while !tabel:stabilize()
     enddo

     IF TABEL:HitTop .OR. TABEL:HitBottom
        tone(200,1)
        tone(400,1)
        tone(200,1)
        tone(400,1)
     ENDIF
     x:=inkey(0)
     if x==27
        SET CURSOR ON
        CLOSE ALL
        Return (nil)
     endif
     key(x,tabel)
  enddo
Return nil