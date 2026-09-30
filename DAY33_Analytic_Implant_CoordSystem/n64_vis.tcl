load_file ./n32_fps.tdr -name geom_n64
create_plot -dataset geom_n64 -name plot_n64
select_plots {plot_n64}

set_plot_prop -plot {plot_n64} -title "SliceAngle= 0  Tilt= 0 Rotation= 270 "
set_plot_prop -plot {plot_n64} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n64 -geom geom_n64 -translucency_on

