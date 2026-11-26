{if $_registration}
  {assign var="_cf_input" value=$_input_class|default:'input w-full'}
  {assign var="_cf_select" value=$_select_class|default:'select w-full'}
  {assign var="_cf_textarea" value=$_textarea_class|default:'textarea w-full'}
  {assign var="_cf_label" value=$_label_class|default:'label-text'}
  {foreach $_custom_fields as $custom_field}
    <div class="flex min-w-0 flex-col gap-2">
      <label class="{$_cf_label}">{__($custom_field['label'])} {if $custom_field['mandatory'] && !$_search}*{/if}</label>
      {if $custom_field['type'] == "textbox"}
        <input class="{$_cf_input}" name="fld_{$custom_field['field_id']}" type="text" {if $_search}value="{$custom_field['value']|default:''|escape:'html'}" {else}placeholder="{__($custom_field['label'])}" {/if} {if $custom_field['mandatory'] && !$_search}required{/if}>
      {elseif $custom_field['type'] == "textarea"}
        <textarea class="{$_cf_textarea}" name="fld_{$custom_field['field_id']}" {if !$_search}placeholder="{__($custom_field['label'])}" {/if} {if $custom_field['mandatory'] && !$_search}required{/if}>{if $_search}{$custom_field['value']|default:''|escape:'html'}{/if}</textarea>
      {elseif $custom_field['type'] == "selectbox"}
        <select class="{$_cf_select}" name="fld_{$custom_field['field_id']}" {if $custom_field['mandatory'] && !$_search}required{/if}>
          {if $_search}
            <option {if !isset($custom_field['value']) || $custom_field['value'] == "any"}selected{/if} value="any">{__("Any")}</option>
          {else}
            <option selected value="none">{__("Select")} {__($custom_field['label'])}</option>
          {/if}
          {foreach $custom_field['options'] as $id => $value}
            <option {if $_search && isset($custom_field['value']) && $custom_field['value'] == $id && $custom_field['value'] != "any"}selected{/if} value="{$id}">{__($value|trim)}</option>
          {/foreach}
        </select>
      {elseif $custom_field['type'] == "multipleselectbox"}
        <select class="{$_cf_select}" name="fld_{$custom_field['field_id']}[]" multiple {if $custom_field['mandatory'] && !$_search}required{/if}>
          {foreach $custom_field['options'] as $id => $value}
            <option {if $_search && isset($custom_field['value']) && in_array($id, $custom_field['value'])}selected{/if} value="{$id}">{__($value|trim)}</option>
          {/foreach}
        </select>
      {/if}
      {if $custom_field['description'] && !$_search}
        <div class="text-sm text-base-content/60">
          {__($custom_field['description'])}
        </div>
      {/if}
    </div>
  {/foreach}
{else}
  {foreach $_custom_fields as $custom_field}
    <div class="w-full">
      <label class="label-text mb-1.5 block" for="fld_{$custom_field['field_id']}">{__($custom_field['label'])} {if $custom_field['mandatory']}<span class="text-error">*</span>{/if}</label>
      {if $custom_field['type'] == "textbox"}
        <input class="input w-full" type="text" id="fld_{$custom_field['field_id']}" name="fld_{$custom_field['field_id']}" value="{$custom_field['value']}" {if $custom_field['mandatory']}required{/if}>
      {elseif $custom_field['type'] == "textarea"}
        <textarea class="textarea w-full" id="fld_{$custom_field['field_id']}" name="fld_{$custom_field['field_id']}" rows="3" dir="auto" {if $custom_field['mandatory']}required{/if}>{$custom_field['value_string']}</textarea>
      {elseif $custom_field['type'] == "selectbox"}
        <select class="select w-full" id="fld_{$custom_field['field_id']}" name="fld_{$custom_field['field_id']}" {if $custom_field['mandatory']}required{/if}>
          <option {if $custom_field['value'] == ""}selected{/if} value="none">{__("Select")} {__($custom_field['label'])}</option>
          {foreach $custom_field['options'] as $id => $value}
            <option {if $custom_field['value'] == $value}selected{/if} value="{$id}">{__($value|trim)}</option>
          {/foreach}
        </select>
      {elseif $custom_field['type'] == "multipleselectbox"}
        <select class="select h-auto min-h-28 w-full py-2" id="fld_{$custom_field['field_id']}" name="fld_{$custom_field['field_id']}[]" multiple {if $custom_field['mandatory']}required{/if}>
          {foreach $custom_field['options'] as $id => $value}
            <option {if isset($custom_field['value']) && in_array($id, $custom_field['value'])}selected{/if} value="{$id}">{__($value|trim)}</option>
          {/foreach}
        </select>
      {/if}
      {if $custom_field['description']}
        <p class="helper-text">{__($custom_field['description'])}</p>
      {/if}
    </div>
  {/foreach}
{/if}
