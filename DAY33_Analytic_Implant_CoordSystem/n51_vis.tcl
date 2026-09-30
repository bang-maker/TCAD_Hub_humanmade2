load_file ./n14_fps.tdr -name geom_n51
create_plot -dataset geom_n51 -name plot_n51
select_plots {plot_n51}

set_plot_prop -plot {plot_n51} -title "SliceAngle= -90  Tilt= 30 Rotation= 45 "
set_plot_prop -plot {plot_n51} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n51 -geom geom_n51 -translucency_on

