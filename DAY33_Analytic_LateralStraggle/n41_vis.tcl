load_file ./n40_fps.tdr -name geom_n41
create_plot -dataset geom_n41 -name plot_n41
select_plots {plot_n41}

set_plot_prop -plot {plot_n41} -title "Model= depth.independent lat.stdev=0.2 lat.stdev2=1.0 "
set_plot_prop -plot {plot_n41} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n41 -geom geom_n41 NetActive -show_bands
set_field_prop -plot plot_n41 -geom geom_n41 NetActive -scale asinh 

