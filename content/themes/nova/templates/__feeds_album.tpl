<div class="col-sm-6 col-md-4 col-lg-3">
  <div class="album-card">
    {if $album['cover']['blur']}<div class="x-blured">{/if}
      <a class="album-cover" href="{$system['system_url']}/{$album['path']}/album/{$album['album_id']}" style="background-image:url({$album['cover']['source']});">
      </a>
      {if $album['cover']['blur']}
    </div>{/if}
    <div class="album-details">
      <a href="{$system['system_url']}/{$album['path']}/album/{$album['album_id']}">{__($album['title'])}</a>
      <div>
        {$album['photos_count']} {__("photos")}
        <div class="float-end">
          {if $album['privacy'] == "me"}
            <span class="icon-[tabler--lock] size-4" title='{__("Shared with")}: {__("Only Me")}'></span>
          {elseif $album['privacy'] == "friends"}
            <span class="icon-[tabler--users] size-4" title='{__("Shared with")}: {if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}'></span>
          {elseif $album['privacy'] == "public"}
            <span class="icon-[tabler--world] size-4" title='{__("Shared with")}: {__("Public")}'></span>
          {elseif $album['privacy'] == "custom"}
            <span class="icon-[tabler--settings] size-4" title='{__("Shared with")} {__("Custom People")}'></span>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>