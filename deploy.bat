@echo off
echo Building Flutter Web...
call flutter build web --release

echo Uploading to server temporary folder...
scp -r build/web devstorage-server:/var/www/admin_panel_temp

echo Replacing old files and fixing permissions...
ssh devstorage-server "rm -rf /var/www/admin_panel/* && mv /var/www/admin_panel_temp/* /var/www/admin_panel/ && rm -rf /var/www/admin_panel_temp && chown -R www-data:www-data /var/www/admin_panel && chmod -R 755 /var/www/admin_panel"

echo Deploy Complete!
pause 