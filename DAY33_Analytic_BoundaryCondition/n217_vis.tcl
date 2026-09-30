load_file ./n149_fps.tdr -name geom_n217
create_plot -dataset geom_n217 -name plot_n217
select_plots {plot_n217}

set_plot_prop -plot {plot_n217} -title "Extend rotation=90 tilt= -15"
set_plot_prop -plot {plot_n217} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

