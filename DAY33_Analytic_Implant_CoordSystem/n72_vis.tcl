load_file ./n42_fps.tdr -name geom_n72
create_plot -dataset geom_n72 -name plot_n72
select_plots {plot_n72}

set_plot_prop -plot {plot_n72} -title "SliceAngle= 0  Tilt= 45 Rotation= 90 "
set_plot_prop -plot {plot_n72} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n72 -geom geom_n72 -translucency_on

