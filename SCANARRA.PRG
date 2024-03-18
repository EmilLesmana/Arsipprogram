    if len(aTmp) > 1
            if nElemen == len(aTmp)
               for i:=1 to len(aTmp)-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      if cTmpData == space(10)
                         ob:up()
                      endif
                      ob:Refreshcurrent()
                      loop
                   endif
               Next i
            else
               for i:=nElemen+1 to len(aTmp)
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i

               for i:=1 to nElemen-1
                   if aScan(aTmp[i],aTmp[nElemen,1],1,1) # 0
                      Berita(19,39,' Barang Dalam Satu Faktur Tidak Boleh Dobel ... ','n/bg')
                      aTmp[nElemen,1]:=cTmpData
                      ob:Refreshcurrent()
                      loop
                   endif
               next i
            endif
         endif