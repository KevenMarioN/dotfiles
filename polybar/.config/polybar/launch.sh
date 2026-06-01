#!/usr/bin/env bash

# Termine as instâncias de barra já rodando
killall -q polybar

# Aguarde até que os processos sejam encerrados
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=LVDS-1 polybar example --reload 2>&1 | tee -a /tmp/polybar.log &
echo "Polybar iniciado no monitor: LVDS-1"
MONITOR=HDMI-1 polybar example --reload 2>&1 | tee -a /tmp/polybar.log &
echo "Polybar iniciado no monitor: HDMI-1"

disown
