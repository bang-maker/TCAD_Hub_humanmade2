load_file ./n90_fps.tdr -name geom_n91
create_plot -dataset geom_n91 -name plot_n91
select_plots {plot_n91}

set_plot_prop -plot {plot_n91} -title "SliceAngle= 45  Tilt= 30 Rotation= 45 "
set_plot_prop -plot {plot_n91} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n91 -geom geom_n91 -translucency_on

