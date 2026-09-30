load_file ./n99_fps.tdr -name geom_n100
create_plot -dataset geom_n100 -name plot_n100
select_plots {plot_n100}

set_plot_prop -plot {plot_n100} -title "SliceAngle= 45  Tilt= 45 Rotation= 0 "
set_plot_prop -plot {plot_n100} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n100 -geom geom_n100 -translucency_on

