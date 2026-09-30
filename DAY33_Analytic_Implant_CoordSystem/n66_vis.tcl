load_file ./n35_fps.tdr -name geom_n66
create_plot -dataset geom_n66 -name plot_n66
select_plots {plot_n66}

set_plot_prop -plot {plot_n66} -title "SliceAngle= 0  Tilt= 30 Rotation= 45 "
set_plot_prop -plot {plot_n66} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n66 -geom geom_n66 -translucency_on

