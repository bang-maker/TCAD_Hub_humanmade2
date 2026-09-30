load_file ./n4_fps.tdr -name geom_n8
create_plot -dataset geom_n8 -name plot_n8
select_plots {plot_n8}

set_plot_prop -plot {plot_n8} -title "Model= depth.independent  "
set_plot_prop -plot {plot_n8} -title_font_family times -title_font_factor 1.4 -title_font_color #800000 -title_font_att bold
set_field_prop -plot plot_n8 -geom geom_n8 NetActive -show_bands
set_field_prop -plot plot_n8 -geom geom_n8 NetActive -scale asinh 

