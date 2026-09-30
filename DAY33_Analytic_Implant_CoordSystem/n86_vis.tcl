load_file ./n85_fps.tdr -name geom_n86
create_plot -dataset geom_n86 -name plot_n86
select_plots {plot_n86}

set_plot_prop -plot {plot_n86} -title "SliceAngle= 45  Tilt= 0 Rotation= 270 "
set_plot_prop -plot {plot_n86} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n86 -geom geom_n86 -translucency_on

