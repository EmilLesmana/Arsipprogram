Memvar getlist
Field Tglin,nota,Nama,Kodbrg,Kodelgn,tglabl,mukA,;
      mobil,qtt,harga,pms,bukti,nobpb
Function Lnopostk()
 * PROGRAM BATAL PENERIMAAN BARANG
LOCAL MBUKTI,MNOBPB,MPMS,JDL,TPL,MHARGA,JAWAB,JUMLAH,MCOLOR,i,ISI,CEK:=1
LOCAL NO:=1,BR:=9,MQTT,MKODBRG:=SPACE(10),MTGL:=DATE()

set color to
FOR I:=1 TO 80
  SCROLL(,,,,,-1)
NEXT
BUKA1()
* --------- BINGKAI ------------------- *
BKSTK(' BUKTI PENERIMAAN ')
// CARI NOMOR BUKTI -----------------------------------------
DO WHILE .T.
   SELE TRSTK
   SET COLOR TO W+/N,W/N+
   MCOLOR:=SETCOLOR()
   MBUKTI:=SPACE(8)
   MTGL:=TGLIN
   @5,10 GET MBUKTI PICT '@!'
   READ
   IF MBUKTI=''
      CLOSE ALL
      Return (nil)
   ENDIF
   SEEK MBUKTI
   IF !FOUND()
      KOMENTAR(23,' NOMOR BUKTI TIDAK DITEMUKAN .... ')
      @23,0
      LOOP
   ELSE
      @3,10 SAY NOBPB
      SELE MASUK
      SET RELATION TO PMS INTO PMSK
      SEEK TRSTK->NOBPB
      @3,40 SAY PMS
      @4,40 SAY PMSK->NAMA
      @5,40 SAY PMSK->ALAMAT
      @4,10 SAY TGLIN
      EXIT
   ENDIF
ENDDO

SELE TRSTK
DO WHILE MBUKTI==BUKTI .AND. !EOF()
   // CARI  KODE  BARANG
   SELE TRSTK
   SET RELATION TO KODBRG INTO STK
   SET COLOR TO W+/N,W/N+
   MCOLOR:=SETCOLOR()
   @BR,2 SAY NO PICT '99'
   @BR,5 SAY KODBRG PICT '@!'
   @BR,16 SAY STK->NAMA
   @BR,40 SAY QTT PICT '@E 999,999'

   SETCOLOR(MCOLOR)

   IF BR=17
      KOMENTAR(23,' GANTI HALAMAN BARU,TEKAN SEMBARANG TOMBOL ...... ')
      @9,0 CLEAR TO 23,70
      BKSTK(' BUKTI PENERIMAAN ')
      BR:=8
   ENDIF
   @23,0
   NO++
   BR++
   SKIP
ENDDO

KOMENTAR(23,' TEKAN SEMBARANG TOMBOL KEMBALI KE MENU ...... ')
CLOSE ALL
Return (nil)
