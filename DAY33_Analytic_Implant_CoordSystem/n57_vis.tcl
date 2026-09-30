load_file ./n18_fps.tdr -name geom_n57
create_plot -dataset geom_n57 -name plot_n57
select_plots {plot_n57}

set_plot_prop -plot {plot_n57} -title "SliceAngle= -90  Tilt= 45 Rotation= 90 "
set_plot_prop -plot {plot_n57} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n57 -geom geom_n57 -translucency_on

