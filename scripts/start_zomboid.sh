#!/bin/bash

mod_file_list="${HOME}/files/modList"
mods_dir="${HOME}/Zomboid/mods"
mods_temp_dir="${HOME}/modsTemp"
mods_id="108600"

checkMods(){
        echo "Checking mods..."

        while read modId comment; do
                mods+=("$modId")
        done < $mod_file_list

        mkdir -p $mods_temp_dir $mods_dir

        if (( "${#mods[@]}" )); then
                comm="+force_install_dir $mods_temp_dir +login anonymous "
                for m in "${mods[@]}"; do
                        comm+="+workshop_download_item $mods_id $m "
                done
                comm+="+quit"

                echo "Downloading mods..."
                bash steamcmd $comm

                echo "Installing mods..."
                for m in "${mods[@]}"; do
                        for folder in $mods_temp_dir/steamapps/workshop/content/$mods_id/$m/mods/*; do
                                rsync -avui "$folder" "$mods_dir"
                                echo "$folder updated"
                        done
                done
        fi


}

runGame(){
        echo "Running game..."
        export PATH="${HOME}/server/jre64/bin:$PATH"
        export LD_LIBRARY_PATH="${HOME}/server/linux64:${HOME}/server/natives:${HOME}/server:${HOME}/server/jre64/lib/amd64:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ${HOME}/server/ProjectZomboid64 "$@"
}

echo "Checking for updates..."
bash steamcmd +force_install_dir "${HOME}/server" +login anonymous +app_update 380870 +quit

if [[ -f "$mod_file_list" ]]; then
        checkMods
fi

runGame
exit 0
