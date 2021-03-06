#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="ags"
rp_module_desc="Adventure Game Studio - Adventure game engine"
rp_module_help="ROM Extension: .exe\n\nCopy your Adventure Game Studio roms to $romdir/ags"
rp_module_licence="OTHER https://raw.githubusercontent.com/adventuregamestudio/ags/master/License.txt"
rp_module_section="opt"
rp_module_flags="!kms"

function depends_ags() {
    getDepends xorg pkg-config libaldmb1-dev libfreetype6-dev libtheora-dev libvorbis-dev libogg-dev liballegro4-dev
}

function sources_ags() {
    gitPullOrClone "$md_build" https://github.com/adventuregamestudio/ags.git
}

function build_ags() {
    make -C Engine clean
    make -C Engine
}

function install_ags() {
    make -C Engine PREFIX="$md_inst" install
}

function configure_ags() {
    mkRomDir "ags"

    # install Eawpatches GUS patch set (see: http://liballeg.org/digmid.html)
    [[ "$md_mode" == "install" ]] && wget -qO- "http://www.eglebbk.dds.nl/program/download/digmid.dat" | bzcat >"$md_inst/bin/patches.dat"

    # copy basic QJOYPAD layout (mappings to mouse buttons,F1,F2,F12,ESC so switching to main menu and quitting will be easier).
    cp -p $md_data/ags.lyt /home/pi/.qjoypad3/
    # copy run script with needed parameters + Qjoypad support
    cp -p $md_data/ags.sh $md_conf_root/ags/

    if isPlatform "x11"; then
        addEmulator 1 "$md_id" "ags" "$md_inst/bin/ags --fullscreen %ROM%" "Adventure Game Studio" ".exe"
    else
        addEmulator 1 "$md_id" "ags" "LD_LIBRARY_PATH=/usr/lib/GLSHIM startx $md_conf_root/ags/ags.sh %ROM%" "Adventure Game Studio" ".exe"
    fi

    addSystem "ags"
}
