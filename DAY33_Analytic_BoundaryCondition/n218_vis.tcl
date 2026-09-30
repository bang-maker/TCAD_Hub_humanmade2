load_file ./n185_fps.tdr -name geom_n218
create_plot -dataset geom_n218 -name plot_n218
select_plots {plot_n218}

set_plot_prop -plot {plot_n218} -title "Extend rotation=90 tilt= 15"
set_plot_prop -plot {plot_n218} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

