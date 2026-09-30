load_file ./n43_fps.tdr -name geom_n73
create_plot -dataset geom_n73 -name plot_n73
select_plots {plot_n73}

set_plot_prop -plot {plot_n73} -title "SliceAngle= 0  Tilt= 45 Rotation= 180 "
set_plot_prop -plot {plot_n73} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n73 -geom geom_n73 -translucency_on

