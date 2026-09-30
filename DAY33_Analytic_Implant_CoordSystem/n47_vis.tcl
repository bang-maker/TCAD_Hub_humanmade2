load_file ./n16_fps.tdr -name geom_n47
create_plot -dataset geom_n47 -name plot_n47
select_plots {plot_n47}

set_plot_prop -plot {plot_n47} -title "SliceAngle= -90  Tilt= 0 Rotation= 90 "
set_plot_prop -plot {plot_n47} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n47 -geom geom_n47 -translucency_on

