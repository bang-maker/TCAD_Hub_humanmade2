load_file ./n28_fps.tdr -name geom_n60
create_plot -dataset geom_n60 -name plot_n60
select_plots {plot_n60}

set_plot_prop -plot {plot_n60} -title "SliceAngle= 0  Tilt= 0 Rotation= 0 "
set_plot_prop -plot {plot_n60} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n60 -geom geom_n60 -translucency_on

