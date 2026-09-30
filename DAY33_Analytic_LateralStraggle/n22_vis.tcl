load_file ./n21_fps.tdr -name geom_n22
create_plot -dataset geom_n22 -name plot_n22
select_plots {plot_n22}

set_plot_prop -plot {plot_n22} -title "Model= depth.dependent lat.stdev=Default lat.stdev2=Default "
set_plot_prop -plot {plot_n22} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n22 -geom geom_n22 NetActive -show_bands
set_field_prop -plot plot_n22 -geom geom_n22 NetActive -scale asinh 

