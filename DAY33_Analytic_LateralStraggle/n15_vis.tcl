load_file ./n14_fps.tdr -name geom_n15
create_plot -dataset geom_n15 -name plot_n15
select_plots {plot_n15}

set_plot_prop -plot {plot_n15} -title "Model= depth.independent lat.stdev=0.4 lat.stdev2=0.2 "
set_plot_prop -plot {plot_n15} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n15 -geom geom_n15 NetActive -show_bands
set_field_prop -plot plot_n15 -geom geom_n15 NetActive -scale asinh 

