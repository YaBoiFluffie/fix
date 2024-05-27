#!/bin/bash

# Funktion zum Überprüfen und Beheben der Netzwerkverbindung
function check_and_fix_network() {
    echo "Überprüfe Netzwerkverbindung..."

    # Prüfe, ob das Netzwerk verfügbar ist
    if ping -c 1 google.com &> /dev/null; then
        echo "Netzwerkverbindung ist in Ordnung."
    else
        echo "Netzwerkverbindung ist nicht verfügbar. Versuche, die Netzwerkschnittstelle neu zu starten..."
        sudo systemctl restart networking.service
        if ping -c 1 google.com &> /dev/null; then
            echo "Netzwerkverbindung erfolgreich wiederhergestellt."
        else
            echo "Fehler: Netzwerkverbindung konnte nicht wiederhergestellt werden."
            exit 1
        fi
    fi
}

# Funktion zum Überprüfen und Beheben der DNS-Einstellungen
function check_and_fix_dns() {
    echo "Überprüfe DNS-Einstellungen..."

    # Prüfe, ob der DNS-Server erreichbar ist
    if ! host google.com &> /dev/null; then
        echo "DNS-Server ist nicht erreichbar. Aktualisiere /etc/resolv.conf..."
        echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
        echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf
        if host google.com &> /dev/null; then
            echo "DNS-Einstellungen erfolgreich aktualisiert."
        else
            echo "Fehler: DNS-Einstellungen konnten nicht aktualisiert werden."
            exit 1
        fi
    else
        echo "DNS-Einstellungen sind in Ordnung."
    fi
}

# Funktion zum Aktualisieren des Systems
function update_system() {
    echo "Aktualisiere das System..."
    sudo apt update && sudo apt upgrade -y
    echo "Systemaktualisierung abgeschlossen."
}

# Funktion zum Überprüfen und Beheben defekter Pakete
function check_and_fix_broken_packages() {
    echo "Überprüfe und behebe defekte Pakete..."
    sudo dpkg --configure -a
    sudo apt install -f -y
    echo "Überprüfung und Behebung defekter Pakete abgeschlossen."
}

# Hauptfunktion
function main() {
    check_and_fix_network
    check_and_fix_dns
    update_system
    check_and_fix_broken_packages
    echo "Fehlerbehebung abgeschlossen. Das System sollte nun ohne Probleme laufen."
}

main
