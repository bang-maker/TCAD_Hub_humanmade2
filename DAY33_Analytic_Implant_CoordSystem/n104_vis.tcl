load_file ./n103_fps.tdr -name geom_n104
create_plot -dataset geom_n104 -name plot_n104
select_plots {plot_n104}

set_plot_prop -plot {plot_n104} -title "SliceAngle= 45  Tilt= 45 Rotation= 90 "
set_plot_prop -plot {plot_n104} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n104 -geom geom_n104 -translucency_on

