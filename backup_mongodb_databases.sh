#!/bin/bash


# author: Alysson Ajackson
# date: Mon Jun 24 03:43:57 BRT 2013
# Version 1: 
#   Backup all MongoDB's databases saving a gzip file for each one in a cloud service (e.g.: Dropbox)

SPECIFIC_DB=""
CLOUD_SERVICE="Copy"
DB_SERVER="localhost"
TMP_DIR="/tmp/$DB_SERVER"
LOGGED_USER=$(whoami)

while test -n "$1"
do

    case "$1" in
        --all                   )
            SPECIFIC_DB=""
                                        ;;
        --db                    )
        #TODO: allow to pass more than one, by comma separated values
            shift
            SPECIFIC_DB="$1"
                                        ;;
        --cloud                 )
            shift
            CLOUD_SERVICE="$1"
                                        ;;
        -v | --verbose          )
            VERBOSE="-v "
                                        ;;
        --zip                   )
            COMPRESS_TYPE="zip"
                                        ;;
        *                       )
            echo "Invalid option"
            exit 1
        ;;
    esac

    shift

done

BACKUP_DIR="/home/$LOGGED_USER/$(echo $CLOUD_SERVICE)/backups/mongodb/$(date '+%Y%m%d')"

if [ ! -d "$BACKUP_DIR" ]; then
    #create backup dir if not exists yet
    mkdir -p "$BACKUP_DIR"
fi

if [ ! -d "$TMP_DIR" ]; then
    #create TMP_DIR dir if not exists yet
    mkdir -p "$TMP_DIR"
fi

if test -n "$SPECIFIC_DB"
then
    DATABSES_LIST="$SPECIFIC_DB"
else
    DATABSES_LIST=$(echo 'show dbs' | mongo --quiet | sed -e 's/^\([^\t]\+\)\t.*$/\1/g')
fi

echo "$DATABSES_LIST" | while read dbName ; do
    #mongodump "$VERBOSE" --db "$dbName" --out "$TMP_DIR" #| gzip > "$BACKUP_DIR/`echo "$DB_SERVER""_$dbName"`_`date '+%Hh%Mmin%Ss'`.sql.gz"
    $(echo "mongodump $VERBOSE --db $dbName --out $TMP_DIR");

    fileName=$(echo "$DB_SERVER""_$dbName""_"$(date '+%Hh%Mmin%Ss'))

    if test "$COMPRESS_TYPE" = "zip"
    then
        zip -rj "$BACKUP_DIR/$fileName.zip" "$TMP_DIR"
    else
        $(echo "tar zcvf $BACKUP_DIR/$fileName.tar.gz -C $TMP_DIR .")
        #tar zcvf "$BACKUP_DIR/$fileName.tar.gz" "$TMP_DIR" #include directory structure in the compressed file
    fi
    rm -r "$TMP_DIR/$dbName"
done;

exit 0
