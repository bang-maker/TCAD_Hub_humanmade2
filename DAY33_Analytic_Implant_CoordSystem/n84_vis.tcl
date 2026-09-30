load_file ./n83_fps.tdr -name geom_n84
create_plot -dataset geom_n84 -name plot_n84
select_plots {plot_n84}

set_plot_prop -plot {plot_n84} -title "SliceAngle= 45  Tilt= 0 Rotation= 180 "
set_plot_prop -plot {plot_n84} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n84 -geom geom_n84 -translucency_on

