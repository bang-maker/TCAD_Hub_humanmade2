load_file ./n36_fps.tdr -name geom_n67
create_plot -dataset geom_n67 -name plot_n67
select_plots {plot_n67}

set_plot_prop -plot {plot_n67} -title "SliceAngle= 0  Tilt= 30 Rotation= 90 "
set_plot_prop -plot {plot_n67} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n67 -geom geom_n67 -translucency_on

