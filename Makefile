start:
	sudo launchctl start io.prometheus
	sudo launchctl start io.prometheus.node_exporter
	sudo launchctl start io.prometheus.sensors

stop:
	sudo launchctl stop io.prometheus
	sudo launchctl stop io.prometheus.node_exporter
	sudo launchctl stop io.prometheus.sensors

load:
	sudo launchctl load -w /Library/LaunchAgents/io.prometheus.plist
	sudo launchctl load -w /Library/LaunchAgents/io.prometheus.node_exporter.plist
	sudo launchctl load -w /Library/LaunchAgents/io.prometheus.sensors.plist

unload:
	sudo launchctl unload /Library/LaunchAgents/io.prometheus.plist
	sudo launchctl unload /Library/LaunchAgents/io.prometheus.node_exporter.plist
	sudo launchctl unload /Library/LaunchAgents/io.prometheus.sensors.plist

intel_sensors:
	clang -o intel_sensors -framework IntelPowerGadget intel_sensors.c

.PHONY: clean
clean:
	rm -f intel_sensors

install_deps:
	brew install prometheus
	brew install node_exporter
	brew cask install intel-power-gadget
	sudo gem install iStats

uninstall_deps:
	brew uninstall prometheus
	brew uninstall node_exporter
	brew cask uninstall intel-power-gadget
	sudo gem uninstall -xa iStats

install: intel_sensors
	sudo cp intel_sensors /usr/local/bin/
	sudo cp sensors.sh /usr/local/bin/
	sudo cp prometheus.args /usr/local/etc/
	sudo cp node_exporter.args /usr/local/etc/
	sudo cp prometheus.yml /usr/local/etc/
	sudo cp io.prometheus.plist /Library/LaunchAgents/
	sudo cp io.prometheus.node_exporter.plist /Library/LaunchAgents/
	sudo cp io.prometheus.sensors.plist /Library/LaunchAgents/
	sudo mkdir -p /tmp/node_exporter
	sudo chmod 1777 /tmp/node_exporter

uninstall:
	sudo rm -f /usr/local/bin/intel_sensors
	sudo rm -f /usr/local/bin/sensors.sh
	sudo rm -f /usr/local/etc/prometheus.args
	sudo rm -f /usr/local/etc/prometheus.yml
	sudo rm -f /usr/local/etc/node_exporter.args
	sudo rm -f /Library/LaunchAgents/io.prometheus.plist
	sudo rm -f /Library/LaunchAgents/io.prometheus.node_exporter.plist
	sudo rm -f /Library/LaunchAgents/io.prometheus.sensors.plist
	sudo rm -f /tmp/PowerGadgetLog.csv
	sudo rm -f /tmp/prometheus.log
	sudo rm -f /tmp/node_exporter.log
	sudo rm -f /tmp/sensors.log
	sudo rm -rf /tmp/node_exporter/
	sudo rm -rf /tmp/prometheus/
