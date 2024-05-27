#!/bin/bash

# Funktion zum Überprüfen und Beheben der Netzwerkverbindung
function check_network() {
    echo "Überprüfe Netzwerkverbindung..."

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
function check_dns() {
    echo "Überprüfe DNS-Einstellungen..."

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

# Funktion zum Bereinigen des apt-Caches
function clean_apt_cache() {
    echo "Bereinige apt-Cache..."
    sudo apt clean
    sudo apt autoclean
    echo "Bereinigung des apt-Caches abgeschlossen."
}

# Funktion zum Beheben defekter Pakete
function fix_broken_packages() {
    echo "Behebe defekte Pakete..."
    sudo dpkg --configure -a
    sudo apt install -f -y
    echo "Behebung defekter Pakete abgeschlossen."
}

# Funktion zum Aktualisieren des Systems
function update_system() {
    echo "Aktualisiere das System..."
    sudo apt update
    sudo apt upgrade -y
    echo "Systemaktualisierung abgeschlossen."
}

# Funktion zum Überprüfen und Beheben von Paketquellenproblemen
function check_sources_list() {
    echo "Überprüfe Paketquellenliste..."

    if grep -q "raspbian.raspberrypi.org" /etc/apt/sources.list; then
        echo "Paketquellenliste ist in Ordnung."
    else
        echo "Paketquellenliste scheint nicht korrekt zu sein. Versuche, die Standardquellenliste wiederherzustellen..."
        echo "deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi" | sudo tee /etc/apt/sources.list
        sudo apt update
    fi
}

# Hauptfunktion
function main() {
    check_network
    check_dns
    clean_apt_cache
    fix_broken_packages
    check_sources_list
    update_system
    echo "Fehlerbehebung für apt abgeschlossen. Das System sollte nun ohne Probleme laufen."
}

main
