# Uninstall Linux from a Dual-Boot System with Windows 10

## Removing GRUB Bootloader and Formatting Linux Partitions on MBR Systems

This guide provides a step-by-step process to completely remove Linux from a dual-boot configuration with Windows 10, using only tools available within Windows. It covers removing the GRUB bootloader from a Master Boot Record (MBR) system and formatting residual Linux partitions, either via the Windows 10 Troubleshoot environment or a Windows 10 live USB. **If your system uses UEFI instead of MBR**, refer to Microsoft's guide on UEFI boot repair for appropriate steps, as **UEFI systems require different bootloader management**.

## Prerequisites

- **Administrator Access**: You need administrative privileges in Windows 10 or a **Windows 10 live USB** created with the Windows Media Creation Tool.
- **Backup**: Save all important Linux files to an external drive (e.g., HDD or SSD) or cloud storage before proceeding.
- **MBR Confirmation**: Verify your system uses **MBR (Legacy BIOS)**, not UEFI. Check in **Disk Management** (`diskmgmt.msc`): Right-click the disk, select **Properties** > **Volumes**, and confirm it is labeled **Master Boot Record (MBR)** or **Legacy**.

**Caution**: Incorrectly deleting partitions or modifying the bootloader can render your system unbootable. Proceed carefully and double-check each step.

## Remove GRUB Bootloader

GRUB typically overwrites the MBR on Legacy BIOS systems. You can restore the Windows bootloader using either the Windows 10 Troubleshoot environment or a Windows 10 live USB.

### Option 1: Using Windows 10 Troubleshoot Environment

1. **Access the Troubleshoot Environment**:
   - Boot into Windows 10. If the GRUB menu appears, select Windows using the arrow keys.
   - Navigate to **Settings** > **Update & Security** > **Recovery** > **Advanced Startup** > Click **Restart now**.
   - Go to **Troubleshoot** > **Advanced Options** > **Command Prompt**.

2. **Restore the Windows Bootloader**:
   - In the Command Prompt, run:

     ```cmd
     bootrec /fixmbr
     ```

     This rewrites the MBR, removing GRUB and restoring the Windows bootloader for Legacy BIOS systems.

   - Run:

     ```cmd
     bootrec /fixboot
     ```

     This repairs the Windows boot sector on the active partition (typically `C:`).

   - **Handle "Access Denied" Errors**:
     If `bootrec /fixboot` returns "Access Denied" (less common on MBR systems but possible due to partition issues or BCD corruption), follow these steps:
     1. **Verify the Active Partition**:
        - Run:

          ```cmd
          diskpart
          list disk
          select disk 0  (replace 0 with the disk containing Windows, usually marked with an asterisk `*`)
          list partition
          select partition 1  (replace 1 with the Windows partition, typically `C:`, marked as "Primary")
          detail partition
          ```

        - Ensure the partition is marked **Active**. If not, run:

          ```cmd
          active
          exit
          ```

     2. **Repair the Boot Sector**:
        - Re-run:

          ```cmd
          bootrec /fixboot
          ```

        - If "Access Denied" persists, use:

          ```cmd
          bootsect /nt60 sys
          ```

          This updates the boot code on the `C:` partition and MBR for Windows 10.

     3. **Verify and Retry**:
        - Run `bootrec /fixboot` again to ensure it completes successfully.

   - Continue with:

     ```cmd
     bootrec /scanos
     bootrec /rebuildbcd
     ```

     These commands scan for Windows installations and rebuild the Boot Configuration Data (BCD). If prompted to add a Windows installation to the boot list during `bootrec /rebuildbcd`, type `Y` and press Enter.

3. **Exit and Restart**:
   - Type `exit` and press Enter.
   - Select **Continue** to boot into Windows.
   - Verify that Windows boots directly without the GRUB menu.

### Option 2: Using a Windows 10 Live USB

1. **Create a Windows 10 Live USB**:
   - Download the **Media Creation Tool** from [Microsoft's official website](https://www.microsoft.com/software-download/windows10).
   - Create a bootable USB drive (requires an 8 GB+ USB).

2. **Boot from the Live USB**:
   - Insert the USB, restart, and enter the boot menu (e.g., `F12`, `F2`, or `Del`, depending on your system).
   - Select the USB to boot into the Windows setup environment.

3. **Access Command Prompt**:
   - On the setup screen, click **Next**, then **Repair your computer** (bottom-left).
   - Navigate to **Troubleshoot** > **Advanced Options** > **Command Prompt**.

4. **Restore the Windows Bootloader**:
   - Run the same commands as in **Option 1**:

     ```cmd
     bootrec /fixmbr
     bootrec /fixboot
     bootrec /scanos
     bootrec /rebuildbcd
     ```

   - If `bootrec /fixboot` fails, follow the same troubleshooting steps as in **Option 1**.

5. **Exit and Restart**:
   - Type `exit`, remove the USB, and select **Continue** to boot into Windows.

## Format Residual Linux Partitions

After removing GRUB, format the Linux partitions to reclaim disk space.

1. **Open Disk Management**:
   - Boot into Windows 10.
   - Press `Win + R`, type `diskmgmt.msc`, and press Enter.

2. **Identify Linux Partitions**:
   - Linux partitions (e.g., ext4 for `/`, `/home`, or swap) appear as "Unknown" or without a drive letter.
   - **Warning**: Do not delete:
     - The **C:** drive (Windows system partition, marked "Active" or "Boot").
     - Any **Recovery** or **OEM** partitions.

3. **Delete Linux Partitions**:
   - Right-click each Linux partition and select **Delete Volume**.
   - Confirm the deletion. The space will appear as **Unallocated**.

4. **Format or Merge Space**:
   - **Create a New Partition**:
     - Right-click the **Unallocated** space and select **New Simple Volume**.
     - Follow the wizard to format as **NTFS**.
   - **Merge with Windows Partition**:
     - Right-click the adjacent Windows partition (e.g., `C:`) and select **Extend Volume**.
     - Follow the wizard to add the unallocated space.

5. **Verify**:
   - In **Disk Management**, ensure Linux partitions are removed and the space is formatted or merged.
   - Restart the computer to confirm system stability.

## Troubleshooting

- **GRUB Persists After Commands**:
  - Re-run `bootrec /fixmbr` and `bootsect /nt60 C: /mbr`.
  - Ensure the correct partition is marked active using `diskpart`.
- **Persistent Errors**:
  - Boot from a Windows 10 live USB and repeat the commands.
  - Check disk health with:

    ```cmd
    chkdsk C: /f
    ```

## Useful Resources

- **Microsoft Support**: [Use bootrec.exe to Repair Startup Issues](https://support.microsoft.com/en-us/help/927392/use-bootrec-exe-in-the-windows-re-to-repair-startup-issues)
- **Microsoft Support**: [Fix Windows 10 Boot Manager](https://learn.microsoft.com/en-us/answers/questions/3953603/how-do-i-get-my-windows-10-boot-manager-fixed)
- **Microsoft Support**: [Create Installation Media for Windows 10](https://support.microsoft.com/en-us/windows/create-installation-media-for-windows-99a58364-8c02-206f-aa6f-40c3b507420d#id0ejd=windows_10)
- **YouTube Tutorials**: Search for **"remove GRUB MBR Windows 10"** for visual guides.
