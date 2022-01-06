# Luup-Football-Switch

# Scope

This is a Luup plugin to make you aware of your favorite team's next match/game.

Leveraging the great service provided via https://fixtur.es/ and all their digital football calendars, find your team's url and create alerts for your team's next game etc.

Football calendar season 2021 – 2022: Eredivisie - Keuken Kampioen Divisie - Eredivisie Vrouwen - Primera Division - Bundesliga - Ligue 1 - Jupiler Pro League - Premier League - Serie A - Superliga - Scottish Premier League - WK kwalificatie - Superleague - Bundesliga Österreich - Superlig - EFL Championship - WK kwalificatie - Vrouwen - Super League Greece - Premjer-Liga - Liga MX - Serie A Brazil - Primera A - Primera Division Argentina - Nations League - Irish Premier Division - MLS - Swedish Allsvenskan - Chinese Super League - Israel Ligat Ha`Al - Ekstraklasa - Danish Superligaen - Eliteserien - Veikkausliiga - League One - Serie B - League Two - Super League 2 Greece - Česká Liga - Slovak Super Liga - Scottish Championship - FA Women's Super League - UEFA Women's Euro 2022 - FIFA World Cup Qatar 2022

This plugin can also easily be customised to support any ical service, just update the url to whatever you want..

Luup (Lua-UPnP) is a software engine which incorporates Lua, a popular scripting language, and UPnP, the industry standard way to control devices. Luup is the basis of a number of home automation controllers e.g. Micasaverde Vera, Vera Home Control, OpenLuup.

# Compatibility

This plug-in has been tested on the Ezlo Vera Home Control system.

# Features

It supports the following functions:

* Creation a device in UI for your teaml showing their next match
* Updated variables showing the match after mext too.

Still to be added..

* Switch function to be turned on/off
* Ability to add multiple icals
* Add an offset capability so you can get notifications in advance
* other fixes/updates

# Imstallation / Usage

This installation assumes you are running the latest version of Vera software.

1. Find the ical url for your team, at -> https://fixtur.es/ e.g https://ics.fixtur.es/v2/ipswich-town.ics
2. Either update the .json file to link to your team's badge/logo icon or upload the two icon .png files to the appropriate storage location on your controller. For Vera that's `/www/cmh/skins/default/icons`
3. Upload the .xml and .json file in the repository to the appropriate storage location on your controller. For Vera that's via Apps/Develop Apps/Luup files/
4. Create the decice instance via the appropriate route. For Vera that's Apps/Develop Apps/Create Device/ and putting "D_FootballSwitch.xml" into the Upnp Device Filename box. 
5. Reload luup to establish the device and then update the calenderuri variable with a link to your teams ical location. e.g https://ics.fixtur.es/v2/ipswich-town.ics
6. If you don't want your teams name to appear in the UI, then add it to the "My Team" variable and it will be removed, which makes it look better.
7. Reload luup again and you should be good to go.

# Limitations

While it has been tested, it has not been tested very much and may not support other related devices or those running different firmware.

# Buy me a coffee

If you choose to use/customise or just like this plug-in, feel free to say thanks with a coffee or two.. 
(God knows I drank enough working on this :-)) 

<a href="https://www.paypal.me/nodezero" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

# Screenshots

Once installed, and the calenderurl address has been added, you should see the device listed with your team's next game listed.

![8A7F7980-D672-41AF-B2A3-0E1897E56125](https://user-images.githubusercontent.com/4349292/148358948-a92b3e7c-d293-4727-967b-e8bf38a17298.jpeg)

# License

Copyright © 2021 Chris Parker (nodecentral)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses
