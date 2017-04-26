# This tmux statusbar config was created by tmuxline.vim
# on 金, 31  7月 2015

set -g status-bg "colour233"
set -g message-command-fg "colour247"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour148"
set -g message-bg "colour236"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour247"
set -g message-command-bg "colour236"
set -g status-attr "none"
set -g pane-border-fg "colour236"
set -g status-left-attr "none"
setw -g window-status-fg "colour231"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour233"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "colour148"
setw -g window-status-separator ""
setw -g window-status-bg "colour233"
set -g status-left "#[fg=colour22,bg=colour148] #S #[fg=colour148,bg=colour233,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] %Y-%m-%d  %H:%M #[fg=colour148,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour22,bg=colour148] #h "
setw -g window-status-format "#[fg=colour231,bg=colour233] #I #[fg=colour231,bg=colour233] #W "
setw -g window-status-current-format "#[fg=colour233,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] #I #[fg=colour247,bg=colour236] #W #[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]"
