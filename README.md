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
sudo apt install \
  openjdk-8-jdk \
  maven
# we might also install later version, as we can use standalone LSP
sudo apt install openjdk-21-jdk
```

For building from source locally, see task `deploy` of [`taskfile.yml`](./taskfile.yml) steps and its dependencies.


## UI Scaling

There are a few conventional methods to scale UI, like relying on OS-specific properties of Hi-DPI display handling and native feature of java runtime, - none of those are covered here at the time of writing, as of KL v`.33`.

Due to this, following methods are strictly for one's own convenience to bootstrap SceneEditor in a Hi-DPI environment. Consequently, those methods and are not intended for any degree of serious/stable usage, being good-enough workarounds.

### Method 1: Xorg virtual display mirroring over VNC

Requirements:

```sh
sudo apt install \
  xserver-xorg-video-dummy \
  x11vnc \
  icewm-session \
  remmina
```

Since any native scaling capabilities are ignored, we will scale UI through not spoofing of display resolution, but rescaling of display, which would not break rest of the sessions.

To achieve this, we will create an instance of Xorg/X11 server on a specified virtual display, being :99 in out use-case.

All of commands are ran from KnightLauncher repository root directory:

```sh
sudo Xorg -noreset -config $(pwd)/xorg.conf :99 &
```

We pass Xorg [xorg.conf](./xorg.cong) configuration, where we propose a common initial resolution. It might crash with an error on log, specified in the stderr:

```log
  Error parsing the config file
  Fatal server error
    no screens found
```

In case of this error change `Virtual 1920 1080` line referencing display resolution in `xorg.conf` to a different common one and rerun xorg on :99 display.

Once Xorg is running, dynamically adjust display :99 resolution:

```sh
# define display context
export DISPLAY=:99
# fine-tune this resolution for proper display
xrandr --fb 840x460
```

The smaller this resolution, the larger UI elements will be, as we then upscale through the VNC client this smaller resolution to the size of client viewport. We can any VNC client, capable of upscaling received image, and for out purposes of using SceneEditor, [Remmina]() client will be a good enough choice.

Now, we need to initialize window manager, as SceneEditor does not have its own window decorator, `icewm` will be our choice as it is rather lightweight.

Launch `icewm` in background and start `x11vnc` server on all ports listening :99 display in background:

```sh
icewm-session &
x11vnc -display :99 -nopw -listen 0.0.0.0 -xkb &
```

Build and/or run KnightLauncher for reference, see task `run` of `taskfile.yml`:

```sh
# if task binary is in PATH, otherwise look to taskfile
task run
```

After this connect with VNC client to port `:5901`. Remmina has more stable display scaling, so we will use it.

Open SceneEditor/ModelViewer. In some instances it may spawn in initial display resolution. for this we may relaunch it and reapply `xrandr`. Keep in mind, when KL or its subsequent editors are initialized or closed, Xorg's virtual display will be reset to its initial resolution from `xorg.conf`.

To fix this, restart and readjust window manager, readjust display resolution:

```sh
kill $(pgrep -x icewm-session) \
&& xrandr --fb 840x460 \
&& icewm-session &
```

X11 server does not exit by itself, kill it by identifying process with command string from earlier:

```sh
ps aux | grep Xorg
```
