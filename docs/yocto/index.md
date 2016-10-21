# Development Host

**Migration von PTXdist nach Yocto:**

- Docker-Container für Yocto-Buildumgebung
- BSP-Layer für Yocto für Application Carrier Board
    - Kernelconfig und Device Tree aus PTXdist migrieren
    - Bootloader mit RCW integrieren
- BSP-Layer für SYS6000-11-CPU („Driemel-Board“)
- Meta-Layer für Referenzdistri Application Carrier Board
- Meta-Layer für Referenzdistri „portierte Bestandsprodukte“
