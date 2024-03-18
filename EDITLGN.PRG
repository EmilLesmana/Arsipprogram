* program pemasukan data Langganan
SET COLOR TO
CLEAR
SET COLOR TO GR+/B
USE LGN INDEX LGN
SET COLOR TO W+/B
@ 3,15 SAY '   KOREKSI DATA LANGGANAN   '
SET COLOR TO GR
@5,3 TO 12,70
@13,3 TO 16,70
@7,5 SAY 'KODE LANGGANAN:'
@8,5 SAY 'NAMA          :'
@9,5 SAY 'ALAMAT        :'
@10,5 SAY 'TELPON        :'
DO WHILE .t.
SET COLOR TO ,W/N
MKODE = SPACE(3)
   @ 7,21 GET MKODE PICT '@!'
     READ
     IF MKODE = SPACE(3)
       SET COLOR TO GR+/B
       @ 14,5 SAY ' KEMBALI KE MENU... !!! '
       @ 15,5 SAY ' TEKAN SEMBARANG TOMBOL ............. '
       SET COLOR TO
       WAIT ''
        CLOSE ALL
        RETURN
     ENDIF
     SEEK MKODE
     IF .NOT. FOUND()
       SET COLOR TO GR+/B
       @ 14,5 SAY ' KODE LANGGANAN TIDAK ADA, CARI KODE LAIN !!! '
       @ 15,5 SAY ' TEKAN SEMBARANG TOMBOL ............. '
       SET COLOR TO
       WAIT ''
       @ 14,4 CLEAR TO 15,69
       LOOP
     ELSE
      @ 8,21 GET NAMA PICT '@!'
      @ 9,21 GET ALAMAT PICT '@!'
      @ 10,21 GET TELP PICT '@!'
       READ
     ENDIF

JAWAB=.Y.
SET COLOR TO W/R+
@ 14,5 SAY ' APAKAH ADA DATA LAGI ?(Y/N) ' GET JAWAB PICT 'Y'
READ
 SET COLOR TO
       @ 14,4 CLEAR TO 14,69
IF .NOT. JAWAB
  EXIT
ENDIF
ENDDO
   SET COLOR TO
   CLEAR
   CLOSE ALL
   RETURN

