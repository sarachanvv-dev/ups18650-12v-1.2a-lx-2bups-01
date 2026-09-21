/*  OpenSCAD 2021.01
      Project name: ups.scad
      Author:       Hotabich
      Copyright:    © Hotabich, 2025

    DESRIPTION:
      ДБЖ для роутера
*/
/*  [ СЛУЖБОВІ ДАНІ ] */
// гладкість кривих
$fn = $preview ? 48 : 120;
// розмір перекриття деталей
eps = 0.01;

use <FRAMES/case.scad>

/* [ РОЗМІРИ МОДУЛЯ ] */
// ширина модуля
ups_width = 42;
// висота модуля
ups_height = 23;
// длинна модуля
ups_length = 88.5;
// висота нижньої частини модуля
ups_height_top = 7.8;
// висота верхньої частини модуля
ups_height_bottom = 21.15;
// диаметр отворів кріплення
ups_hole = 3.5;
// довжина шолдера під АКБ
ups_holder_length = 77.8;
// ширина шолдера під АКБ
upc_holder_width = 20.5;
// розмір отворами кріплення по осі X 
ups_hole_x = 37.5;
// розмір отворами кріплення по осі Y
ups_hole_y = 82.5;

/* [ РОЗМІРИ КОРПУСУ ДБЖ ] */
// ширина корпусу
box_width = 60;
// висота верхньої половинки корпусу
box_height_top = 14.4;
// висота нижньої половинки корпусу
box_height_bottom = 25.4;
// довжина корпусу
box_length = 94;
// товщина стінки корпусу
box_thinckness = 2.4;

// ЗБІРКА ТА ІМПОРТ МОДЕЛЕЙ
//%color("cyan") translate(v=[0, 0, -4]) ups_board();
box_top();
translate(v=[0, 0, -box_height_bottom+box_height_top/2-2.4])
  box_bottom();
for(x=[-24, 24], y=[-27, 27])
  translate([x, y, -35.8])
    rotate([180, 0, 0]) 
      nozka();

module ups_board() { // модуль UPS
  h=1.5;
  xaxes=ups_hole_x/2;
  yaxes=ups_hole_y/2;
  union() {
    
    // pcb board
    difference() {
      cube(size=[ups_width, ups_length, h], center=true);
      for (x=[-xaxes, xaxes], y=[-yaxes, yaxes]) {
        translate(v=[x, y, 0])
          cylinder(h=h+eps, d=ups_hole, center=true);
      }
    }
    
    // type C port
    translate(v=[0, -ups_length/2+1.9, h/2+1.49])
      rotate(a=90, v=[1, 0, 0])
        hull() {
          for(x=[-2.89, 2.89])
            translate(v=[x, 0, 0])
              cylinder(h=6.8, d=2.56, center=true);
    }
    
    // capacitor
    for(y=[-15.25, 15.25, 24.25]) {
      translate(v=[7, y, (ups_height_top+h)/2-eps])
        cylinder(h=ups_height_top, d=6.3, center=true);
    }
    translate(v=[-7, -15.25, (ups_height_top+h)/2-eps])
      cylinder(h=ups_height_top, d=6.3, center=true);
    
    // holders li-ion
    for(x=[-upc_holder_width/2-0.4, upc_holder_width/2+0.4])
      translate(v=[x, 0, -(ups_height_bottom+h)/2+eps]) {
        difference() {
          cube(size=[upc_holder_width, ups_holder_length, ups_height_bottom], center=true);
          translate(v=[0, 0, -0.51])
            cube(size=[upc_holder_width-2, ups_holder_length-1.8, ups_height_bottom-1], center=true);
          for(x=[-upc_holder_width/2+0.5, upc_holder_width/2-0.5]) {
            translate(v=[x, 0, -ups_height_top])
              cube(size=[1.01, ups_holder_length-1.8, 6], center=true);
            translate(v=[x, 0, -ups_height_top/2])
              cube(size=[1.01, ups_holder_length/1.3, 5], center=true);
            translate(v=[x, 0, 0.6])
              cube(size=[1.01, ups_holder_length/2, 4.2], center=true);
        }
      }
    }
  }
}
//
module vent_hole() { // вентиляційні отвори
      for(x=[-20:10:20], y=[-36:6:36]) {
        translate(v=[x, y, 0])
          cylinder(h=box_thinckness+eps*2, d=4, center=true, $fn=6);
      }
      for(x=[-15:10:15], y=[-33:6:33]) {
        translate(v=[x, y, 0])
          cylinder(h=box_thinckness+eps*2, d=4, center=true, $fn=6);
      }
}
//
module cable_output() { // отвір під кабель
  translate(v=[0, 0, 0]) {
    rotate(a=90, v=[1, 0, 0]) {
      hull() {
        for(x=[-0.8, 0.8]) {
          translate(v=[x, 0, 0])
            cylinder(h=box_thinckness+eps, d=1.6, center=true);
        }
      }
    }
  }
}
//
module box_top() { // верхня половинка корпусу
  xaxes=ups_hole_x/2;
  yaxes=ups_hole_y/2;

