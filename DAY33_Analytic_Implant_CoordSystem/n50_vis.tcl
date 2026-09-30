load_file ./n6_fps.tdr -name geom_n50
create_plot -dataset geom_n50 -name plot_n50
select_plots {plot_n50}

set_plot_prop -plot {plot_n50} -title "SliceAngle= -90  Tilt= 30 Rotation= 0 "
set_plot_prop -plot {plot_n50} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n50 -geom geom_n50 -translucency_on

