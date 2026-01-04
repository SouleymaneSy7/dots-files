# Arch Linux Installation and Dual-Boot Configuration Guide for MBR/Legacy BIOS

This document outlines the commands and steps for installing and configuring Arch Linux, including dual-boot setup with Windows on MBR/Legacy BIOS. The guide assumes you are working from a live Arch Linux ISO environment.

## Table of Contents

1. [Initial Setup](#initial-setup)
   - [Keymap Configuration](#keymap-configuration)
   - [Internet Connection](#internet-connection)
2. [Disk Partitioning and Formatting](#disk-partitioning-and-formatting)
   - [Partition the Disk](#partition-the-disk)
   - [Format the Partitions](#format-the-partitions)
   - [Mount the Partitions](#mount-the-partitions)
3. [Base System Installation](#base-system-installation)
   - [Install Base Packages](#install-base-packages)
4. [System Configuration](#system-configuration)
   - [Generate fstab](#generate-fstab)
   - [Chroot into the System](#chroot-into-the-system)
   - [Set Timezone and Locale](#set-timezone-and-locale)
   - [Configure Hostname](#configure-hostname)
   - [Set Root Password](#set-root-password)
   - [Create a New User](#create-a-new-user)
   - [Install Essential Packages](#install-essential-packages)
5. [Bootloader Configuration](#bootloader-configuration)
   - [Install GRUB](#install-grub)
   - [Configure GRUB](#configure-grub)
6. [Enable Services](#enable-services)
7. [Exit and Reboot](#exit-and-reboot)
8. [Post-Installation Configuration](#post-installation-configuration)
   - [Install Video Drivers](#install-video-drivers)
   - [Install Display Server](#install-display-server)
   - [Install Desktop Environment](#install-desktop-environment)
   - [Install Display Manager](#install-display-manager)
   - [Install Fonts](#install-fonts)
   - [Install Terminal Emulators](#install-terminal-emulators)
   - [Install YAY (AUR Helper)](#install-yay-aur-helper)
   - [Install Web Browsers](#install-web-browsers)

## Initial Setup

### Keymap Configuration

Set the keyboard layout for the live environment.

```bash
# List all available keymaps
localectl list-keymaps

# Filter for French keymaps
localectl list-keymaps | grep fr

# Set the French keymap
loadkeys fr
```

**Note**: Replace **`fr`** with your preferred keymap (e.g., **`us`** for US English).

**Tip**: The keymap setting in the live environment is temporary and will be reset after reboot. You'll set the permanent keymap later in the installation process.

### Internet Connection

Ensure the system is connected to the internet.

```bash
# Check network interfaces (for Ethernet or Wi-Fi)
ip a

# Connect to Wi-Fi (option 1)
wifi-menu

# Connect to Wi-Fi (option 2)
iwctl

# Enable Network Time Protocol (NTP) for clock synchronization
timedatectl set-ntp true

# Verify internet connectivity
ping archlinux.org
```

**Tip**: If using **`iwctl`**, run **`iwctl`** and use commands like **`device list`**, **`station wlan0 scan`**, and **`station wlan0 connect <SSID>`** to connect to Wi-Fi.

**Note**: For Ethernet connections, the system should connect automatically. Press **`Ctrl+C`** to stop the ping command once you've verified connectivity.

## Disk Partitioning and Formatting

### Partition the Disk

Create partitions for Arch Linux.

```bash
# List disks and partitions
lsblk

# Partition the disk (replace /dev/sda with your disk)
cfdisk /dev/sda
```

- Select **`Free Space`** and choose **`New`** to create a partition.
- Set the partition size.
- Set the partition type to **`Primary`** and select **`Linux (83)`** as the partition type.
- Write changes by selecting **`Write`**, confirm with **`yes`**, and exit by selecting **`Quit`**.

You can check your newly created partition by retyping **`lsblk`**.

**Tip**: Make sure to note your partition names (e.g., **`/dev/sda4`**) as you'll need them for the next steps. Take a screenshot or write them down.

**Note**: For dual-boot setups, ensure you don't modify or delete existing Windows partitions. Only work with free space.

### Format the Partitions

Format the root partition (and others as needed).

```bash
# Format the root partition as ext4 (replace /dev/sda4 with your partition)
mkfs.ext4 /dev/sda4
```

**Note**: Formatting will erase all data on the partition. Make sure you're formatting the correct partition.

**Tip**: If you're creating a swap partition, format it with **`mkswap /dev/sdaX`** and activate it with **`swapon /dev/sdaX`**.

### Mount the Partitions

Mount the partitions for installation.

```bash
# Mount the root partition
mount /dev/sda4 /mnt

# Create and mount a directory for Windows (for dual-boot)
mkdir /mnt/windows10
mount /dev/sda2 /mnt/windows10
```

**Note**: Replace **`/dev/sda2`** with the Windows partition (typically NTFS).

**Tip**: Mounting the Windows partition is optional but useful for accessing Windows files and fonts from Arch Linux.

## Base System Installation

### Install Base Packages

Install the base system and essential packages.

```bash
# Install base system, kernel, and firmware
pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode
```

**Note**: Use **`amd-ucode`** instead of **`intel-ucode`** for AMD processors.

**Tip**: This step will take several minutes depending on your internet speed. Be patient and don't interrupt the process.

## System Configuration

### Generate fstab

Create the filesystem table for mounting partitions.

```bash
# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Verify the fstab file
cat /mnt/etc/fstab
```

**Tip**: The fstab file tells the system which partitions to mount at boot. Check that your partitions are correctly listed.

### Chroot into the System

Enter the new system to configure it.

```bash
arch-chroot /mnt
```

**Note**: After running this command, you're now inside your new Arch Linux system. All following commands will configure this system.

### Set Timezone and Locale

Configure the system timezone and locale.

```bash
# List available timezones
timedatectl list-timezones

# Filter for a specific city (e.g., Conakry)
timedatectl list-timezones | grep Africa/Conakry

# Set the timezone
ln -sf /usr/share/zoneinfo/Africa/Conakry /etc/localtime

# Synchronize hardware clock
hwclock --systohc
```

Edit with **`nano`** or **`vim`** your locale file **`/etc/locale.gen`** and uncomment your locale (e.g., **`fr_FR.UTF-8 UTF-8`**).

```bash
# Generate locale
locale-gen

# Set system language
echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf

# Set the system keymap
# Replace `fr` with your preferred keymap (e.g., `us` for US English)
echo "KEYMAP=fr" >> /etc/vconsole.conf
```

**Note**: Replace **`fr_FR.UTF-8`** with your preferred locale (e.g., **`en_US.UTF-8`** for US English) if necessary. Available locales can be found in **`/etc/locale.gen`**.

**Tip**: The keymap setting here is permanent and will persist after reboot, unlike the temporary setting from the live environment.

### Configure Hostname

Set the system hostname and hosts file.

```bash
# Set hostname (replace arch-computer with your preferred hostname)
echo "arch-computer" > /etc/hostname

# Configure hosts file
cat << EOF >> /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch-computer.localdomain   arch-computer
EOF
```

**Tip**: Choose a hostname that's easy to remember and identifies your computer. Common examples include `arch-laptop`, `arch-desktop`, or your preferred name.

### Set Root Password

Set a password for the root user.

```bash
passwd
```

**Note**: Choose a strong password and remember it. You'll need this password for system administration tasks.

**Tip**: The password won't be visible as you type it. This is normal for security reasons.

### Create a New User

Create a user with sudo privileges.

```bash
# Create user with home directory and add to wheel group
useradd -m -G wheel <your_username>

# Set user password
passwd <your_username>

# Grant sudo privileges to wheel group
EDITOR=vim visudo
```

In the **`visudo`** editor, uncomment the line: **`%wheel ALL=(ALL) ALL`**.

**Note**: Replace **`<your_username>`** with your desired username (e.g., **`john`**, **`alice`**). Use lowercase letters and avoid spaces.

**Tip**: Press **`i`** in vim to enter insert mode, uncomment the line by removing the **`#`**, then press **`Esc`** and type **`:wq`** to save and exit.

### Install Essential Packages

Install additional utilities for a functional system.

```bash
# Update package database and system
pacman -Syy
pacman -Syu

# Install utility packages
pacman -S xdg-utils xdg-user-dirs mtools dosfstools dialog networkmanager networkmanager-applet networkmanager-openvpn wireless_tools wpa_supplicant vim neovim nano git
```

**Note**: The package **`wpa_actiond`** was removed as it is deprecated. Use **`wpa_supplicant`** for Wi-Fi.

**Tip**: These packages provide essential tools for networking, text editing, and system management. They're necessary for a functional system.

## Bootloader Configuration

### Install GRUB

Install GRUB and related packages.

```bash
# Install GRUB and utilities
pacman -S grub ntfs-3g os-prober
```

**Note**: **`ntfs-3g`** allows reading and writing to Windows NTFS partitions, and **`os-prober`** helps GRUB detect other operating systems.

### Configure GRUB

Set up GRUB for booting.

```bash
# Install GRUB to the disk (replace /dev/sda with your disk)
grub-install --target=i386-pc /dev/sda
```

**Note**: Make sure to install GRUB to the disk (e.g., **`/dev/sda`**), not to a partition (e.g., **`/dev/sda4`**).

Edit **`/etc/default/grub`** and uncomment **`GRUB_DISABLE_OS_PROBER=false`** to detect other operating systems (e.g., Windows).

```bash
# Generate GRUB configuration
grub-mkconfig -o /boot/grub/grub.cfg
```

**Tip**: If Windows isn't detected in the GRUB menu after installation, you can run **`grub-mkconfig -o /boot/grub/grub.cfg`** again after booting into Arch Linux.

## Enable Services

Enable essential services to start on boot.

```bash
# Enable NetworkManager for networking
systemctl enable NetworkManager
```

**Note**: Enabling NetworkManager ensures you'll have network connectivity when you boot into your new system.

## Exit and Reboot

Exit the chroot environment, unmount partitions, and reboot your computer.

```bash
# Exit chroot
exit

# Unmount all partitions
umount -a

# Reboot the system
reboot
```

**Note**: When the computer is rebooting, if it's off, unplug the Arch Linux installation USB drive.

**Tip**: If the system boots back into the live USB, make sure to change the boot order in your BIOS/UEFI settings to prioritize the hard drive.

## Post-Installation Configuration

### Install Video Drivers

Install drivers for your graphics hardware.

```bash
# Check graphics hardware
lspci

# Install Intel drivers (for Intel GPUs)
pacman -S xf86-video-intel libgl mesa
```

**Note**: For NVIDIA GPUs, use **`pacman -S nvidia nvidia-utils`**, or for AMD, use **`pacman -S xf86-video-amdgpu`**.

**Tip**: Run **`lspci | grep VGA`** to identify your graphics card model before installing drivers.

### Install Display Server

Install the X.Org display server.

```bash
pacman -S xorg
```

**Note**: Xorg is the display server that enables graphical interfaces. It's required for desktop environments to function.

### Install Desktop Environment

Choose and install a desktop environment.

**XFCE**:

```bash
pacman -S xfce4 xfce4-goodies
```

**GNOME**:

```bash
pacman -S gnome
```

**KDE Plasma**:

```bash
pacman -S plasma kde-applications
```

**Tip**: **`XFCE`** is lightweight and fast, **`GNOME`** is modern and polished, and **`KDE Plasma`** is highly customizable. Choose based on your preferences and system resources.

### Install Display Manager

Install and enable SDDM (Simple Desktop Display Manager).

```bash
pacman -S sddm
sudo systemctl enable sddm
```

**Note**: Start SDDM after completing the desktop environment installation: **`systemctl start sddm`**.

**Tip**: **`SDDM`** provides a graphical login screen. You can also use other display managers like **`GDM`** (for GNOME) or **`LightDM`**.

### Install Fonts

Copy Windows fonts (for dual-boot setups) and install additional fonts.

```bash
# Create directory for Windows fonts
mkdir /usr/share/fonts/windows-fonts

# Copy Windows fonts
cp /mnt/windows10/Windows/Fonts/* /usr/share/fonts/windows-fonts/

# Set permissions and update font cache
chmod 644 /usr/share/fonts/windows-fonts/*
fc-cache -f
```

**Note**: Copying Windows fonts is optional but provides better compatibility with documents created on Windows.

**Tip**: The **`fc-cache`** command refreshes the font cache so the system recognizes newly installed fonts.

**Install Noto Fonts and Emojis**:

```bash
pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
fc-cache -f
```

**Note**: **`Noto`** fonts provide excellent Unicode coverage, including **`CJK`** (Chinese, Japanese, Korean) characters and emojis.

**Install Nerd Fonts**:

```bash
pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-firacode-nerd ttf-ibmplex-mono-nerd ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
fc-cache -f
```

**Tip**: **`Nerd`** Fonts include programming ligatures and icons useful for terminal emulators and code editors.

### Install Terminal Emulators

Install your preferred terminal emulator.

```bash
pacman -S kitty        # Kitty terminal
pacman -S ghostty      # Ghostty terminal
pacman -S fish         # Fish shell
pacman -S konsole      # Konsole terminal
```

**Note**: **`ghostty`** may not be available in the official repositories; use **`yay -S ghostty`** if available in the **`AUR`**.

**Tip**: **`Kitty`** is GPU-accelerated and feature-rich, while **`Konsole`** is well-integrated with **`KDE`**. **`Fish`** is a user-friendly shell alternative to bash.

### Install YAY (AUR Helper)

Install **`yay`** to access the Arch User Repository (AUR).

```bash
# Clone YAY repository
git clone https://aur.archlinux.org/yay.git
cd yay

# Build and install YAY
makepkg -si PKGBUILD
```

**Note**: **`YAY`** allows you to easily install packages from the Arch User Repository (**`AUR`**), which contains community-maintained packages.

**Tip**: Run this installation as your regular user, not as root. **`YAY`** will prompt for your password when needed.

### Install Web Browsers

Install web browsers from the AUR or official repositories.

```bash
yay -S brave-bin       # Brave browser
pacman -S firefox      # Firefox browser
```

**Tip**: **`Brave`** is privacy-focused and Chromium-based, while Firefox is open-source and maintained by Mozilla. Choose based on your preferences.

