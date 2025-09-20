<div class="p-3 w-100">
	<div class="x-hidden x_menu_sidebar_back mb-3">
		<button type="button" class="btn btn-gray w-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"><path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z"></path></svg>
			{__("More Settings")}
		</button>
	</div>
	<div class="headline-font fw-semibold side_widget_title p-0 d-flex align-items-center gap-3">
		{__("Privacy")} {__("Settings")}
	</div>
</div>

<form class="js_ajax-forms p-3 pt-1" data-url="users/settings.php?edit=privacy">
    {if $system['chat_enabled']}
		<div class="form-table-row mb-2 pb-1">
			<div>
				<div class="form-label mb0">{__("Chat Active Status")}</div>
				<div class="form-text d-none d-sm-block mt0">{__("If chat active status is disabled you will appear offline and will not see who is online")}</div>
			</div>
			<div class="text-end align-self-center flex-0">
				<label class="switch" for="user_chat_enabled">
					<input type="checkbox" name="user_chat_enabled" id="user_chat_enabled" {if $user->_data['user_chat_enabled']}checked{/if}>
					<span class="slider round"></span>
				</label>
			</div>
		</div>
    {/if}

    <div class="form-table-row mb-2 pb-1">
		<div>
			<div class="form-label mb0">{__("Email you with our newsletter")}</div>
			<div class="form-text d-none d-sm-block mt0">{__("From time to time we send newsletter email to all of our members")}</div>
		</div>
		<div class="text-end align-self-center flex-0">
			<label class="switch" for="user_newsletter_enabled">
				<input type="checkbox" name="user_newsletter_enabled" id="user_newsletter_enabled" {if $user->_data['user_newsletter_enabled']}checked{/if}>
				<span class="slider round"></span>
			</label>
		</div>
    </div>

    {if $user->_data['can_receive_tip']}
		<div class="form-table-row mb-2 pb-1">
			<div>
				<div class="form-label mb0">{__("Tips Enabled")}</div>
				<div class="form-text d-none d-sm-block mt0">{__("Allow the send tips button on your profile")}</div>
			</div>
			<div class="text-end align-self-center flex-0">
				<label class="switch" for="user_tips_enabled">
					<input type="checkbox" name="user_tips_enabled" id="user_tips_enabled" {if $user->_data['user_tips_enabled']}checked{/if}>
					<span class="slider round"></span>
				</label>
			</div>
		</div>
    {/if}
	
	<div class="form-table-row mb-2 pb-1">
		<div>
			<div class="form-label mb0">{if $system['friends_enabled']}{__("Hide from friends suggestions list?")}{else}{__("Hide from followings suggestions list?")}{/if}</div>
			<div class="form-text d-none d-sm-block mt0">{__("Enable this option to hide your profile from the suggestions list")}</div>
		</div>
		<div class="text-end align-self-center flex-0">
			<label class="switch" for="user_suggestions_hidden">
				<input type="checkbox" name="user_suggestions_hidden" id="user_suggestions_hidden" {if $user->_data['user_suggestions_hidden']}checked{/if}>
				<span class="slider round"></span>
			</label>
		</div>
    </div>
	
	<hr>

	{if $system['chat_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_chat">
				<option {if $user->_data['user_privacy_chat'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_chat'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_chat'] == "me"}selected{/if} value="me">
					{__("No One")}
				</option>
            </select>
			<label class="form-label">{__("Who can message you")}</label>
		</div>
	{/if}

	{if $system['pokes_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_poke">
				<option {if $user->_data['user_privacy_poke'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_poke'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_poke'] == "me"}selected{/if} value="me">
					{__("No One")}
				</option>
            </select>
			<label class="form-label">{__("Who can poke you")}</label>
		</div>
	{/if}

	{if $system['gifts_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_gifts">
				<option {if $user->_data['user_privacy_gifts'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_gifts'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_gifts'] == "me"}selected{/if} value="me">
					{__("No One")}
				</option>
            </select>
			<label class="form-label">{__("Who can send you gifts")}</label>
		</div>
	{/if}

	{if $system['wall_posts_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_wall">
				<option {if $user->_data['user_privacy_wall'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_wall'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_wall'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can post on your wall")}</label>
		</div>
	{/if}

	{if !$system['genders_disabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_gender">
				<option {if $user->_data['user_privacy_gender'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_gender'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_gender'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("gender")}</label>
		</div>
	{/if}

	{if $system['relationship_info_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_relationship">
				<option {if $user->_data['user_privacy_relationship'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_relationship'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_relationship'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("relationship")}</label>
		</div>
	{/if}

	<div class="form-floating">
		<select class="form-select" name="user_privacy_birthdate">
			<option {if $user->_data['user_privacy_birthdate'] == "public"}selected{/if} value="public">
				{__("Everyone")}
			</option>
            <option {if $user->_data['user_privacy_birthdate'] == "friends"}selected{/if} value="friends">
				{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
            </option>
            <option {if $user->_data['user_privacy_birthdate'] == "me"}selected{/if} value="me">
				{__("Just Me")}
            </option>
		</select>
		<label class="form-label">{__("Who can see your")} {__("birthdate")}</label>
	</div>

	<div class="form-floating">
		<select class="form-select" name="user_privacy_basic">
            <option {if $user->_data['user_privacy_basic'] == "public"}selected{/if} value="public">
				{__("Everyone")}
            </option>
            <option {if $user->_data['user_privacy_basic'] == "friends"}selected{/if} value="friends">
				{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
            </option>
            <option {if $user->_data['user_privacy_basic'] == "me"}selected{/if} value="me">
				{__("Just Me")}
            </option>
		</select>
		<label class="form-label">{__("Who can see your")} {__("basic info")}</label>
	</div>

	{if $system['work_info_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_work">
				<option {if $user->_data['user_privacy_work'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_work'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_work'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("work info")}</label>
		</div>
	{/if}

	{if $system['location_info_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_location">
				<option {if $user->_data['user_privacy_location'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_location'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_location'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("location info")}</label>
		</div>
	{/if}

	{if $system['education_info_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_education">
				<option {if $user->_data['user_privacy_education'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_education'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_education'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("education info")}</label>
		</div>
	{/if}

	<div class="form-floating">
		<select class="form-select" name="user_privacy_other">
			<option {if $user->_data['user_privacy_other'] == "public"}selected{/if} value="public">
				{__("Everyone")}
			</option>
            <option {if $user->_data['user_privacy_other'] == "friends"}selected{/if} value="friends">
				{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
			</option>
            <option {if $user->_data['user_privacy_other'] == "me"}selected{/if} value="me">
				{__("Just Me")}
            </option>
		</select>
		<label class="form-label">{__("Who can see your")} {__("other info")}</label>
	</div>

	{if $system['friends_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_friends">
				<option {if $user->_data['user_privacy_friends'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_friends'] == "friends"}selected{/if} value="friends">
					{__("Friends")}
				</option>
				<option {if $user->_data['user_privacy_friends'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("friends")}</label>
		</div>
	{/if}

	<div class="form-floating">
		<select class="form-select" name="user_privacy_followers">
            <option {if $user->_data['user_privacy_followers'] == "public"}selected{/if} value="public">
				{__("Everyone")}
            </option>
            <option {if $user->_data['user_privacy_followers'] == "friends"}selected{/if} value="friends">
				{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
            </option>
            <option {if $user->_data['user_privacy_followers'] == "me"}selected{/if} value="me">
				{__("Just Me")}
            </option>
		</select>
		<label class="form-label">{__("Who can see your")} {__("followers/followings")}</label>
	</div>

	{if $system['monetization_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_subscriptions">
				<option {if $user->_data['user_privacy_subscriptions'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_subscriptions'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_subscriptions'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("subscriptions")}</label>
		</div>
	{/if}

	<div class="form-floating">
		<select class="form-select" name="user_privacy_photos">
            <option {if $user->_data['user_privacy_photos'] == "public"}selected{/if} value="public">
				{__("Everyone")}
            </option>
            <option {if $user->_data['user_privacy_photos'] == "friends"}selected{/if} value="friends">
				{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
            </option>
            <option {if $user->_data['user_privacy_photos'] == "me"}selected{/if} value="me">
				{__("Just Me")}
            </option>
		</select>
		<label class="form-label">{__("Who can see your")} {__("photos")}</label>
	</div>

	{if $system['pages_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_pages">
				<option {if $user->_data['user_privacy_pages'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_pages'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_pages'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("liked pages")}</label>
		</div>
	{/if}

	{if $system['groups_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_groups">
				<option {if $user->_data['user_privacy_groups'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_groups'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_groups'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("joined groups")}</label>
		</div>
	{/if}

	{if $system['events_enabled']}
		<div class="form-floating">
            <select class="form-select" name="user_privacy_events">
				<option {if $user->_data['user_privacy_events'] == "public"}selected{/if} value="public">
					{__("Everyone")}
				</option>
				<option {if $user->_data['user_privacy_events'] == "friends"}selected{/if} value="friends">
					{if $system['friends_enabled']}{__("Friends")}{else}{__("Followers")}{/if}
				</option>
				<option {if $user->_data['user_privacy_events'] == "me"}selected{/if} value="me">
					{__("Just Me")}
				</option>
            </select>
			<label class="form-label">{__("Who can see your")} {__("joined events")}</label>
		</div>
	{/if}

    <!-- success -->
    <div class="alert alert-success mt15 mb0 x-hidden"></div>
    <!-- success -->

	<!-- error -->
	<div class="alert alert-danger mt15 mb0 x-hidden"></div>
	<!-- error -->
	
	<hr class="hr-2">
	
	<div class="text-end">
		<button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
	</div>
</form>