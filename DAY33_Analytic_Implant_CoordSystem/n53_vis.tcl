load_file ./n20_fps.tdr -name geom_n53
create_plot -dataset geom_n53 -name plot_n53
select_plots {plot_n53}

set_plot_prop -plot {plot_n53} -title "SliceAngle= -90  Tilt= 30 Rotation= 180 "
set_plot_prop -plot {plot_n53} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n53 -geom geom_n53 -translucency_on

