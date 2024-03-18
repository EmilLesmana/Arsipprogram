Function Lnobpb()
 * PROGRAM PENERIMAAN BARANG
set color to
CLEAR
Buka1()
BKIN('PEMBELIAN BARANG')
* --------- TAMPILAN LAYAR ------------------- *

WHILE .T.
 SET COLOR TO W/N,W/N
 MNOBPB:=SPACE(8)
 @3,10 GET MNOBPB PICT '@!'
 READ
 IF MNOBPB=''
   CLOSE ALL
   Return (nil)
 ENDIF

 Sele Ht
 Set Relation To Kodpmsk into Pmsk
 SELE Trin
 Set Relation to Nobpb into Ht,to Kodbrg into stk

 IF !CARI(23,MNOBPB)
    @23,0
    LOOP
 ELSE
    EXIT
 ENDIF
ENDDO


@4,10 SAY TGLIN
@5,15 SAY Ht->KodPMSk PICT '@!'
@3,49 SAY Pmsk->NAMA
@4,48 SAY Pmsk->ALAMAT
NO:=1
BR:=9
MTOT:=0
MKODBRG:=SPACE(10)
MQTT:=0
MHARGA:=0

WHILE MNOBPB=NOBPB .AND. .NOT. EOF()
   SET COLOR TO W/N,W/N
   @BR,2 SAY NO PICT '99'
   @BR,5 SAY KODBRG PICT '@!'
   @BR,16 SAY stk->NAMA
   @BR,37 SAY QTT PICT '9,999'
   @BR,43 SAY HARGA PICT '9,999,999'
  JUMLAH:=QTT*HARGA
  @BR,53 SAY JUMLAH PICT '999,999,999'
  MTOT+=JUMLAH

 IF BR=17
   KOMENTAR(23,' GANTI HALAMAN BARU,TEKAN SEMBARANG TOMBOL ...... ')
  @9,0 CLEAR TO 23,70
  BR:=8
 ENDIF
 SET COLOR TO
  @23,0
  NO++
  BR++
  SKIP
ENDDO

@19,53 SAY Ht->JmlHt PICT '999,999,999'
@20,53 SAY Ht->Tunai PICT '999,999,999'
@21,53 SAY Ht->Jmlht-Ht->Tunai PICT '999,999,999'

KOMENTAR(23,' TEKAN SEMBARANG TOMBOL KEMBALI KE MENU ...... ')
CLOSE ALL
Return (nil)
