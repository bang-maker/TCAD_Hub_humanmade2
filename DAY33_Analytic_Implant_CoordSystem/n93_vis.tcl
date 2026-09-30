load_file ./n92_fps.tdr -name geom_n93
create_plot -dataset geom_n93 -name plot_n93
select_plots {plot_n93}

set_plot_prop -plot {plot_n93} -title "SliceAngle= 45  Tilt= 30 Rotation= 90 "
set_plot_prop -plot {plot_n93} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n93 -geom geom_n93 -translucency_on

