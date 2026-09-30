load_file ./n94_fps.tdr -name geom_n95
create_plot -dataset geom_n95 -name plot_n95
select_plots {plot_n95}

set_plot_prop -plot {plot_n95} -title "SliceAngle= 45  Tilt= 30 Rotation= 180 "
set_plot_prop -plot {plot_n95} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n95 -geom geom_n95 -translucency_on

