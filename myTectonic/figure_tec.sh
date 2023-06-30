#!/usr/bin/env bash

#### @author: Zhdong
#### @time  ：2023-5-7
#### @input ：history_eq.txt aftershock.txt faults.txt
#### @output：tectonic.pdf

gmt begin Figure_tec png,pdf E600

#设置基本参数
gmt set FORMAT_GEO_MAP = ddd:mm:ss
gmt set MAP_FRAME_TYPE = plain
gmt set MAP_FRAME_PEN = thin

#绘制底图
gmt basemap -JM15c -R33.5/45/35/40.7 -Ba2f1 -BWseN
gmt makecpt -Cgmt/gray -T-2000/20000/100 -Z -Iz -A75 
#gmt grdimage @earth_relief_15s -I+d -t50   #偏灰色图
gmt grdimage @earth_relief_15s -I+d -t75   #偏白色图
#gmt coast -S125/197/244 -N1/0.01p,black -W0.01p,black  #海洋颜色填充为天蓝

#绘制余震、断层(城市名、历史地震)
gmt plot aftershock.txt  -Sc0.07c -Gdarkgray -W0.1p,black
gmt plot Turkey_points.txt  -Sc0.1p -Wblack -Gblack
gmt plot EAFZ.txt  -Sc1p -W153/0/0 -G153/0/0
gmt plot NAF.txt  -Sc1p -Wspringgreen4 -Gspringgreen4
gmt plot SF.txt  -Sc1p -Wblue4 -Gblue4
#gmt text  ./city.txt | -F+f6p,4,black
#gmt plot history.txt -Sc -Ggreen -Wbalck

#绘制震中、震源机制
echo 37.021 37.225 17.5 318 89 -179 7.8 38 37 | gmt meca -E255/255/255 -Gfirebrick4 -CP3p -Sa0.6c -W0.5p
echo 37.203 38.024 13.5 277 78 4 7.5 36.8 38.6 | gmt meca -E255/255/255 -Gblue4 -CP3p -Sa0.6c -W0.5p
echo 37.021 37.225 | gmt plot -Sa0.3 -W0.3p,black -Gyellow
echo 37.203 38.024 | gmt plot -Sa0.3 -W0.3p,black -Gyellow

#绘制GNSS测站位置
awk '{print $3,$2}' ./gps_pos.txt | gmt plot -St0.2c -W0.7p,orangered1 #-Gwhite  #-G127/255/212

#绘制缩略图
gmt inset begin -DjBR+w6c/4c -F+gwhite+p0.5p
 #gmt grdimage @earth_relief_30s -R18/55/29/48 -JM? -Cchina.cpt -I+d  #偏灰色图 #PPT图：1m精度地形图
 gmt coast -R18/55/29/48 -JM? -W0.03p,gray -A 
 gmt plot PB2002_plates.dig.txt -W0.2p,black
 echo 33.5 35 45 40.7 | gmt plot -Sr+s -W0.5p,red,- -A
 echo 37.239 38.089 | gmt plot -Sa0.1 -W0.1p,black -Gred
 echo 37.043 37.288 | gmt plot -Sa0.1 -W0.1p,black -Gred
gmt inset end


gmt end show

