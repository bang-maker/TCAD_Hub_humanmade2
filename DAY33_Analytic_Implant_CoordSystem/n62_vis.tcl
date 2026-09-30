load_file ./n30_fps.tdr -name geom_n62
create_plot -dataset geom_n62 -name plot_n62
select_plots {plot_n62}

set_plot_prop -plot {plot_n62} -title "SliceAngle= 0  Tilt= 0 Rotation= 90 "
set_plot_prop -plot {plot_n62} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n62 -geom geom_n62 -translucency_on

