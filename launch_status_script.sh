#!/bin/bash
base_path=$1
# Chemins et fichiers
PID_FILE="$base_path/script.PID"
PYTHON_SCRIPT="$base_path/getstatus.py"
PYTHON_EXEC=$(which python3)

# Vérifier si le fichier .PID existe
if [ -f "$PID_FILE" ]; then
    # Lire le PID depuis le fichier
    PID=$(cat "$PID_FILE")
    # Vérifier si le processus est toujours en cours
    if ps -p "$PID" > /dev/null; then
        echo "Le processus avec le PID $PID est toujours en cours. Fin du script."
        exit 0
    else
        echo "Le processus avec le PID $PID n'est plus en cours. Suppression du fichier $PID_FILE."
        rm -f "$PID_FILE"
    fi
else
    echo "Aucun fichier $PID_FILE trouvé."
fi

# Lancer le script Python en arrière-plan
echo "Lancement de $PYTHON_SCRIPT..."
$PYTHON_EXEC "$PYTHON_SCRIPT" &
NEW_PID=$!
# Vérifier si le script Python a bien démarré
if ps -p "$NEW_PID" > /dev/null; then
    echo "Script Python lancé avec le PID $NEW_PID."
    # Enregistrer le nouveau PID dans le fichier
    echo "$NEW_PID" > "$PID_FILE"
    echo "Nouveau PID enregistré dans $PID_FILE."
else
    echo "Erreur : impossible de lancer $PYTHON_SCRIPT."
    exit 1
fi
