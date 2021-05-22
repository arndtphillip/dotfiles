local wibox = require("wibox")
local lgi = require("lgi")
local awful = require("awful")
local naughty = require("naughty")

local Playerctl = lgi.Playerctl
local player = Playerctl.Player{}

local art_script = [[
sh -c '
    tmp_dir="$XDG_CACHE_HOME/awesome/"
    
    if [ -z ${XDG_CACHE_HOME} ]; then
        tmp_dir="$HOME/.cache/awesome/"
    fi

    tmp_cover_path=${tmp_dir}"cover.png"

    if [ ! -d $tmp_dir  ]; then
        mkdir -p $tmp_dir
    fi

    link="$(playerctl metadata mpris:artUrl)"
    link=${link/open.spotify.com/i.scdn.co}

    curl -s "$link" --output $tmp_cover_path && echo "$tmp_cover_path"
']]

--https://open.spotify.com/image/
--https://i.scdn.co/image/

update_metadata = function()
    local artist = ""
    local title = ""
    local playing = ""

    if player:get_title() then
	    artist = player:get_artist()
        title = player:get_title()
    end

    awful.spawn.easy_async_with_shell(art_script, function(out)
        -- Get album path
        local album_path = out:gsub('%\n', '')

        awesome.emit_signal("evil::playerctl", {
            artist = artist, 
            title = title, 
            status = player.playback_status, 
            image = album_path
        })
    end)
end

player.on_metadata = update_metadata
--player.on_playback_status =

update_metadata()
