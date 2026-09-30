load_file ./n15_fps.tdr -name geom_n56
create_plot -dataset geom_n56 -name plot_n56
select_plots {plot_n56}

set_plot_prop -plot {plot_n56} -title "SliceAngle= -90  Tilt= 45 Rotation= 45 "
set_plot_prop -plot {plot_n56} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n56 -geom geom_n56 -translucency_on

