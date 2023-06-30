#!/usr/bin/env bash

#### @author: Zhdong
#### @time  ：2023-3-4
#### @input ：Static deformation txt
              #site #lat #lon #e #n #u #sig_e #sig_n #sig_u
#### @output：Horizontal permanent displacements figure of GNSS station


gmt begin coseismic_eq2_hor_nodem jpg,pdf E600

# 绘制底图
gmt set FORMAT_GEO_MAP=ddd:mm:ss
gmt set MAP_FRAME_TYPE = plain
gmt basemap -R33.5/45/35/40.7 -JM8c -Ba2
gmt makecpt -Cgmt/gray -T-2000/20000/100 -Z -Iz -A75
gmt grdimage @earth_relief_15s
gmt coast -S125/197/244 -N1/0.01p,black -W0.01p,black
gmt plot  Turkey_points.txt  -Sc0.01p -W133/133/133 -G133/133/133
gmt plot aftershock.txt  -Sc0.8p -Ggray -W0.1p,80/80/80
gmt plot PB2002_plates.dig.txt -W0.2p,black

#绘制图片要素：震中、形变方向
echo 37.021 37.225 17.5 318 89 -179 7.8 | gmt meca -E255/255/255 -Gblack -CP3p -Sa0.2c -W0.1p

#绘制形变数据
awk '{if (NR>2) {print $3,$2}}' ./static_def_eq1_5min.txt | gmt plot -Sc1p -W0.1p,black -Gblack
awk '{if (NR>2) {print $3,$2,$4*100,$5*100,$7*100,$8*100,0,toupper($1)}}' ./static_def_eq1_5min.txt | gmt velo -Se0.05c/0.68/0 -A0.15c+e+p0.5p,128/29/60 -W0.3p,128/29/60 -G128/29/60

#绘制断层位置


#添加站点名称
awk '{if (NR>2) {print $3,$2,toupper($1)}}' ./static_def_eq1_5min.txt | gmt text -F+f3p,35,black+jTL -D0.08

# 添加图例
gmt inset begin -R0/1/0/1 -JX1c/0.5c -DjBR -F+gwhite+p0.5p
echo 0.15 0.70 '10\2611 cm' | gmt text -F+f5p+jML
echo 0.20 0.35 10 0 1 1 0 | gmt velo -Se0.05c/0.68/0 -A0.15c+e+p0.5p,128/29/60 -G128/29/60 -W0.3p,128/29/60
gmt text -F+f6p+jML -M << EOF
> 0.4 0.60 0.25 2c c
EOF
gmt inset end
gmt end
