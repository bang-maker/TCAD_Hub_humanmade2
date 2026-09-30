load_file ./n152_fps.tdr -name geom_n225
create_plot -dataset geom_n225 -name plot_n225
select_plots {plot_n225}

set_plot_prop -plot {plot_n225} -title "Periodic rotation=90 tilt= -15"
set_plot_prop -plot {plot_n225} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

