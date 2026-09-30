load_file ./n88_fps.tdr -name geom_n89
create_plot -dataset geom_n89 -name plot_n89
select_plots {plot_n89}

set_plot_prop -plot {plot_n89} -title "SliceAngle= 45  Tilt= 30 Rotation= 0 "
set_plot_prop -plot {plot_n89} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n89 -geom geom_n89 -translucency_on

