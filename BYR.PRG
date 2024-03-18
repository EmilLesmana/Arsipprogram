Function Byr()
local MTGLBYR,MKET,MGIRO,mtunai,msisa,mtgl,LIH,mjum
      mjum:=0
geser(2)
bukabyr()
#xcommand warna => setcolor('w/n,w/n')
WHILE .T.
   SETCOLOR('GR+/B,W/R')
   @1,1 PROMPT ' 1. PEMBAYARAN HUTANG PERUSAHAAN '
   @1,COL()+1 PROMPT ' 2. PEMBAYARAN HUTANG LANGGANAN '
   @1,COL()+1 PROMPT ' 3. KELUAR '
   MENU TO LIH
   IF LIH %3=0
      CLOSE ALL
      RETURN nil
   ENDIF
   SET COLOR TO GR
   @3,3 TO 18,70
   IF LIH=1
      @6,5 SAY 'TGL NOTA   :'
      @5,5 SAY 'NO BPB     :'
      @7,5 SAY 'KODE SPL   :'
      @8,5 SAY 'NAMA       :'
      @9,5 SAY 'ALAMAT     :'
      @10,5 SAY 'JML UTANG  :Rp.'
   ELSE
      @6,5 SAY 'TGL NOTA   :'
      @5,5 SAY 'NO FAKTUR  :'
      @7,5 SAY 'KODE LGN   :'
      @8,5 SAY 'NAMA       :'
      @9,5 SAY 'ALAMAT     :'
      @10,5 SAY 'JML UTANG  :Rp.'
   ENDIF
   @11,5 SAY 'JML BAYAR  :Rp.'
   @12,5 SAY 'SISA UTANG :Rp.'
   @13,5 SAY 'TGL BAYAR :'
   @14,5 SAY 'KETERANGAN:'
   @15,5 SAY 'NILAI GIRO :Rp.'
   @16,5 SAY 'NILAI TUNAI:Rp.'
   @17,5 SAY 'SISA       :Rp.'
   WHILE .T.
      warna;MTGL:=DATE();MNO:=SPACE(8)
      IF LIH=1
         @5,17 GET MNO PICT '@!'
         READ
         IF MNO=''
            CLOSE ALL
            RETURN nil
         ENDIF
         sele Ht
         SEEK MNO
         IF !FOUND()
            BERITA(21,30,' NOMOR TIDAK DITEMUKAN, GANTI NOMOR LAIN ...','GR+/B')
            @21,0
            LOOP
         ELSE
            mtgl:=tglin
            @6,17 say MTGL
            mjum:=JmlHt-Tunai
            IF mjum<=0
               BERITA(21,30,' HUTANG SUDAH LUNAS ........... ','W/R')
               @21,0
               LOOP
            ENDIF
            @7,17 SAY Ht->KODPMSk
            sele pmsk
            SEEK Ht->KODPMSk
            @8,17 SAY pmsk->NAMA
            @9,17 SAY pmsk->ALAMAT
            sele Ht
            @10,21 SAY ht->JmlHt PICT '@E 99,999,999,999.99'
            @11,21 SAY Ht->Tunai PICT '@E 99,999,999,999.99'
            @12,21 SAY Ht->Jmlht-Ht->Tunai PICT '@E 99,999,999,999.99'
            EXIT
         ENDIF
      ELSE
         mno:=0
         @5,17 GET MNO PICT '99999'
         READ
         IF MNO=0
            CLOSE ALL
            RETURN nil
         ENDIF
         sele Put
         SEEK MNO
         IF !FOUND()
            BERITA(21,30,' NOMOR TIDAK DITEMUKAN, GANTI NOMOR LAIN ..','GR+/B')
            @21,0
            LOOP
         ELSE
            mtgl:=tglout
            @6,17 say MTGL
           IF Put->JmlPt-Put->Tunai<=0
               BERITA(21,30,' HUTANG SUDAH LUNAS .....','W/R')
               @21,0
               LOOP
            ENDIF
            @7,17 SAY Put->Kodelgn
            sele lgn
            SEEK Put->Kodelgn
            @8,17 SAY lgn->NAMA
            @9,17 SAY lgn->ALAMAT
            sele Put
            @10,21 SAY Put->JmlPt PICT '@E 99,999,999,999.99'
            @11,21 SAY Put->Tunai PICT '@E 99,999,999,999.99'
            @12,21 SAY Put->JmlPt-Put->Tunai PICT '@E 99,999,999,999.99'
            EXIT
         ENDIF
      ENDIF
   ENDDO
   MTGLBYR:=DATE();MKET:=SPACE(15);MGIRO:=0;MTUNAI:=0
   @13,17 GET MTGLBYR
   @14,17 GET MKET PICT '@!'
   @15,21 GET MGIRO PICT '@Z 99,999,999,999.99'
   @16,21 GET MTUNAI PICT '@Z 99,999,999,999.99'
   READ
   IF LIH=1
      sele Ht
      MSISA:=mjum-Ht->Tunai-(MTUNAI+MGIRO)
      @17,21 SAY MSISA PICT '@E 99,999,999,999.99'
      if Mgiro<>0 .OR. MTUNAI<>0
         sele pmsk
         REPLACE pmsk->TOTALHT WITH pmsk->TOTALHT-(MGIRO+MTUNAI)
         sele Ht
         REPLACE Ht->Tunai WITH Tunai+MGIRO+MTUNAI
         IF MSISA<=0
            REPLACE Ht->STATUS WITH 'L'
         ENDIF
         sele trHT
         APPEND BLANK
         REPLACE TGLBYR WITH MTGLBYR,TGLht WITH MTGL,NOBPB WITH MNO,;
         BANK WITH MKET,GIRO WITH MGIRO,TUNAI WITH MTUNAI
      ENDIF
   ELSE
      sele Put
      MSISA:=Put->JmlPt-Put->Tunai-(MGIRO+MTUNAI)
      @17,21 SAY MSISA PICT '@E 99,999,999,999.99'
      IF MGIRO<>0 .OR. MTUNAI<>0
         sele lgn
         REPLACE lgn->TOTALUT WITH lgn->TOTALUT-(MGIRO+MTUNAI)
         sele Put
         REPLACE Put->Tunai with Tunai+MGIRO+MTUNAI
         IF MSISA<=0
            REPLACE Put->STATUS WITH 'L'
         ENDIF
         sele trPT
         APPEND BLANK
         REPLACE trpt->TGLBYR WITH MTGLBYR,trpt->TGLOUT WITH MTGL,;
         trpt->FAKTUR WITH MNO,trpt->BANK WITH MKET,trpt->GIRO WITH MGIRO,;
         trpt->TUNAI WITH MTUNAI
      ENDIF
   ENDIF
   SET COLOR TO W/R,N*/G
   JAW:=.Y.
   @21,3 SAY ' APAKAH ADA DATA LAGI [Y/N]?'GET JAW PICT 'Y'
   READ
   SETCOLOR("")
   CLEAR
   IF .NOT. JAW
      CLOSE ALL
      RETURN nil
   ENDIF
ENDDO
Return nil