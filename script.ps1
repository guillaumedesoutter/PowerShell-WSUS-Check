
Write-Host "==== Debut de la verification ===="
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()



# Recherche des mises à jour disponibles
Write-Host "Lancement des recherches de mises a jour"
$Updates = $UpdateSearcher.Search("IsInstalled=0").Updates
if ($Updates.Count -gt 0) {
    Write-Host "Mises a jour disponibles et en attente d'installation :"
    foreach ($Update in $Updates) {
        Write-Host " - Titre : $($Update.Title)"
        Write-Host "   Id KB : $($Update.KBArticleIDs)"
        Write-Host "   Etat : Pending Install" -ForegroundColor Green
    }
} else {
    Write-Host "Aucune mise à jour en attente d'installation." -ForegroundColor Red
}

# Vérification de l'espace disque C
Write-Host "Verification espace disque C"
$disk = Get-PSDrive -Name C
$minSpaceGB = 8

if ($disk.Free -ge ($minSpaceGB * 1GB)) {
    Write-Host ("Espace libre sur C: {0:N2} Go (suffisant)" -f ($disk.Free / 1GB)) -ForegroundColor Green
} else {
    Write-Host ("Attention : Espace libre sur C: {0:N2} Go (moins de {1} Go requis)" -f ($disk.Free / 1GB, $minSpaceGB)) -ForegroundColor Red
}


Write-Host "Verification des cles de registre WSUS"
$wsusKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$auKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

# Lecture des valeurs spécifiques des clés de registre
if (Test-Path $wsusKey) {
    Write-Host "Cle WSUS ($wsusKey) : OK" -ForegroundColor Green
    $wsusProperties = Get-ItemProperty -Path $wsusKey
    if ($wsusProperties.WUServer -and $wsusProperties.WUStatusServer) {
        Write-Host " - WUServer : $($wsusProperties.WUServer)"
        Write-Host " - WUStatusServer : $($wsusProperties.WUStatusServer)"
    } else {
        Write-Host "Attention : Les valeurs WUServer et/ou WUStatusServer absentes." 
    }
} else {
    Write-Host "Cle $wsusKey introuvable." -ForegroundColor Red
}

if (Test-Path $auKey) {
    Write-Host "`nCle AU ($auKey) : OK" -ForegroundColor Green
} else {
    Write-Host "`nCle $auKey introuvable." -ForegroundColor Red
}

if ($wsusProperties.WUServer) {
    Write-Host "Test de connexion au serveur WSUS ($($wsusProperties.WUServer))"

    # Extraire le serveur et le protocole (http/https)
    $wsusUrl = $wsusProperties.WUServer
    $parsedUrl = $wsusUrl -replace "^https?://", "" 
    $server = $parsedUrl.Split(":")[0]         
    $port = if ($parsedUrl -match ":(\d+)$") { $Matches[1] } else { 8530 } # Extraire le port ou utiliser 8530 par défaut

    # Test de connexion sur le port spécifique
    Write-Host "Connexion a $server sur le port $port..."
    $connectionTest = Test-NetConnection -ComputerName $server -Port $port -WarningAction SilentlyContinue
    if ($connectionTest.TcpTestSucceeded) {
        Write-Host "Connexion reussie au serveur $server sur le port $port." -ForegroundColor Green
    } else {
        Write-Host "Echec de la connexion au serveur $server sur le port $port." -ForegroundColor Red
    }
} else {
    Write-Host "Impossible de tester la connexion au serveur WSUS. Cle ou valeur manquante." -ForegroundColor Red
}

Write-Host "==== Fin de la verification ===="

