load_file ./n@node|Implant@_fps.tdr -name geom_n@node@
create_plot -dataset geom_n@node@ -name plot_n@node@
select_plots {plot_n@node@}

set_plot_prop -plot {plot_n@node@} -title "SliceAngle= @SliceAngle@  Tilt= @tilt@ Rotation= @rotation@ "
set_plot_prop -plot {plot_n@node@} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_material_prop {Nitride} -plot plot_n@node@ -geom geom_n@node@ -translucency_on