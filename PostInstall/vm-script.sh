#--- Update
apt-get -qq update
if [[ "$?" -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue accessing network repositories${RESET}" 1>&2
  echo -e " ${YELLOW}[i]${RESET} Are the remote network repositories ${YELLOW}currently being sync'd${RESET}?"
  echo -e " ${YELLOW}[i]${RESET} YOUR local ${YELLOW}network repository information${RESET} (Geo-IP based):"
  exit 1
fi


##### Install kernel headers
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}kernel headers${RESET}"
apt-get -y -qq install make gcc "linux-headers-$(uname -r)" || echo -e ' '${RED}'[!] Issue with apt-get'${RESET} 1>&2
if [[ $? -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" There was an ${RED}issue installing kernel headers${RESET}" 1>&2
  echo -e " ${YELLOW}[i]${RESET} Are you ${YELLOW}USING${RESET} the ${YELLOW}latest kernel${RESET}?"
  echo -e " ${YELLOW}[i]${RESET} ${YELLOW}Reboot your machine${RESET}"
  exit 1
fi


##### (Optional) Check to see if ParrotSec is in a VM. If so, install "Virtual Machine Addons/Tools" for a "better" virtual experiment
if [ -e "/etc/vmware-tools" ]; then
  echo -e "\n "${RED}'[!]'${RESET}" VMware Tools is ${RED}already installed${RESET}. Skipping..." 1>&2
elif (dmidecode | grep -iq vmware); then
  ##### Install virtual machines tools 
   (( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}virtual machine tools${RESET}"
  #--- VM -> Install VMware Tools.
  mkdir -p /mnt/cdrom/
  umount -f /mnt/cdrom 2>/dev/null
  sleep 2s
  mount -o ro /dev/cdrom /mnt/cdrom 2>/dev/null; _mount="$?"   # This will only check the first CD drive (if there are multiple bays)
  sleep 2s
  file=$(find /mnt/cdrom/ -maxdepth 1 -type f -name 'VMwareTools-*.tar.gz' -print -quit)
  ([[ "${_mount}" == 0 && -z "${file}" ]]) && echo -e ' '${RED}'[!]'${RESET}' Incorrect CD/ISO mounted' 1>&2
  if [[ "${_mount}" == 0 && -n "${file}" ]]; then             # If there is a CD in (and its right!), try to install native Guest Additions
    echo -e ' '${YELLOW}'[i]'${RESET}' Patching & using "native VMware tools"'
    apt-get -y -qq install make gcc "linux-headers-$(uname -r)" git sudo || echo -e ' '${RED}'[!] Issue with apt-get'${RESET} 1>&2
    git clone -q https://github.com/rasa/vmware-tools-patches.git /tmp/vmware-tools-patches || echo -e ' '${RED}'[!] Issue with apt-get'${RESET} 1>&2
    cp -f "${file}" /tmp/vmware-tools-patches/downloads/
    pushd /tmp/vmware-tools-patches/ >/dev/null
    bash untar-and-patch-and-compile.sh
    popd >/dev/null
    umount -f /mnt/cdrom 2>/dev/null
    /usr/bin/vmware-user
  else                                                       # The fallback is 'open vm tools' ~ http://open-vm-tools.sourceforge.net/about.php
    echo -e " ${YELLOW}[i]${RESET} VMware Tools CD/ISO isn't mounted"
    echo -e " ${YELLOW}[i]${RESET} Skipping 'Native VMware Tools', switching to 'Open VM Tools'"
    apt-get -y -qq install open-vm-tools open-vm-tools-desktop open-vm-tools-dkms || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
    apt-get -y -qq install make || echo -e ' '${RED}'[!] Issue with apt-get'${RESET}    # nags afterwards
  fi
elif [ -e "/etc/init.d/vboxadd" ]; then
  echo -e "\n "${RED}'[!]'${RESET}" VirtualBox Guest Additions is ${RED}already installed${RESET}. Skipping..." 1>&2
elif (dmidecode | grep -iq virtualbox); then
  ##### (Optional) Installing Virtualbox Guest Additions.  
  echo -e "\n ${GREEN}[+]${RESET} (Optional) Installing ${GREEN}VirtualBox Guest Additions${RESET}"
  #--- Devices -> Install Guest Additions CD image...
  mkdir -p /mnt/cdrom/
  umount -f /mnt/cdrom 2>/dev/null
  sleep 2s
  mount -o ro /dev/cdrom /mnt/cdrom 2>/dev/null; _mount=$?   # Only checks first CD drive (if multiple)
  sleep 2s
  file=/mnt/cdrom/VBoxLinuxAdditions.run
  if [[ "${_mount}" == 0 && -e "${file}" ]]; then
    apt-get -y -qq install make gcc "linux-headers-$(uname -r)" || echo -e ' '${RED}'[!] Issue with apt-get'${RESET} 1>&2
    cp -f "${file}" /tmp/
    chmod -f 0755 /tmp/VBoxLinuxAdditions.run
    /tmp/VBoxLinuxAdditions.run --nox11
    umount -f /mnt/cdrom 2>/dev/null
  #elif [[ "${_mount}" == 0 ]]; then
  else
    echo -e ' '${RED}'[!]'${RESET}' Incorrect CD/ISO mounted. Skipping...' 1>&2
    #apt-get -y -qq install virtualbox-guest-x11
  fi
fi
