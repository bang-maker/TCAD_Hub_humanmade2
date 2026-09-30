load_file ./n77_fps.tdr -name geom_n78
create_plot -dataset geom_n78 -name plot_n78
select_plots {plot_n78}

set_plot_prop -plot {plot_n78} -title "SliceAngle= 45  Tilt= 0 Rotation= 0 "
set_plot_prop -plot {plot_n78} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n78 -geom geom_n78 -translucency_on

