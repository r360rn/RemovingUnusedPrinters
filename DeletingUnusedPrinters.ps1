$LogFolder = "\\fs02ae\DeletedPrinters\"
$UserName = (whoami /upn).split('@')[0]
$Computer = hostname

if (!(Test-Path "$($LogFolder)$($UserName)-$($Computer).csv")){

# Define common variables
    $AllClientPrinters = @()
    $RemovedPrinters = @()
    $Printers = @("\\prn21ae\1B_Black_1536_1",
                  "\\prn21ae\1B_Color_6040-1",
                  "\\prn21ae\DPG_Floor_1B_Color_CP5520_1",
                  "\\prn21ae\DPG_Floor_3A_Color_CP5520_1",
                  "\\prn21ae\INJAZ_Floor_4A_Color_CM6040_1",
                  "\\prn21ae\INJAZ_Floor_4A_Color_CM6040_2",
                  "\\prn21ae\INJAZ_Floor_4B_Color_CM6040_1",
                  "\\prn21ae\INJAZ_Floor_4B_Color_CM6040_2"
                  "\\prn21ae\5C_Black9050_1",
                  "\\prn21ae\5C_Color_6040_1",
                  "\\prn21ae\5C_Color_6040_2",
                  "\\prn21ae\5C_Color_6040_3",
                  "\\prn21ae\DPG_Floor5_Color_CM6040_1",
                  "\\prn21ae\DPG_Floor_5B_Color_CM6040_3")

# Loop for converting printer objects to string
    foreach($prn in (Get-WmiObject -Class Win32_Printer)){$AllClientPrinters += $prn.Name}

#delete printer if printer in hashtable $Printers
    foreach ($Printer in $Printers){
            if ($AllClientPrinters -contains $Printer){
            $RemovedPrinters += $Printer
            rundll32 printui.dll,PrintUIEntry /dn /n $Printer
            }
        }

# Generating CSV and variables for logs
    $Date = get-date -UFormat "%d/%m/%y %R"
    $UserName = (whoami /upn).split('@')[0]
    $Before = $AllClientPrinters
    $After = @()
    foreach($prn in (Get-WmiObject -Class Win32_Printer)){$After += $prn.Name}
    $DeletedPrinters = $RemovedPrinters
    Add-Content -Path "$($LogFolder)$($UserName)-$($Computer).csv" -Value 'Date, Computer, User, Before, After, Deleted Printers'

# Writing logs
    for ($i=0;$i -lt $Before.Length;$i++){
        Add-Content -Path "$($LogFolder)$($UserName)-$($Computer).csv" -Value "$($Date),$($UserName),$($Computer),$($Before[$i]),$($After[$i]),$($DeletedPrinters[$i])"
    }
}