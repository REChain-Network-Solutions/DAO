{if $_reaction == "like"}

  <!-- like -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/like.png" alt="Like" />
  </div>
  <!-- like -->

{elseif $_reaction == "love"}

  <!-- love -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/love.png" alt="Love" />
  </div>
  <!-- love -->

{elseif $_reaction == "haha"}

  <!-- haha -->
  <div class="emoji emoji--haha">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/haha.png" alt="Haha" />
  </div>
  <!-- haha -->

{elseif $_reaction == "yay"}

  <!-- yay -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/yay.png" alt="Yay" />
  </div>
  <!-- yay -->

{elseif $_reaction == "wow"}

  <!-- wow -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/wow.png" alt="Wow" />
  </div>
  <!-- wow -->

{elseif $_reaction == "sad"}

  <!-- sad -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/sad.png" alt="Sad" />
  </div>
  <!-- sad -->

{elseif $_reaction == "angry"}

  <!-- angry -->
  <div class="emoji">
    <img src="{$system['system_url']}/content/themes/{$system['theme']}/images/reactions/angry.png" alt="Angry" />
  </div>
  <!-- angry -->

{/if}