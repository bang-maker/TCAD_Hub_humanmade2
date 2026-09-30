load_file ./n23_fps.tdr -name geom_n54
create_plot -dataset geom_n54 -name plot_n54
select_plots {plot_n54}

set_plot_prop -plot {plot_n54} -title "SliceAngle= -90  Tilt= 30 Rotation= 270 "
set_plot_prop -plot {plot_n54} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n54 -geom geom_n54 -translucency_on

