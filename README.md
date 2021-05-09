```
__________        __    __              ____  ___                                         __   
\______   \ _____/  |__/  |_  __________\   \/  /____   ____   ___________ ___.__._______/  |_ 
 |    |  _// __ \   __\   __\/ __ \_  __ \     // __ \ /    \_/ ___\_  __ <   |  |\____ \   __\
 |    |   \  ___/|  |  |  | \  ___/|  | \/     \  ___/|   |  \  \___|  | \/\___  ||  |_> >  |  
 |______  /\___  >__|  |__|  \___  >__| /___/\  \___  >___|  /\___  >__|   / ____||   __/|__|  
        \/     \/                \/           \_/   \/     \/     \/       \/     |__|         
```
# BetterXencrypt
A better version of Xencrypt.Xencrypt it self is a Powershell runtime crypter designed to evade AVs.
cause Xencrypt is not FUD anymore and easily get caught by AMSI,i recode the stub and now it FUD again.
And the original Xencrypt,if you see on the screenshot proof,he's tested on Windows 8,and if i test it on the newest Windows 10,it doesnt FUD,
cause that i want to make it FUD again and make everyone happy :D
## This tool tested on Windows 10 v20H2
# Proof-Of-FUDness (if you dont trust my word)
https://www.virustotal.com/gui/file/427c697e11d476f733aaad9fc2ed9dffd8c8b45d84a772c5179d3134d19ac24d/detection
# Features
-   Bypasses AMSI,Behavior Monitoring,and all modern AVs in use on MetaDefender and VirusTotal
-   Compresses and encrypts powershell scripts
-   Has a minimal and often even negative (thanks to the compression) overhead
-   Multiple types of encryption and compression
-   Randomizes variable names to further obfuscate the decrypter stub
-   Super easy to modify to create your own crypter variant
-   Supports recursive layering (crypter crypting the crypted output), tested up to 500 layers.
-   Supports Import-Module as well as standard running as long as the input script also supported it
-   All features in a single file so you can take it with you anywhere!
# Note
Don't be a script kiddie, I made this GPLv3 so you can make your own modifications. But yeah i'll keep developing this tool,and if you dont want to make your own modifications,its fine anyway.
# Thanks To
-   Me for not dying when creating this tool
-   Xentropy and SecForce for creating the original [Xencrypt](https://github.com/the-xentropy/xencrypt)
-   Ed Wilson AKA Microsoft Scripting Guy for the great Powershell scripting tutorials
-   and the last one is Emeric Nasi for the research on bypassing AV dynamics
# Usage
Its better to run BetterXencrypt script on Linux Powershell,cause i never try it on Windows Powershell.
(Surprised that Linux have Powershell?Take a look at [this](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1))
```
Import-Module ./betterxencrypt.ps1
Invoke-BetterXencrypt -InFile invoke-mimikatz.ps1 -OutFile xenmimi.ps1
```
You will now have an encrypted xenmimi.ps1 file in your current working directory. You can use it in the same way as you would the original script, so in this case:
```
Import-Module ./xenmimi.ps1
Invoke-Mimikatz
```
It also supports recursive layering via the -Iterations flag.
```
Invoke-BetterXencrypt -InFile invoke-mimikatz.ps1 -OutFile xenmimi.ps1 -Iterations 100
```
Warning though, the files can get big and generating the output file can take a very long time depending on the scripts and number of iterations requested.
# To-do List
