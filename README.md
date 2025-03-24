# Skoleserver

Husk at verdier kan byttes etter egne tiplasninger. Dette gjøres ved å gi variablene nye verdier. Du kan også kopiere og lime spesifikke linjer for å så fjerne variablene og erstatte med egne verdier.

Serveren sitt navn er PN-Skoleserver

IP-en til serveren er 192.168.58.2 og gatewayen 192.168.58.1

DHCP range er 192.168.58.100-192.168.58.200 og subentmask er 255.255.255.0

OPNsense trengs for at DNS skal fungerer

To OU blir laget: Laerer og Elever.

Hvis du skal bruke CSV for å importere Lærere og Elever, ligger det et eksempel på CSV format i denne mappen. Her kan du endre og legge til flere personer.
Du må endre csvPath hvor du har importUser.ps1 sammen med csv filen. Deretter kan du runne scriptet.



