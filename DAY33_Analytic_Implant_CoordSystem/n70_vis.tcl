load_file ./n40_fps.tdr -name geom_n70
create_plot -dataset geom_n70 -name plot_n70
select_plots {plot_n70}

set_plot_prop -plot {plot_n70} -title "SliceAngle= 0  Tilt= 45 Rotation= 0 "
set_plot_prop -plot {plot_n70} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n70 -geom geom_n70 -translucency_on

