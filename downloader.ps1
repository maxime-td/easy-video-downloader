# Script PowerShell avec interface CLI simple
# Permet de telecharger des videos Youtube et Twitch

function Show-Menu {
    Clear-Host
    Write-Host "================ OUTIL DE COMMANDE ================"
    Write-Host "1: Full video en MP3"
    Write-Host "2: Full video en MP4"
    Write-Host "3: Video en MP4 avec timecodes"
    Write-Host "Q: Quitter"
    Write-Host "=================================================="
}


function Invoke-CustomCommand {
    param (
        [int]$Choice,               # Choix
        [string]$Url,               # URL de la video
        [string]$StartTime = "",    # Timecode debut
        [string]$EndTime = ""       # Timecode fin
    )

    switch ($Choice) {
        1 {
            Write-Host "Full video en MP3" -ForegroundColor Green
            try {
                Invoke-Expression "yt-dlp -x --audio-format mp3 -o `"C:\Users\Maxime\Downloads\%(title)s.%(ext)s`" $Url"
                Write-Host "Telechargement termine avec succès!" -ForegroundColor Green
            }
            catch {
                Write-Host "Erreur lors du telechargement: $_" -ForegroundColor Red
            }
        }
        2 {
            Write-Host "Full video en MP4" -ForegroundColor Green
            try {
                Invoke-Expression "yt-dlp -f mp4 -o `"C:\Users\Maxime\Downloads\%(title)s.%(ext)s`" $Url"
                Write-Host "Telechargement termine avec succès!" -ForegroundColor Green
            }
            catch {
                Write-Host "Erreur lors du telechargement: $_" -ForegroundColor Red
            }
        }
        3 {
            Write-Host "Video en MP4 avec timecodes" -ForegroundColor Green
            try {
                Invoke-Expression "yt-dlp -f mp4 --download-sections `"*$StartTime-$EndTime`" -o `"C:\Users\Maxime\Downloads\%(title)s.%(ext)s`" $Url"
                Write-Host "Telechargement termine avec succès!" -ForegroundColor Green
            }
            catch {
                Write-Host "Erreur lors du telechargement: $_" -ForegroundColor Red
            }
        }
        default {
            Write-Host "Choix invalide." -ForegroundColor Red
        }
    }
}


# Boucle principale
do {
    Show-Menu
    $choice = Read-Host "Entrez votre choix "
    
    if ($choice -ne "Q" -and $choice -ne "q") { # Si on a "q", on quitte

        try {
            $choiceNum = [int]$choice # Permet de s'assurer d'avoir un int
            if ($choiceNum -ge 1 -and $choiceNum -le 4) { # Ne fonctionne qu'avec les int de 1 à 4

                $url = Read-Host "Entrez l'URL"
                if (-not [string]::IsNullOrWhiteSpace($url)) {
                    
                    if ($choiceNum -eq 4) {
                        $startTime = Read-Host "Entrez le timestamp de debut (format 00:00:00)"
                        $endTime = Read-Host "Entrez le timestamp de fin (format 00:00:00)"
                        Invoke-CustomCommand -Choice $choiceNum -Url $url -StartTime $startTime -EndTime $endTime
                    } else {
                        Invoke-CustomCommand -Choice $choiceNum -Url $url
                    }
                }

                else {
                    Write-Host "URL invalide." -ForegroundColor Red
                }
            }
            else {
                Write-Host "Veuillez entrer un chiffre entre 1 et 4." -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Veuillez entrer un chiffre." -ForegroundColor Red
        }
        
        Write-Host "`nAppuyez sur une touche pour continuer..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($choice -ne "Q" -and $choice -ne "q")