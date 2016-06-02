

set -g prefix C-a
bind C-a send-prefix
unbind C-b

bind -r h resize-pane -L 5
bind -r l resize-pane -R 5
bind -r k resize-pane -U 5
bind -r j resize-pane -D 5
unbind r
bind r source-file ~/.tmux.conf