  union() {
    difference() {
      
      // box
      topCase(size=[box_width, box_length, box_height_top], thickness=box_thinckness, radius=1, center=true, sideonly=false);
      
      // port type C
      translate(v=[0, -(box_length-box_thinckness)/2, -1.75])
        rotate(a=90, v=[1, 0, 0]) {
          hull() for(x=[-2.45, 2.45])
            translate(v=[x, 0, 0])
              cylinder(h=box_thinckness+eps, d=3.5, center=true);
          hull() for(x=[-4.1, 4.1])
            translate(v=[x, 0, box_thinckness/4])
              cylinder(h=box_thinckness/2+eps, d=6, center=true);;
      }
      
      // cable output
      translate(v=[0, (box_length-box_thinckness)/2, -box_height_top/2])
        cable_output();
      // ventilation holes
      translate(v=[0, 0, (box_height_top-box_thinckness-eps)/2])
        vent_hole();
    }
    
    // PCB mounting rack
    for(i=[0, 1]) mirror(v=[0, i, 0]) {
      for(x=[-xaxes, xaxes]) {
        translate(v=[x, -yaxes-0.1, 1.75])
          fastening(length=6.5, height=10, thickness=2.2, diameter=1.8, rounding=0, side=0);
      }
    }
    
    // rack for fastening the body halves
    for(i=[0, 1]) mirror(v=[i, 0, 0]) {
      for(y=[-yaxes+14.3, yaxes-14.3]) {
        translate(v=[xaxes+5.7, y, -0.5])
          rotate(a=90, v=[0, 0, 1])
            fastening(length=6.5, height=11, thickness=1.5, diameter=3.8, rounding=0, side=0);
      }
    }
  }
}
//
module box_bottom() { // нижня половинка корпусу
  xaxes=ups_hole_x/2;
  yaxes=ups_hole_y/2;

  difference() {
    union() {
      bottomCase(size=[box_width, box_length, box_height_bottom], thickness=box_thinckness, radius=1, center=true, sideonly=false);
      
      // rack for fastening the body halves
      for(i=[0, 1]) mirror(v=[i, 0, 0]) {
        for(y=[-yaxes+14.3, yaxes-14.3]) {
          translate(v=[xaxes+5.7, y, 0])
            rotate(a=90, v=[0, 0, 1])
              fastening(length=6.5, height=box_height_bottom, thickness=1.2, diameter=3, rounding=0, side=0);
        }
      }
    }
    
    // ventilation holes
    translate(v=[0, 0, -(box_height_bottom-box_thinckness-eps)/2]) vent_hole();
    
    // отвір під головку гвинта
    for(x=[-xaxes-5.3, xaxes+5.3], y=[-yaxes+14.3, yaxes-14.3]) {
      translate(v=[x, y, -(box_height_bottom-box_thinckness)/2-0.5]) {
        *cylinder(h=1.5, d=6, center=true);
        cylinder(h=5, d=3, center=true);
      }
    }
    
    // cable output
    translate(v=[0, (box_length-box_thinckness)/2, box_height_bottom/2]) cable_output();
  }
}
//
module nozka() { // ніжка
  difference() {
    cylinder(h=4, d1=10, d2=8.9, center=true);
    cylinder(h=4+eps, d=3, center=true);
    translate(v=[0, 0, 0.6])
      cylinder(h=3, d=6.5, center=true);
  }
}