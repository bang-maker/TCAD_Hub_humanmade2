load_file ./n41_fps.tdr -name geom_n71
create_plot -dataset geom_n71 -name plot_n71
select_plots {plot_n71}

set_plot_prop -plot {plot_n71} -title "SliceAngle= 0  Tilt= 45 Rotation= 45 "
set_plot_prop -plot {plot_n71} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n71 -geom geom_n71 -translucency_on

