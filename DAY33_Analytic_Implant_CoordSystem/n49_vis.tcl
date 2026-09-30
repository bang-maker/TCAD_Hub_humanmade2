load_file ./n22_fps.tdr -name geom_n49
create_plot -dataset geom_n49 -name plot_n49
select_plots {plot_n49}

set_plot_prop -plot {plot_n49} -title "SliceAngle= -90  Tilt= 0 Rotation= 270 "
set_plot_prop -plot {plot_n49} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n49 -geom geom_n49 -translucency_on

