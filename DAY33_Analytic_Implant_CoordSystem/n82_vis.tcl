load_file ./n81_fps.tdr -name geom_n82
create_plot -dataset geom_n82 -name plot_n82
select_plots {plot_n82}

set_plot_prop -plot {plot_n82} -title "SliceAngle= 45  Tilt= 0 Rotation= 90 "
set_plot_prop -plot {plot_n82} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n82 -geom geom_n82 -translucency_on

