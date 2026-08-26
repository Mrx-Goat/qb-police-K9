fx_version 'cerulean'
game 'gta5'

author 'mrx-goat'
version '1.8'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_script 'config.lua'

dependencies {
    'oxmysql'
}
