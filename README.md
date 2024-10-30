# Extract and Convert VMDK File from an OVA Archive to QCOW2, and Create a Virtual Machine on Proxmox

## Description

This script automates the process of extracting a VMDK file from an OVA archive, converting the disk to QCOW2 format, and creating a Virtual Machine on Proxmox with the converted disk attached. The script will prompt the user to input the VM ID, RAM amount, and the number of CPU cores for the VM.

## Requirements

- **Proxmox VE** installed
- **qemu-img** for VMDK to QCOW2 disk conversion
- **Root access** (OBV) on Proxmox to install and execute the script

## Instructions

1. **Clone the repository** to your Proxmox machine:

    ```bash
    git clone <URL_of_your_repository>
    cd <repository_name>
    ```

2. **Make the script executable**:

    ```bash
    chmod +x convert_vmdk_to_qcow2.sh
    ```

3. **Run the script** with:

    ```bash
    ./convert_vmdk_to_qcow2.sh <path_to_ova_file>
    ```

    Replace `<path_to_ova_file>` with the actual path to the OVA file you want to use.

4. **Enter the required parameters** when prompted:

    - **VM ID**: the unique identifier for the VM on Proxmox
    - **RAM**: the amount of memory in MB (e.g., 2048 for 2 GB)
    - **CPU Cores**: the number of CPU cores to assign to the VM

5. **Verify** that the VM is successfully created and ready to launch on Proxmox. You can manage it via the Proxmox web interface.

## Notes

- The script will place the QCOW2 file in the `/var/lib/vz/template/` directory.
- Ensure that you have sufficient space on Proxmox for the disk conversion and VM creation.

## Usage Example

```bash
./convert_vmdk_to_qcow2.sh ova/Sample_OVA.ova