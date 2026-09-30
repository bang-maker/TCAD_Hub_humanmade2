load_file ./n38_fps.tdr -name geom_n69
create_plot -dataset geom_n69 -name plot_n69
select_plots {plot_n69}

set_plot_prop -plot {plot_n69} -title "SliceAngle= 0  Tilt= 30 Rotation= 270 "
set_plot_prop -plot {plot_n69} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n69 -geom geom_n69 -translucency_on

