load_file ./n18_fps.tdr -name geom_n19
create_plot -dataset geom_n19 -name plot_n19
select_plots {plot_n19}

set_plot_prop -plot {plot_n19} -title "Model= depth.independent lat.stdev=1.0 lat.stdev2=0.2 "
set_plot_prop -plot {plot_n19} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n19 -geom geom_n19 NetActive -show_bands
set_field_prop -plot plot_n19 -geom geom_n19 NetActive -scale asinh 

