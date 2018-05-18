#!/bin/sh
if ( wp --allow-root core is-installed ); then
	BKDIR=/backups/`date +%Y-%m-%d`
	if [ -d $BKDIR ]; then
		echo "$BKDIR already exists, skipping backup"
	else
		mkdir $BKDIR
		echo `wp --allow-root option get siteurl` > ${BKDIR}/siteurl.txt
		wp db --allow-root export --add-drop-table ${BKDIR}/wordpress.sql
		cp -r ./ ${BKDIR}/www
	fi
fi
