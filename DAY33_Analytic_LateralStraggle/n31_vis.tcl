load_file ./n30_fps.tdr -name geom_n31
create_plot -dataset geom_n31 -name plot_n31
select_plots {plot_n31}

set_plot_prop -plot {plot_n31} -title "Model= depth.independent lat.stdev=0.2 lat.stdev2=0.4 "
set_plot_prop -plot {plot_n31} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n31 -geom geom_n31 NetActive -show_bands
set_field_prop -plot plot_n31 -geom geom_n31 NetActive -scale asinh 

