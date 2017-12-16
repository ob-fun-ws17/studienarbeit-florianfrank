# Atemschutzplaner

## 1. Allgemeines

Das Program Atemschutzplaner soll die Verwaltung und Dokumentation von Daten, welche im Atemschutzbetrieb in freiwilligen Feuerwehren auftreten erleichtern. 
Dafür wird eine Weboberfläche bereit gestellt, welche es erlaubt registrierten Benutzern Aktivitäten, wie Übungen, Termine in Atemschutzübungsanlagen, ärztliche Untersuchungen oder Einsätze anzulegen. 
Zudem bietet die Software eine Mitgliederverwaltung, welche es ermöglicht die zuvor angelegen Aktivitäten einzelnen Atemschutzgeräteträgern zuzuweisen, außerdem wird eine Prüfung durchgeführt, ob alle Geräteträger die verpflichtenden Termine wahrgenommen haben.

## 2. Installation und Konfiguration 
Für die Installation der Software wird eine vorhergehende Installation des Haskell Stacks benötigt. 

Die Installationsanleitung ist unter folgenden Link zu finden: 
[Haskell Stack link](https://docs.haskellstack.org/en/stable/README/ "Haskell Stack")

Für die Datenbankanbindung und den Webserver wird das Framework Spock verwendet, dieses mit den Befehlen 
```
  $ cabal update 
  $ cabal install spock
```
installiert. 

Im Projektorder liegt eine Datei  **Atemschutzplaner.cfg** bei. 
```
  Atemschutzplaner.cfg
    db = "Atemschutzterminplaner.db"
    port = 8080
```
In dieser ist der Port, auf welchem der Webserver nachher laufen soll, sowie der Name der Sqlite Datenbank angegeben, diese wird beim Start der Applikation eingelesen und geparst. 

Zum Starten der Applikation muss im Projekt ordner 
```
 $ stack build
 $ stack repl
```
aufgerufen werden. 

Danach kann die Anwendung durch die Eingabe von 
```
 - main 
 ```
gestartet werden. 

Die Website ist Danach unter 
```
  http://localhost:8080
```
erreichbar. 

## 3. Technischer Aufbau

Die Software wurde fast ausschließlich in Haskell geschrieben. Für den Webserver und die Datenbankanbindung wurde das Framework [Spock](https://www.spock.li "Spock") verwendet. Das Design der Website bedient sich an grafischen Elementen von [Material Design](https://material.io/guidelines/ "Google Material Design"). Für die Kommunikation zwischen dem Spock Webserver und den einzelnden HTML Seiten, kommt JavaScript zum Einsatz, welches Daten ein Json Pakete verpackt und sendet, diese werden vom Haskell Server empfangen und geparst. Als Datenbankmanagementsystem wird SQLite3 verwendet.

Der Aufbau der Anwendung bedient sich der klassischen MVC (**M**odel-**V**iew-**C**ontrol- Architektur), d.h. es gibt einen Ordner **src/Web/View** dieser beinhaltet alle für die Benutzerschnittstelle verantwortlichen Haskell Dateien. 
Im Order **src/Control** ist die Logik für die Datenbank, REST-SERVER, etc. untergebracht. 
Die Datentypen, für Login, Mitglieder, Termine, etc finden sich im Ordner **src/Model** wieder. 

Für die Qualitätssicherung ist an dieses Repository ein [Travis.CI](https://travis-ci.org/ob-fun-ws17/studienarbeit-florianfrank/ "Travis.CI") Server angebunden, der bei jedem Commit eine **.travis.yml** datei auswertet und anhand dieser die benötigten Pakete installiert sowie automatisiert Tests durchführt. 
