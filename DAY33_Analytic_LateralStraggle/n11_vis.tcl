load_file ./n10_fps.tdr -name geom_n11
create_plot -dataset geom_n11 -name plot_n11
select_plots {plot_n11}

set_plot_prop -plot {plot_n11} -title "Model= depth.independent lat.stdev=0.2 lat.stdev2=0.2 "
set_plot_prop -plot {plot_n11} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n11 -geom geom_n11 NetActive -show_bands
set_field_prop -plot plot_n11 -geom geom_n11 NetActive -scale asinh 

