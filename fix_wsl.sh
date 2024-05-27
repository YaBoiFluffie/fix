#!/bin/bash

# Funktion zum Beenden von WSL
function shutdown_wsl() {
    echo "Beende WSL..."
    wsl --shutdown
}

# Funktion zum Zurücksetzen der Netzwerkadapter
function reset_network() {
    echo "Setze Netzwerkadapter zurück..."
    netsh winsock reset
    netsh int ip reset
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
}

# Funktion zum Konfigurieren der WSL-DNS-Einstellungen
function configure_wsl_dns() {
    echo "Konfiguriere WSL DNS-Einstellungen..."
    wsl -d <your_distribution_name> -- bash -c "echo '[network]' | sudo tee /etc/wsl.conf"
    wsl -d <your_distribution_name> -- bash -c "echo 'generateResolvConf = false' | sudo tee -a /etc/wsl.conf"
    wsl -d <your_distribution_name> -- bash -c "echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf"
    wsl -d <your_distribution_name> -- bash -c "echo 'nameserver 8.8.4.4' | sudo tee -a /etc/resolv.conf"
}

# Funktion zum Aktualisieren von WSL
function update_wsl() {
    echo "Aktualisiere WSL..."
    wsl --update
}

# Funktion zum Reparieren von WSL
function repair_wsl() {
    echo "Repariere WSL..."
    dism.exe /online /cleanup-image /restorehealth
    sfc /scannow
}

# Funktion zum Neuinstallieren von WSL
#function reinstall_wsl() {
#    echo "Deinstalliere und installiere WSL neu..."
#    dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux
#    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux
#}

# Hauptfunktion
function main() {
    shutdown_wsl
    reset_network
    configure_wsl_dns
    update_wsl
    repair_wsl
    reinstall_wsl
    echo "Fehlerbehebung abgeschlossen. Bitte überprüfen Sie, ob das Problem behoben ist."
}

main
