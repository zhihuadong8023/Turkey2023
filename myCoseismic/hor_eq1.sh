#!/usr/bin/env bash

#### @author: Zhdong
#### @time  ：2023-3-4
#### @input ：Static deformation txt
              #site #lat #lon #e #n #u #sig_e #sig_n #sig_u
#### @output：Horizontal permanent displacements figure of GNSS station


gmt begin coseismic_eq1_hor_nodem png,pdf E600

#设置基本参数
gmt set FORMAT_GEO_MAP=ddd:mm:ss
gmt set MAP_FRAME_TYPE = plain
gmt set MAP_FRAME_PEN = thin
gmt set FONT_ANNOT_PRIMARY 5p
#gmt set MAP_TICK_PEN 0.3p
#gmt set MAP_ANNOT_OFFSET 1p
#gmt set MAP_GRID_PEN 0.1p

#设置比例尺参数
gmt set FONT_LABEL  = 4p,35

#绘制底图
gmt basemap -R33.5/45.5/35/40.7 -JM8c -Ba2f1 -BWSen -Lg42.5/35.3+c35.3+w100+l
gmt makecpt -Cgmt/gray -T-2000/20000/100 -Z -Iz -A75
gmt grdimage @earth_relief_15s
gmt coast -S125/197/244 -N1/0.01p,black -W0.01p,black
gmt plot  Turkey_points.txt  -Sc0.01p -W133/133/133 -G133/133/133

#绘制断层位置
awk '{if (NR>0 && NR<5) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.2p,blue,-
awk '{if (NR>3 && NR<6) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.5p,blue
awk '{if (NR>5 && NR<10) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.2p,blue,-
awk '{if (NR>8 && NR<11) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.5p,blue
awk '{if (NR>10 && NR<15) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.2p,blue,-
awk '{if (NR>13 && NR<16) {print $1,$2}}' ./fault_eq1.txt | gmt plot -W0.5p,blue

#绘制图片要素：震中、形变方向
echo 37.021 37.225 17.5 318 89 -179 7.8 36.8 36 | gmt meca -E255/255/255 -Gblack -CP3p -Sa0.2c -W0.1p
echo 37.021 37.225 | gmt plot -Sa0.22 -W0.05p,black -Gyellow

#绘制形变数据
awk '{if (NR>2) {print $3,$2}}' ./static_def_eq1_5min.txt | gmt plot -Sc1p -W0.1p,black -Gblack
awk '{if (NR>2) {print $3,$2,$4*100,$5*100,$7*100,$8*100,0,toupper($1)}}' ./static_def_eq1_5min.txt | gmt velo -Se0.05c/0.68/0 -A0.15c+e+p0.05p,128/29/60 -W0.05p,128/29/60 -G128/29/60
awk '{if (NR>2) {print $3,$2,$4*100,$5*100,$7i*100,$8*100,0,toupper($1)}}' ./static_def_eq1_5min.txt | gmt velo -Sn0.05c -A0.15c+e+n+p0.7p,128/29/60 -W0.3p,128/29/60 -G128/29/60

#添加站点名称
awk '{if (NR>2) {print $3,$2,toupper($1)}}' ./static_def_eq1_5min.txt | gmt text -F+f3p,35,black+jTL -D0.08

# 添加图例
gmt inset begin -R0/1/0/1 -JX1c/0.5c -DjBR -F+gwhite+p0.2p
echo 0.15 0.70 '10\2611 cm' | gmt text -F+f5p+jML
echo 0.20 0.35 10 0 1 1 0 | gmt velo -Se0.05c/0.68/0 -A0.15c+e+p0.5p,128/29/60 -G128/29/60 -W0.3p,128/29/60
gmt text -F+f6p+jML -M << EOF
> 0.4 0.60 0.25 2c c
EOF
gmt inset end
gmt end show
