load_file ./n197_fps.tdr -name geom_n226
create_plot -dataset geom_n226 -name plot_n226
select_plots {plot_n226}

set_plot_prop -plot {plot_n226} -title "Periodic rotation=90 tilt= 15"
set_plot_prop -plot {plot_n226} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

