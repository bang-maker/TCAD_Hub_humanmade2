load_file ./n8_fps.tdr -name geom_n55
create_plot -dataset geom_n55 -name plot_n55
select_plots {plot_n55}

set_plot_prop -plot {plot_n55} -title "SliceAngle= -90  Tilt= 45 Rotation= 0 "
set_plot_prop -plot {plot_n55} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n55 -geom geom_n55 -translucency_on

