load_file ./n34_fps.tdr -name geom_n65
create_plot -dataset geom_n65 -name plot_n65
select_plots {plot_n65}

set_plot_prop -plot {plot_n65} -title "SliceAngle= 0  Tilt= 30 Rotation= 0 "
set_plot_prop -plot {plot_n65} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n65 -geom geom_n65 -translucency_on

