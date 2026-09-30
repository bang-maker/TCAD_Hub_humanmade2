load_file ./n31_fps.tdr -name geom_n63
create_plot -dataset geom_n63 -name plot_n63
select_plots {plot_n63}

set_plot_prop -plot {plot_n63} -title "SliceAngle= 0  Tilt= 0 Rotation= 180 "
set_plot_prop -plot {plot_n63} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n63 -geom geom_n63 -translucency_on

