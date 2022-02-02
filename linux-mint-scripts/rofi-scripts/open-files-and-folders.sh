var=$(fd . $HOME | rofi -dmenu -p "OPEN_FILES_OR_FOLDERS")

xdg-open $var
