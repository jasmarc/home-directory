fish_add_path ~/bin
# ~/.local/bin LAST: herdr lives here on the Cloud Desktop; last so it cannot shadow pip3/pytest/kiro-cli
test -d ~/.local/bin; and fish_add_path --append --path ~/.local/bin
