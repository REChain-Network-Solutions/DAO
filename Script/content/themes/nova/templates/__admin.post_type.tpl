{if $row['post_type'] == "shared"}
  {__("Share")}
{elseif $row['post_type'] == ""}
  {__("Text")}
{elseif $row['post_type'] == "map"}
  {__("Maps")}
{elseif $row['post_type'] == "link"}
  {__("Link")}
{elseif $row['post_type'] == "media"}
  {__("Media")}
{elseif $row['post_type'] == "live"}
  {__("Live Streaming")}
{elseif $row['post_type'] == "photos"}
  {__("Photos")}
{elseif $row['post_type'] == "album"}
  {__("Album")}
{elseif $row['post_type'] == "profile_picture"}
  {__("Profile Picture")}
{elseif $row['post_type'] == "profile_cover"}
  {__("Cover Photo")}
{elseif $row['post_type'] == "page_picture"}
  {__("Page Picture")}
{elseif $row['post_type'] == "page_cover"}
  {__("Page Cover")}
{elseif $row['post_type'] == "group_picture"}
  {__("Group Picture")}
{elseif $row['post_type'] == "group_cover"}
  {__("Group Cover")}
{elseif $row['post_type'] == "event_cover"}
  {__("Event Cover")}
{elseif $row['post_type'] == "article"}
  {__("Blog")}
{elseif $row['post_type'] == "product"}
  {__("Product")}
{elseif $row['post_type'] == "funding"}
  {__("Funding")}
{elseif $row['post_type'] == "offer"}
  {__("Offer")}
{elseif $row['post_type'] == "job"}
  {__("Job")}
{elseif $row['post_type'] == "poll"}
  {__("Poll")}
{elseif $row['post_type'] == "reel"}
  {__("Reel")}
{elseif $row['post_type'] == "video"}
  {__("Video")}
{elseif $row['post_type'] == "audio"}
  {__("Audio")}
{elseif $row['post_type'] == "file"}
  {__("File")}
{elseif $row['post_type'] == "combo"}
  {__("Combo")}
{/if}
