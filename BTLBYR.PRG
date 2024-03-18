Function Btlbyr()
local MTGLBYR,MKET,MGIRO,mtunai,msisa,mtgl,LIH,mjum
      mjum:=0
geser(2)
bukabyr()
#xcommand warna => setcolor('w/n,w/n')
   SETCOLOR('GR+/B,W/R')
   @1,1 PROMPT ' 1. PEMBAYARAN HUTANG PERUSAHAAN '
   @1,COL()+1 PROMPT ' 2. PEMBAYARAN HUTANG LANGGANAN '
   @1,COL()+1 PROMPT ' 3. KELUAR '
   MENU TO LIH
   IF LIH %3=0
      close all
      return nil
   ENDIF
   SET COLOR TO GR
   @3,3 TO 18,70
   IF LIH=1
      @5,5 SAY 'TGL BAYAR  :'
      @6,5 SAY 'NO BPB     :'
      @7,5 SAY 'KODE SPL   :'
      @8,5 SAY 'NAMA       :'
      @9,5 SAY 'ALAMAT     :'
      @10,5 SAY 'JML UTANG  :Rp.'
   ELSE
      @5,5 SAY 'TGL BAYAR  :'
      @6,5 SAY 'NO FAKTUR  :'
      @7,5 SAY 'KODE LGN   :'
      @8,5 SAY 'TOKO       :'
      @9,5 SAY 'ALAMAT     :'
      @10,5 SAY 'JML UTANG  :Rp.'
   ENDIF
   @11,5 SAY 'JML BAYAR  :Rp.'
   @12,5 SAY 'SISA UTANG :Rp.'
   @13,5 SAY 'TGL AMBIL :'
   @14,5 SAY 'KETERANGAN:'
   @15,5 SAY 'NILAI GIRO :Rp.'
   @16,5 SAY 'NILAI TUNAI:Rp.'
   @17,5 SAY 'SISA       :Rp.'
   WHILE .T.
      warna;MTGL:=DATE();MNO:=SPACE(8)
      IF LIH=1
         @5,17 GET MTGL
         @6,17 GET MNO PICT '@!'
         READ
         IF MNO==space(8)
            close all
            return nil
         ENDIF
         SELE TRHT
         SET ORDER TO 2
         SEEK MTGL
         WHILE TGLBYR=MTGL .AND. MNO#NOBPB .AND. !EOF()
            SKIP
         ENDDO
         IF MNO#NOBPB
            BERITA(21,30,' DATA TIDAK DITEMUKAN, TEKAN SEMBARANG TOMBOL ... ','GR+/B')
            @21,0
            LOOP
         ENDIF
         sele Ht
         SEEK MNO
         @7,17 SAY KODPMSK
         sele pmsk
         SEEK Ht->KODPMSK
         @8,17 SAY NAMA
         @9,17 SAY ALAMAT
         sele Ht
         mjum:=JmlHt
         @10,21 SAY mjum PICT '@E 99,999,999,999.99'
         @11,21 SAY (TRHT->GIRO+TRHT->TUNAI) PICT '@E 99,999,999,999.99'
         @12,21 SAY mjum-(TRHT->GIRO+TRHT->TUNAI) PICT '@E 99,999,999,999.99'
         @13,17 SAY TGLIN
         SELE TRHT
         EXIT
      ELSE
         MNO:=0
         @5,17 GET MTGL
         @6,17 GET MNO PICT '99999'
         READ
         IF MNO==0
            close all
            return nil
         ENDIF
         SELE TRPT
         SET ORDER TO 2
         SEEK MTGL
         WHILE MTGL=TGLBYR .AND. MNO#FAKTUR .AND. !EOF()
            SKIP
         ENDDO
         IF MNO#FAKTUR
            BERITA(21,30,' DATA TIDAK DITEMUKAN, TEKAN SEMBARANG TOMBOL ... ','GR+/B')
            @21,0
            LOOP
         ENDIF
         sele Put
         SEEK MNO
         @7,17 SAY Kodelgn
         sele lgn
         SEEK Put->Kodelgn
         @8,17 SAY NAMA
         @9,17 SAY ALAMAT
         sele Put
         @10,21 SAY Jmlpt PICT '@E 99,999,999,999.99'
         @11,21 SAY (TRPT->GIRO+TRPT->TUNAI) PICT '@E 99,999,999,999.99'
         @12,21 SAY JmlPt-(TRPT->GIRO+TRPT->TUNAI) PICT '@E 99,999,999,999.99'
         @13,17 SAY TGLOUT
         SELE TRPT
         EXIT
      ENDIF
   ENDDO
// -------------------------------------------------------------------------

   @14,17 SAY BANK PICT '@!'
   @15,21 SAY GIRO PICT '@Z 99,999,999,999.99'
   @16,21 SAY TUNAI PICT '@Z 99,999,999,999.99'
   IF LIH=1
      sele Ht
      MSISA:=mJum-(TRhT->GIRO+TRhT->TUNAI)
      @17,21 SAY MSISA PICT '@E 99,999,999,999.99'
      JAW:=.N.
      SETCOLOR('GR+/B,W/R')
      @21,15 SAY ' APAKAH DATA AKAN DIBATALKAN [Y/N] ? ' GET JAW PICT 'Y'
      READ
      IF JAW
         sele pmsk
         REPLACE TOTALHT WITH TOTALHT+(TRHT->GIRO+TRHT->TUNAI)
         SELE Ht
         REPLACE Tunai WITH Tunai-(TRHT->GIRO+TRHT->TUNAI),STATUS WITH "H"
         sele trHT
         DELETE
         BERITA(21,30,' DATA SUDAH DIBATALKAN, TEKAN SEMBARANG TOMBOL ... ','W+*/R')
      ELSE
         BERITA(21,30,' DATA TIDAK DIBATALKAN, TEKAN SEMBARANG TOMBOL ... ','GR+/B')
      ENDIF
      // close all ; return nil
   ELSE
      sele Put
      MSISA:=JmlPt-(TRPT->GIRO+TRPT->TUNAI)
      @17,21 SAY MSISA PICT '@E 99,999,999,999.99'
      JAW:=.N.
      SETCOLOR('GR+/B,W/R')
      @21,15 SAY ' APAKAH DATA AKAN DIBATALKAN [Y/N] ? ' GET JAW PICT 'Y'
      READ
      IF JAW
         sele lgn
         REPLACE TOTALUT WITH TOTALUT+(TRPT->GIRO+TRPT->TUNAI)
         sele Put
         REPLACE Tunai WITH Tunai-(TRPT->GIRO+TRPT->TUNAI),STATUS WITH 'H'
         sele trPT
         DELETE
         BERITA(21,30,' DATA SUDAH DIBATALKAN, TEKAN SEMBARANG TOMBOL .. ','W*/R')
      ELSE
         BERITA(21,30,' DATA TIDAK DIBATALKAN, TEKAN SEMBARANG TOMBOL .. ','GR+/B')
      ENDIF
      // close all ; return nil
   ENDIF
   close all
Return nil