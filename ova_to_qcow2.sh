#!/bin/bash

OVA_FILE=$1
TEMP_DIR=$(mktemp -d)
VMDK_FILE=""
QCOW2_FILE_NAME="$(basename "${OVA_FILE%.*}").qcow2"

echo "Estrazione di $OVA_FILE in $TEMP_DIR..."
tar -xf "$OVA_FILE" -C "$TEMP_DIR"

for file in "$TEMP_DIR"/*.vmdk; do
    VMDK_FILE="$file"
    break
done

if [ -z "$VMDK_FILE" ]; then
    echo "File VMDK non trovato."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Conversione del file VMDK in QCOW2..."
qemu-img convert -O qcow2 "$VMDK_FILE" "$TEMP_DIR/$QCOW2_FILE_NAME"

if [ $? -ne 0 ]; then
    echo "Errore durante la conversione del file VMDK in QCOW2."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Copia di $QCOW2_FILE_NAME in /var/lib/vz/template/..."
cp "$TEMP_DIR/$QCOW2_FILE_NAME" /var/lib/vz/template/

if [ $? -ne 0 ]; then
    echo "Errore durante la copia del file QCOW2."
    rm -rf "$TEMP_DIR"
    exit 1
fi

rm -rf "$TEMP_DIR"
echo "Rimozione della cartella temporanea completata."

read -p "Vuoi creare la VM e importare il disco? (s/n): " choice
if [[ "$choice" =~ ^[Ss]$ ]]; then
    read -p "Inserisci l'ID della VM: " VM_ID
    read -p "Inserisci la memoria RAM (in MB): " RAM
    read -p "Inserisci il numero di core: " CORES
    VM_NAME=$(basename "${OVA_FILE%.*}" | tr -dc '[:alnum:]-')
    
    echo "Creazione della VM con ID $VM_ID, RAM $RAM MB, e $CORES core..."
    qm create "$VM_ID" --memory "$RAM" --cores "$CORES" --name "$VM_NAME" --net0 virtio,bridge=vmbr0 --boot c --bootdisk ide0

    echo "Importazione del disco $QCOW2_FILE_NAME nella VM $VM_ID..."
    qm importdisk "$VM_ID" "/var/lib/vz/template/$QCOW2_FILE_NAME" local-lvm

    echo "Configurazione del disco ide0 per la VM $VM_ID..."
    qm set "$VM_ID" --ide0 local-lvm:vm-"$VM_ID"-disk-0

    echo "Operazione completata con successo."
fi