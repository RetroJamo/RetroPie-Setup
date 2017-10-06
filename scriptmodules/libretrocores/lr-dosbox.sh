#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-dosbox"
rp_module_desc="DOS emulator - DOSBOX port for libretro"
rp_module_help="ROM Extensions: .bat .com .exe .sh\n\nCopy your DOS games to $romdir/pc"
rp_module_licence="GPL2 https://github.com/libretro/dosbox-libretro/raw/master/COPYING"
rp_module_section="exp"

function sources_lr-dosbox() {
    gitPullOrClone "$md_build" https://github.com/libretro/dosbox-libretro.git
}

function build_lr-dosbox() {
    make clean
    make -j2
    md_ret_require="$md_build/dosbox_libretro.so"
}

function install_lr-dosbox() {
    md_ret_files=(
        'dosbox_libretro.so'
        'README'
    )
}

function configure_lr-fmsx() {
    mkRomDir "pc"
    ensureSystemretroconfig "pc"

    addEmulator 1 "$md_id" "pc" "$md_inst/dosbox_libretro.so"
    addSystem "pc"
}