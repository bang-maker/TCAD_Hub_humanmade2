load_file ./n105_fps.tdr -name geom_n106
create_plot -dataset geom_n106 -name plot_n106
select_plots {plot_n106}

set_plot_prop -plot {plot_n106} -title "SliceAngle= 45  Tilt= 45 Rotation= 180 "
set_plot_prop -plot {plot_n106} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n106 -geom geom_n106 -translucency_on

