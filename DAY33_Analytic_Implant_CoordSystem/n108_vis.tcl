load_file ./n107_fps.tdr -name geom_n108
create_plot -dataset geom_n108 -name plot_n108
select_plots {plot_n108}

set_plot_prop -plot {plot_n108} -title "SliceAngle= 45  Tilt= 45 Rotation= 270 "
set_plot_prop -plot {plot_n108} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n108 -geom geom_n108 -translucency_on

