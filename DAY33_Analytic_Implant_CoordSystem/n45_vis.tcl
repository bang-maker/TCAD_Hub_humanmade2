load_file ./n1_fps.tdr -name geom_n45
create_plot -dataset geom_n45 -name plot_n45
select_plots {plot_n45}

set_plot_prop -plot {plot_n45} -title "SliceAngle= -90<sup>o</sup> Tilt= 0<sup>o</sup> Rotation= 0<sup>o</sup>"

