load_file ./n21_fps.tdr -name geom_n58
create_plot -dataset geom_n58 -name plot_n58
select_plots {plot_n58}

set_plot_prop -plot {plot_n58} -title "SliceAngle= -90  Tilt= 45 Rotation= 180 "
set_plot_prop -plot {plot_n58} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n58 -geom geom_n58 -translucency_on

