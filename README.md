# Atemschutzplaner

## 1. Allgemeines

Das Program Atemschutzplaner soll die Verwaltung und Dokumentation von Daten, welche im Atemschutzbetrieb in freiwilligen Feuerwehren auftreten erleichtern. 
Es wird eine Weboberfläche bereit gestellt, welche es erlaubt registrierten Benutzern, Aktivitäten, wie Übungen, Termine in Atemschutzübungsanlagen, ärztliche Untersuchungen oder Einsätze anzulegen. 
Diese können den Mitgliedern, welche in der Mitgliederverwaltung des Programms angelegt wurden hinzugefügt werden. 
Das Programm 'Atemschutzterminplaner' bietet zudem ein Dashboard auf der Startseite, welches einen schnellen Überblick über die Anzahl einsatzfähiger Geräteträger, sowie die Anzahl Mitglieder insgesamt bietet.
Genauere Informationen sind auf der [Webseite](https://ob-fun-ws17.github.io/studienarbeit-florianfrank/index.html "Projekt Webseite") des Projektes zu finden.

## 2. Installation und Konfiguration 
Für die Installation der Software wird eine vorhergehende Installation des Haskell Stacks benötigt. 

Die Installationsanleitung ist unter folgenden Link zu finden: 
[Haskell Stack link](https://docs.haskellstack.org/en/stable/README/ "Haskell Stack")

Im Projektorder liegt eine Datei  **Atemschutzplaner.cfg** bei. 
```
  Atemschutzplaner.cfg
    db = "Atemschutzterminplaner.db"
    port = 8080
```
In dieser ist der Port, auf welchem der Webserver nachher laufen soll, sowie der Name der Sqlite Datenbank angegeben, diese wird beim Start der Applikation eingelesen und geparst. 

Zum Starten der Applikation muss im Projekt ordner 
```
 $ stack exec Atemschutzterminplaner-exe
```
aufgerufen werden. 

Die Website ist Danach unter 
```
  http://localhost:8080
```
erreichbar. 

## 3. Technischer Aufbau

Die Software wurde fast ausschließlich in Haskell geschrieben. Für den Webserver und die Datenbankanbindung wurde das Framework [Spock](https://www.spock.li "Spock") verwendet. Das Design der Website bedient sich an grafischen Elementen von [Material Design](https://material.io/guidelines/ "Google Material Design"). Für die Kommunikation zwischen dem Spock Webserver und den einzelnden HTML Seiten, kommt JavaScript zum Einsatz, mit Hilfe dieser Programmiersprache werden die verschiedenen Eingabefelder ausgelesen und als Json Pakete verpackt und sendet, diese werden vom Haskell Server empfangen und geparst. Als Datenbankmanagementsystem wird SQLite3 verwendet.

Der Aufbau der Anwendung bedient sich der klassischen MVC (**M**odel-**V**iew-**C**ontrol- Architektur), d.h. es gibt einen Ordner **src/Web/View** dieser beinhaltet alle für die Benutzerschnittstelle verantwortlichen Haskell Dateien. 
Im Order **src/Control** ist die Logik für die Datenbank, REST-SERVER, etc. untergebracht. 
Die Datentypen, für Login, Mitglieder, Termine, etc finden sich im Ordner **src/Model** wieder. 

Für die Qualitätssicherung ist an dieses Repository ein [Travis.CI](https://travis-ci.org/ob-fun-ws17/studienarbeit-florianfrank/ "Travis.CI") Server angebunden, der bei jedem Commit eine **.travis.yml** datei auswertet und anhand dieser die benötigten Pakete installiert sowie automatisiert Tests durchführt. 

## 4. Automatisiertes Testen
Um eine hohe Softwarequalität sicherzustellen werden automatisierte Tests durchgeführt. Hierfür werden JSON Testpakete erstellt, welche an den Server gesandt werden und somit die Kommunikation mit einem User simulieren. Zudem wird die korrektheit diverser Konvertierungsfunktionen sichergestellt. 

**Aktueller Status (Branch Master)**


[![Build Status](https://travis-ci.org/ob-fun-ws17/studienarbeit-florianfrank.svg?branch=master)](https://travis-ci.org/ob-fun-ws17/studienarbeit-florianfrank)
