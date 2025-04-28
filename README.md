<p align="center">
    <img src="https://github.com/lucasluqui/KnightLauncher/blob/main/assets/img/icon-128.png?raw=true" height="128">
</p>
<h1 align="center">Knight Launcher</h1>
<p align="center">
    <a href="https://github.com/lucasluqui/KnightLauncher/blob/main/LICENSE"><img alt="GitHub license" src="https://img.shields.io/github/license/lucasluqui/KnightLauncher?style=flat-square"></a>
    <a href="https://github.com/lucasluqui/KnightLauncher/issues"><img alt="GitHub issues" src="https://img.shields.io/github/issues/lucasluqui/KnightLauncher?style=flat-square"></a>
    <a href="https://github.com/lucasluqui/KnightLauncher/stargazers"><img alt="GitHub stars" src="https://img.shields.io/github/stars/lucasluqui/KnightLauncher?style=flat-square"></a>
</p>
<p align="center">
    <a href="https://GitHub.com/lucasluqui/KnightLauncher/releases/"><img alt="Total downloads" src="https://img.shields.io/github/downloads/lucasluqui/KnightLauncher/total.svg"></a>
    <a href="https://discord.gg/RAf499a"><img alt="Discord" src="https://img.shields.io/discord/653349356459786240" target="_blank"></a>
</p>

Open source game launcher for a certain game. Supports automatic 64-bit Java VM installation, Discord integration, easier modding & much more.

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W4W11S2JU)
## Some key features
* Install and uninstall game mods in an easy and noob friendly way without worrying about game updates.
* Jump into several editors such as a model viewer and scene editor to create custom user-generated content.
* Automatically patch your game to use a 64-bit Java VM and heavily improve your performance.
* Reinstall your game without having to re-download anything, not a single file!
* Intuitive and user friendly GUI for configuring advanced settings including Extra.txt.
* Discord RPC integration that shows exactly what you're up to in game.
* Easily launch alt accounts with lesser resources assigned avoiding losing performance on your main instance.
* Ability to switch between official and third party servers.

## Translators
Thank you all for helping Knight Launcher, making it usable for everyone worldwide!
* Arabic: asan_ploto
* Chinese: [yihleego](https://github.com/yihleego)
* Deutsch: Biral and Airbee
* Eesti: [Thyrux](https://github.com/Thyrux)
* Français: PtitKrugger
* Italiano: [Lawn](https://github.com/Foyylaroni) and Kaos
* Japanese: Armin
* Polski: [Crowfunder](https://github.com/Crowfunder)
* Português (Brasil): Stret and Gugaarleo
* Русский: Milliath and [Puzovoz](https://github.com/Puzovoz)

## Discord
We've built an amazing community on Discord focused on both helping newcomers get along with the launcher and giving a hand to modders, come join us!

https://discord.gg/RAf499a

## Third Party Libraries
The following open source libraries were used to develop Knight Launcher:

- [Apache Commons IO](https://github.com/apache/commons-io)
- [Image4J](https://github.com/imcdonagh/image4j)
- [Zip4J](https://github.com/srikanth-lingala/zip4j)
- [flatlaf](https://github.com/JFormDesigner/FlatLaf)
- [discord-rpc](https://github.com/Vatuu/discord-rpc)
- [mslinks](https://github.com/DmitriiShamrikov/mslinks)
- [org.json](https://github.com/eskatos/org.json-java)
- [jIconFont](https://github.com/jIconFont)
- [samskivert](https://github.com/samskivert/samskivert)
- [JHLabs Filters](http://www.jhlabs.com/)

## Build

### Debian / apt

Install dependencies:

```sh
# install modern java (>= 18) for Fernflower and linter
sudo apt install openjdk-8-jdk openjdk-21-jdk maven xserver-xorg-video-dummy
```

For build, see [`taskfile.yml::deploy`](./taskfile.yml) steps and dependencies.

## UI Scaling

### Method 1: Over VNC from xorg virtual display

Since any native scaling capabilities are ignored, we will start Xorg server on any virtual display (:99 as the default) and use x11vnc/vnc server to mirror it for connection by vnc client

```sh
# assuming we are in KL repo root, read display config
# if this fails with an error:
#   Error parsing the config file
#   Fatal server error
#     no screens found
#
# change `Virtual 1920 1080`
# resoltion to a differnt common one
# and rerun xorg
sudo Xorg -noreset -config $(pwd)/xorg.conf :99 &
# fine-tune this resolution for proper display
xrandr --fb 840x460
export DISPLAY=:99

# mount window manager as
# SceneEditor/ModelViewer
# lacks its own window decorator
icewm-session &

# start vnc server
x11vnc -display :99 -nopw -listen 0.0.0.0 -xkb &

# build (task d) or start (task r) KL with inline DISPLAY variable, see taskfile
task d

# closing/openning of ModelViewer resets
# Virtual Display resolition to
# initial from xorg.conf
#
# for this we retart wm and apply
# dynamic resizing,
# fetch latest instance of wm with pid
# and kill this process
kill $(pgrep -x icewm-session) \
&& xrandr --fb 840x460 \
&& icewm-session &

# after KL session is complete,
# selectively kill Xorg instance
ps aux | grep Xorg
```
