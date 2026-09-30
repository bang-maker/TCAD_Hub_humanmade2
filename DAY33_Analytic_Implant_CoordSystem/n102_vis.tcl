load_file ./n101_fps.tdr -name geom_n102
create_plot -dataset geom_n102 -name plot_n102
select_plots {plot_n102}

set_plot_prop -plot {plot_n102} -title "SliceAngle= 45  Tilt= 45 Rotation= 45 "
set_plot_prop -plot {plot_n102} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n102 -geom geom_n102 -translucency_on

