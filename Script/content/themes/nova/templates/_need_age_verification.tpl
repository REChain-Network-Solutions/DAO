<!-- need age verification -->
{capture name='locked_title'}{if !$user->_data['user_adult']}{__("You must be 18+ to view this content")}{else}{__("Your age must be verified to view this content")}{/if}{/capture}
{include file='__locked_content.tpl' _icon="icon-[tabler--rating-18-plus]" _title=$smarty.capture.locked_title _meta='' _text='' _image='' _cta='' _framed=$_framed _compact=$_compact}
<!-- need age verification -->
