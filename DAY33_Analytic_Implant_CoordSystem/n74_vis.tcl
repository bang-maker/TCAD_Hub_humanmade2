load_file ./n44_fps.tdr -name geom_n74
create_plot -dataset geom_n74 -name plot_n74
select_plots {plot_n74}

set_plot_prop -plot {plot_n74} -title "SliceAngle= 0  Tilt= 45 Rotation= 270 "
set_plot_prop -plot {plot_n74} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n74 -geom geom_n74 -translucency_on

