load_file ./n13_fps.tdr -name geom_n46
create_plot -dataset geom_n46 -name plot_n46
select_plots {plot_n46}

set_plot_prop -plot {plot_n46} -title "SliceAngle= -90  Tilt= 0 Rotation= 45 "
set_plot_prop -plot {plot_n46} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n46 -geom geom_n46 -translucency_on

