load_file ./n96_fps.tdr -name geom_n97
create_plot -dataset geom_n97 -name plot_n97
select_plots {plot_n97}

set_plot_prop -plot {plot_n97} -title "SliceAngle= 45  Tilt= 30 Rotation= 270 "
set_plot_prop -plot {plot_n97} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n97 -geom geom_n97 -translucency_on

