fx_version 'cerulean'
game 'gta5'

author 'Azael Dev <contact@azael.dev> (https://www.azael.dev/)'
description 'DB - Whitelisted (API Outage)'
version '1.0.0'
url 'https://github.com/Azael-Dev/azael_db-whitelisted'

lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'source/main.server.lua'
}

dependencies {
    'oxmysql'
}

provide 'azael_dc-whitelisted'
