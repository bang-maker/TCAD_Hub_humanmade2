load_file ./n19_fps.tdr -name geom_n48
create_plot -dataset geom_n48 -name plot_n48
select_plots {plot_n48}

set_plot_prop -plot {plot_n48} -title "SliceAngle= -90  Tilt= 0 Rotation= 180 "
set_plot_prop -plot {plot_n48} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n48 -geom geom_n48 -translucency_on

