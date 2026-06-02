#!/usr/bin/env bash
# Regenerate the Liquid Glass droplet app icon (light / dark / tinted) from the
# SVG template, rendering 1024x1024 PNGs into the asset catalog.
set -euo pipefail
cd "$(dirname "$0")"

TMPL="icon.template.svg"
DEST="../LiquidGlassPlayground/LiquidGlassPlayground/Assets.xcassets/AppIcon.appiconset"

# variant: name BG1 BG2 C_TOP C_MID C_BOT RIM CAUSTIC CAUSTIC_OP BODY_OP BG_OP
render() {
  local name=$1 bg1=$2 bg2=$3 ctop=$4 cmid=$5 cbot=$6 rim=$7 caustic=$8 caop=$9 bodyop=${10} bgop=${11}
  local svg="AppIcon-${name}.svg"
  sed -e "s|@BG1@|$bg1|g" -e "s|@BG2@|$bg2|g" \
      -e "s|@C_TOP@|$ctop|g" -e "s|@C_MID@|$cmid|g" -e "s|@C_BOT@|$cbot|g" \
      -e "s|@RIM@|$rim|g" -e "s|@CAUSTIC@|$caustic|g" \
      -e "s|@CAUSTIC_OP@|$caop|g" -e "s|@BODY_OP@|$bodyop|g" -e "s|@BG_OP@|$bgop|g" \
      "$TMPL" > "$svg"
  rsvg-convert -w 1024 -h 1024 "$svg" -o "$DEST/AppIcon-${name}.png"
  echo "rendered AppIcon-${name}.png"
}

#       name    BG1       BG2       C_TOP     C_MID     C_BOT     RIM       CAUSTIC   CAOP  BODYOP BGOP
render  light   "#ffffff" "#d6dbe2" "#ff6b7a" "#ee2436" "#c20e1f" "#ffffff" "#ff3b4d" 0.30  0.80   1
render  dark    "#2a2a2e" "#050507" "#ff7b88" "#f12a3c" "#b00d1c" "#ffd0d5" "#ff2b3d" 0.45  0.85   1
render  tinted  "#000000" "#000000" "#ffffff" "#d2d2d2" "#8c8c8c" "#ffffff" "#9a9a9a" 0.30  1.00   0
