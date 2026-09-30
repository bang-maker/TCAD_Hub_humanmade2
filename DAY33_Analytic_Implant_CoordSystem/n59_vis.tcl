load_file ./n24_fps.tdr -name geom_n59
create_plot -dataset geom_n59 -name plot_n59
select_plots {plot_n59}

set_plot_prop -plot {plot_n59} -title "SliceAngle= -90  Tilt= 45 Rotation= 270 "
set_plot_prop -plot {plot_n59} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n59 -geom geom_n59 -translucency_on

