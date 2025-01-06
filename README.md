# PowerShell-WSUS-Check
# Script de Vérification des Mises à Jour et de l'Espace Disque Windows

## Description

Ce script PowerShell effectue les vérifications suivantes sur un poste Windows :

1. **Vérification des mises à jour Windows :**
   - Recherche des mises à jour disponibles.
   - Affiche les détails des mises à jour en attente d'installation.

2. **Vérification de l'espace disque :**
   - Vérifie l'espace libre sur le disque C.
   - Alerte si l'espace est inférieur au seuil spécifié (par défaut : 8 Go).

3. **Vérification de la configuration WSUS :**
   - Vérifie l'existence des clés de registre WSUS.
   - Affiche les informations du serveur WSUS si configuré.


## Prérequis

- Système d'exploitation Windows
- PowerShell (Version 5.1 ou plus récent)
- Privilèges administratifs pour les tests de registre et de réseau

## Personnalisation

- **Seuil d'espace disque :**
  - Modifier la variable `$minSpaceGB` pour ajuster le seuil de l'espace disque.

## Exemple de Sortie
```plaintext
==== Début de la vérification ====
Lancement des recherches de mises à jour
Mises à jour disponibles et en attente d'installation :
 - Titre : Security Update KB123456
   Id KB : 123456
   État : En attente d'installation
Vérification espace disque C
Espace libre sur C: 50.00 Go (suffisant)
Vérification des clés de registre WSUS
Clé WSUS : OK
 - WUServer : http://wsusserver
Test de connexion au serveur WSUS : Connexion réussie.
==== Fin de la vérification ====
```

## Licence

Ce projet est sous licence MIT.

## Auteur

- Guillaume Desoutter
- Contact : g.desoutter@gmail.com
