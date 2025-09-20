{
"name": "{$system['system_title']}",
"start_url": "{$system['system_url']}",
"display": "standalone",
"icons": [
{
"src": {if $system['pwa_192_icon']}"{$system['system_uploads']}/{$system['pwa_192_icon']}"{else}"/content/uploads/pwa/icon-192x192.png"{/if},
"sizes": "192x192",
"type": "image/png"
},
{
"src": {if $system['pwa_512_icon']}"{$system['system_uploads']}/{$system['pwa_512_icon']}"{else}"/content/uploads/pwa/icon-512x512.png"{/if},
"sizes": "512x512",
"type": "image/png"
}
]
}