 
load_file n@node|etch@_post_fps.tdr  -name datasat_pre_n@node@
load_file n@node|etch@_pre_fps.tdr -name datasat_post_n@node@
create_plot -dataset datasat_pre_n@node@ -name plot_pre_n@node@
create_plot -dataset datasat_post_n@node@ -name plot_post_n@node@


set_material_prop {Gas Interface Oxide PolySilicon Silicon} -plot plot_pre_n@node@ -geom datasat_pre_n@node@ -hide_bulk
set_field_prop -plot plot_pre_n@node@ -geom datasat_pre_n@node@ Abs(Velocity-V) -show_bands
set_plot_prop -plot {plot_pre_n@node@} -color_map grayscale

overlay_plots {plot_pre_n@node@ plot_post_n@node@ } -name overlay_plot_n@node@
set_plot_prop -plot {overlay_plot_n@node@} -color_map grayscale
set_field_prop -plot overlay_plot_n@node@ -geom datasat_pre_n@node@ Abs(Velocity-V) -max 0.5 -max_fixed
set_field_prop -plot overlay_plot_n@node@ -geom datasat_pre_n@node@ Abs(Velocity-V) -min -1  -min_fixed
windows_style -style max
set_plot_prop -plot {overlay_plot_n@node@} -hide_legend
set_window_full -on