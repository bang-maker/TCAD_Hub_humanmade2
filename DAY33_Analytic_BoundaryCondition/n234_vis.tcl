load_file ./n209_fps.tdr -name geom_n234
create_plot -dataset geom_n234 -name plot_n234
select_plots {plot_n234}

set_plot_prop -plot {plot_n234} -title "Reflect rotation=90 tilt= 15"
set_plot_prop -plot {plot_n234} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

