load_file ./n17_fps.tdr -name geom_n52
create_plot -dataset geom_n52 -name plot_n52
select_plots {plot_n52}

set_plot_prop -plot {plot_n52} -title "SliceAngle= -90  Tilt= 30 Rotation= 90 "
set_plot_prop -plot {plot_n52} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n52 -geom geom_n52 -translucency_on

