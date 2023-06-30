#!/usr/bin/env bash

#### @author: Zhdong
#### @time  ：2023-5-7
#### @input ：history_eq.txt aftershock.txt faults.txt
#### @output：tectonic.pdf

gmt begin turkey png,pdf
topodata=@earth_relief_15s.grd

#设置
gmt set FORMAT_GEO_MAP = ddd:mm:ss
#gmt set MAP_FRAME_TYPE = plain
gmt set MAP_FRAME_PEN = thin
gmt set FONT_ANNOT_PRIMARY 7p

#绘制底图
R=34.9/41.5/35.9/40.7
J=M15c
gmt basemap -JM15c -R34.9/41.5/35.9/40.7 -Ba1 -BWseN
gmt coast -N1/0.01p,black -W0.01p,black

#高程数据
gmt grdcut $topodata -R$R -GcutTopo.grd
gmt grdgradient cutTopo.grd -Ne0.3 -A30 -GcutTopo_i.grd
gmt grdimage cutTopo.grd -R$R -J$J -IcutTopo_i.grd -Cchina.cpt

gmt coast -S125/197/244 -N1/0.01p,black -W0.01p,black

#绘制地震相关要素
gmt plot aftershock.txt  -Sc0.08c -Ggray -W0.1p,black
gmt plot  Turkey_points.txt  -Sc2 -Wblack -Gblack
#gmt plot history.txt -Sc -Ggreen -Wbalck

echo 37.021 37.225 17.5 318 89 -179 7.8 38 37 | gmt meca -E255/255/255 -Gfirebrick4 -CP3p -Sa0.8c -W0.5p
echo 37.203 38.024 13.5 277 78 4 7.5 36.8 38.6 | gmt meca -E255/255/255 -Gfirebrick4 -CP3p -Sa0.8c -W0.5p

awk '{print $3,$2}' ./gps_pos.txt | gmt plot -St0.3c -W0.3p -G125/197/245

echo 37.021 37.225 | gmt plot -Sa0.5 -W0.3p,black -Gyellow
echo 37.203 38.024 | gmt plot -Sa0.5 -W0.3p,black -Gyellow

gmt inset begin -DjBR+w7c/4.1c+o0.1c -F+gwhite+p1p
# R2=22/52/30/44
# J2=M?
# gmt basemap -R22/52/30/44 -JM? 
# gmt grdcut $topodata -R$R2 -GcutTopo.grd
# gmt grdgradient cutTopo.grd -Ne0.1 -A10 -GcutTopo_i.grd
# gmt grdimage cutTopo.grd -R$R2 -J$J2 -IcutTopo_i.grd -Cchina.cpt
 #gmt makecpt -Cgmt/etopo1
  gmt grdimage @earth_relief_01m -R22/52/30/44 -JM? -Cglobe -I+d
  echo 34.9 35.9 41.5 40.7 | gmt plot -Sr+s -W0.5p,red
 # gmt coast -R22/52/30/44 -JM? -W0.01p,gray -A -N1/0.01p,gray -S158/187/218
  gmt plot PB2002_plates.dig.txt -W0.5p,black
 echo 37.239 38.089 | gmt plot -Sa0.2 -W0.1p,black -Gwhite
 echo 37.043 37.288 | gmt plot -Sa0.2 -W0.1p,black -Gwhite
gmt inset end

gmt end

