# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Power nets
# Set the power and ground nets
set ::power_nets [getenv VDD_PIN]
set ::ground_nets [getenv GND_PIN]

# Specify the PDN grid
pdngen::specify_grid stdcell {
    name grid
    rails {
        met1 {width 0.48 pitch $::env(PLACE_SITE_HEIGHT) offset 0}
    }
    straps {
        met4 {width 1.6 pitch $::env(FP_PDN_VPITCH) offset $::env(FP_PDN_VOFFSET)}
    }
    connect {{met1 met4}}
}

# Set the halo size
set ::halo 0

# Define the metal layer for rails
set ::rails_mlayer "met1"

# Specify the starting rails for POWER or GROUND
set ::rails_start_with "POWER"
set ::stripes_start_with "POWER"

