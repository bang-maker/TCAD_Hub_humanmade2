load_file ./n37_fps.tdr -name geom_n68
create_plot -dataset geom_n68 -name plot_n68
select_plots {plot_n68}

set_plot_prop -plot {plot_n68} -title "SliceAngle= 0  Tilt= 30 Rotation= 180 "
set_plot_prop -plot {plot_n68} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n68 -geom geom_n68 -translucency_on

