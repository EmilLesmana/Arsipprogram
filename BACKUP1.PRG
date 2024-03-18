Static Function Tin()
***************************************
**USE TRIN INDEX TGLINX.elx,bpbx.elx
use Trin
copy stru to trin1
go to
pack
cari1()
SEEK TGLAWAL
IF .NOT. FOUND()
   RETURN nil
ENDIF
TUJUAN()
IF TDRV=1
    while trin->tglin<=Tglakhir .and. ! eof()
       For i:=1 to fcount()
           aAdd(aHil,trin->(Fieldget(i)))
       next i
       aadd(aTmp,ahil)
       aHil:={}
       Skip
    enddo
    set color to gr
    @8,5 say ' Pemasukan barang ........ '
    LI:=0
    set default to a:
        IF .NOT. FILE('TRIN.DBF')
           set default to c:
           COPY STRU TO a:\TRIN.DBF
           set default to a:
           USE TRIN
           INDEX ON TGLIN TO TGLINX.elx
           INDEX ON NOBPB TO BPBX.elx
        ENDIF
        USE TRIN INDEX TGLINX.elx,BPBX.elx
        For i:=1 to len(aTmp)
            SEEK aTmp[i,1]
            IF FOUND()
               WHILE aTmp[i,1] == TGLIN .AND. aTmp[i,2] == NOBPB .AND.;
                  aTmp[i,5] == KODBRG
                  A->(dbskip())
                  i++
                  if i >= Len(aTmp)
                     Return nil
                  endif
               ENDDO
               LIHAT()
               Dbappend()
               For j:=1 to len(aTmp[i])
                      Fieldput(j,aTmp[i,j])
                          next j
                          A->(dbSKIP())
                       else
                          LIHAT()
                          dbAppend()
                          For j:=1 to len(aTmp[i])
                              Fieldput(j,aTmp[i,j])
                          next j
                          a->(dbskip())
                      ENDIF
                   next i

               ELSE
                  set color to gr
                  @8,5 say ' Pemasukan barang ........ '
                  LI:=0
                  set default to b:
                  IF .NOT. FILE('TRIN.DBF')
                      set default to c:
                     COPY STRU TO b:\TRIN.DBF
                     set default to b:
                     USE TRIN
                     INDEX ON TGLIN TO TGLINX.elx
                     INDEX ON NOBPB TO BPBX.elx
                  ENDIF
                  USE TRIN INDEX TGLINX.elx,BPBX.elx
                  For i:=1 to len(aTmp)
                      SEEK aTmp[i,1]
                      IF FOUND()
                         WHILE aTmp[i,1] == TGLIN .AND. aTmp[i,2] == NOBPB .AND.;
                               aTmp[i,5] == KODBRG
                               A->(dbskip())
                               i++
                               if i >= Len(aTmp)
                                  Return nil
                               endif
                          ENDDO
                          LIHAT()
                          dbappend()
                          For j:=1 to len(aTmp[i])
                              Fieldput(j,aTmp[i,j])
                          next j
                          A->(dbSKIP())
                       else
                          LIHAT()
                          dbappend()
                          For j:=1 to len(aTmp[i])
                              Fieldput(j,aTmp[i,j])
                          next j
                          A->(dbSKIP())
                       else
                          LIHAT()
                          dbappend()
                          For j:=1 to len(aTmp[i])
                              Fieldput(j,aTmp[i,j])
                          next j
                          a->(dbskip())
                       ENDIF
                  next i
            ENDIF
