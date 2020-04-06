#!/bin/bash
#
#  Copyright (c) 2020 - Dawid Deręgowski - MIT
#
# Script to generate custom domain apache vhost templates for VESTACP
# Use with caution - beta beta!
# all credits deregowski.net

# GENERATE VHOST TEMPLATE
# VERSION 1.0.0


vesta_init="/etc/init.d/vesta"
templates_dir="/usr/local/vesta/data/templates"

# Check if VESTACP is installed as service
if [ ! -e $vesta_init ]; then
   echo "File $vesta_init does not exist. Vesta have to be installed as service."
   exit 1
fi

# Check if data/templates exists
if [ ! -e $templates_dir ]; then
   echo "File $templates_dir does not exist. Please check vesta installation."
   exit 1
fi

# Lets answer some important life questions...
echo "------- VESTACP Custom Vhost Template Generator"
echo "1. What is your domain name? ONLY In this format: somedomaincom"
read domain_name
echo ""

echo "2. Do you need custom Document Root directory? For ex.: /home/user/web/domain.com/public_html/yourdirectory"
docroot_options=("Yes" "No")
select opt in "${docroot_options[@]}"
do
    case $opt in
        "Yes")
            echo "you chose custom document root, write it down:"
            read docroot
	    break
            ;;
        "No")
            echo "you chose no custom docroot"
            docroot=""
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

echo ""

echo "3. What is your PHP version?"
php_options=("PHP 5" "PHP 7" "PHP 7.2" "PHP 7.3")
select opt in "${php_options[@]}"
do
    case $opt in
        "PHP 5")
            echo "you chose PHP 5"
            php_version="5"
            break
            ;;
        "PHP 7")
            echo "you chose PHP 7"
            php_version="7"
            break
            ;;
        "PHP 7.2")
            echo "you chose PHP 7.2"
            php_version="7.2"
            break
            ;;
        "PHP 7.3")
            echo "you chose PHP 7.3"
            php_version="7.3"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

echo ""

echo "4. Do you need custom php.ini for PHP7?"
if_php_ini=("Yes" "No")
select opt in "${if_php_ini[@]}"
do
    case $opt in
        "Yes")
            echo "you chose Yes, please write where this php.ini is (for ex.: /etc/php/7.0/cgi/betadecormintcom.ini):"
            read php_ini
            break
            ;;
        "No")
            echo "you chose No"
            php_ini=""
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

echo ""


# Checking conditionals...
if [ $php_version = "5" ]; then
  cp /usr/local/vesta/data/templates/web/apache2/hosting.tpl /usr/local/vesta/data/templates/web/apache2/$domain_name.tpl
  cp /usr/local/vesta/data/templates/web/apache2/hosting.stpl /usr/local/vesta/data/templates/web/apache2/$domain_name.stpl
fi

if [ $php_version = "7" ]; then
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.tpl /usr/local/vesta/data/templates/web/apache2/php7$domain_name.tpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.stpl /usr/local/vesta/data/templates/web/apache2/php7$domain_name.stpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.sh /usr/local/vesta/data/templates/web/apache2/php7$domain_name.sh
  sed -i s'/php-cgi/php-cgi7.0/'g /usr/local/vesta/data/templates/web/apache2/php7$domain_name.sh
fi

if [ $php_version = "7.2" ]; then
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.tpl /usr/local/vesta/data/templates/web/apache2/php72$domain_name.tpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.stpl /usr/local/vesta/data/templates/web/apache2/php72$domain_name.stpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.sh /usr/local/vesta/data/templates/web/apache2/php72$domain_name.sh
  sed -i s'/php-cgi/php-cgi7.2/'g /usr/local/vesta/data/templates/web/apache2/php72$domain_name.sh
fi

if [ $php_version = "7.3" ]; then
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.tpl /usr/local/vesta/data/templates/web/apache2/php73$domain_name.tpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.stpl /usr/local/vesta/data/templates/web/apache2/php73$domain_name.stpl
  cp /usr/local/vesta/data/templates/web/apache2/phpfcgid.sh /usr/local/vesta/data/templates/web/apache2/php73$domain_name.sh
  sed -i s'/php-cgi/php-cgi7.3/'g /usr/local/vesta/data/templates/web/apache2/php73$domain_name.sh
fi


if [ ! -z ${docroot} ]; then
  sed -i "/DocumentRoot/c\    DocumentRoot ${docroot}" /usr/local/vesta/data/templates/web/apache2/*$domain_name*
fi

if [ ! -z ${php_ini} ]; then
  sed -i "/php-cgi/c\exec  /usr/bin/php-cgi -c ${php_ini}" /usr/local/vesta/data/templates/web/apache2/php7*$domain_name.sh
fi


echo ""
/etc/init.d/vesta restart

echo ""
echo "All OK! You can choose your new vhost template in VESTACP domain options (apache template)."
