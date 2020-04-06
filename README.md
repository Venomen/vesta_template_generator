vesta_template_generator
==============


About
--------------
(Apache) Vhost Template Generator for VestaCP. Little helper in case of switching PHP versions, setting other DocummentRoots, and custom php.ini.

If you (like me) tired with self-customizing apache domain vhosts - just run script.

After running script, select which php version you want (and some other options if you need). There will be vhost templates created in /usr/local/vesta/data/templates/web/apache2/ and you can use it in VestaCP in Web Apache Template.

At this time I don't plan adding nginx or making more options. It's just little helper. Feel free to extend it.

Requirements
--------------
- installed VestaCP (with default dirs and php-cgi)
