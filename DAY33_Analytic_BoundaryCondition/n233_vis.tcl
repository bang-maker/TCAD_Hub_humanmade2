load_file ./n155_fps.tdr -name geom_n233
create_plot -dataset geom_n233 -name plot_n233
select_plots {plot_n233}

set_plot_prop -plot {plot_n233} -title "Reflect rotation=90 tilt= -15"
set_plot_prop -plot {plot_n233} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
 

