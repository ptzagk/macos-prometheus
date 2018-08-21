#!/bin/sh
prom=/tmp/node_exporter/sensors.prom
echo "# HELP node_sensors_celsius Sensor temperatures" > $prom.$
echo "# TYPE node_sensors_celsius gauge" >> $prom.$
echo "# HELP node_sensors_rpm Sensor fan speeds" >> $prom.$
echo "# TYPE node_sensors_rpm gauge" >> $prom.$
echo "# HELP node_sensors_watts Sensor power consumptions" >> $prom.$
echo "# TYPE node_sensors_watts gauge" >> $prom.$
echo "# HELP node_sensors_joules Sensor energies" >> $prom.$
echo "# TYPE node_sensors_joules gauge" >> $prom.$
echo "# HELP node_sensors_megahertz Sensor frequencies" >> $prom.$
echo "# TYPE node_sensors_megahertz gauge" >> $prom.$

cpu=`/usr/local/bin/istats cpu temp --value-only | xargs`
battery=`/usr/local/bin/istats battery temp --value-only | xargs`
fan1=`/usr/local/bin/istats fan speed --value-only | head -n1 | xargs`
fan2=`/usr/local/bin/istats fan speed --value-only | tail -n1 | xargs`

cpu_core1=`/usr/local/bin/istats scan TC1C --value-only | xargs`
cpu_core2=`/usr/local/bin/istats scan TC2C --value-only | xargs`
cpu_core3=`/usr/local/bin/istats scan TC3C --value-only | xargs`
cpu_core4=`/usr/local/bin/istats scan TC4C --value-only | xargs`

gpu_die=`/usr/local/bin/istats scan TG0D --value-only | xargs`
gpu_proximity=`/usr/local/bin/istats scan TG0P --value-only | xargs`

#Th1H NB/CPU/GPU HeatPipe 1 Proximity:55.88°C
#Ts0P Palm rest L:       35.63°C
#Ts0S Memory Bank Proximity:42.69°C
#TB0T Battery TS_MAX:    39.09°C
#TB1T Battery 1:         37.3°C
#TB2T Battery 2:         39.09°C
#TCGC PECI GPU:          61.0°C
#TCSA PECI SA:           70.0°C
#TCXC PECI CPU:          70.23°C
#TC0E CPU 0 ??:          67.59°C
#TC0F CPU 0 ??:          70.22°C
#TC0P CPU 0 Proximity:   55.06°C
#TM0P Memory Slot Proximity:54.06°C
#TPCD Platform Controller Hub Die:44.0°C
#TW0P AirPort Proximity: 54.19°C

echo "node_sensors_celsius{sensor=\"cpu\"} $cpu" >> $prom.$
echo "node_sensors_celsius{sensor=\"battery\"} $battery" >> $prom.$
echo "node_sensors_celsius{sensor=\"cpu_core1\"} $cpu_core1" >> $prom.$
echo "node_sensors_celsius{sensor=\"cpu_core2\"} $cpu_core2" >> $prom.$
echo "node_sensors_celsius{sensor=\"cpu_core3\"} $cpu_core3" >> $prom.$
echo "node_sensors_celsius{sensor=\"cpu_core4\"} $cpu_core4" >> $prom.$
echo "node_sensors_celsius{sensor=\"gpu_die\"} $gpu_die" >> $prom.$
echo "node_sensors_celsius{sensor=\"gpu_proximity\"} $gpu_proximity" >> $prom.$
echo "node_sensors_rpm{sensor=\"fan1\"} $fan1" >> $prom.$
echo "node_sensors_rpm{sensor=\"fan2\"} $fan2" >> $prom.$

/usr/local/bin/intel_sensors >> $prom.$

mv $prom.$ $prom
