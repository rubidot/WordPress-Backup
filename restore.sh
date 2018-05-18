#!/bin/sh
if [ "$1" -a -d "/backups/$1" ]; then
	SITEURL=`wp --allow-root --path='/var/www/html' option get siteurl`
	echo "restoring backup $1"
	echo "importing database"
	wp --path='/var/www/html' db --allow-root import "/backups/$1/wordpress.sql"
	BKSITEURL=`wp --allow-root --path='/var/www/html' option get siteurl`
	echo "performing search-replace for WordPress Address"
	echo "$BKSITEURL $SITEURL"
	wp --path='/var/www/html' search-replace --allow-root $BKSITEURL $SITEURL
	
	echo "restoring uploads directory"
	rm -rf /var/www/html/wp-content/uploads
	cp -r "/backups/$1/www/wp-content/uploads" /var/www/html/wp-content/uploads
	echo "copying owner settings from index.php"
	U=`stat -c %u /var/www/html/index.php`
	G=`stat -c %g /var/www/html/index.php`
	chown -R "$U:$G" /var/www/html/wp-content/uploads
else
	echo "available backup directories:"
	ls /backups
fi
