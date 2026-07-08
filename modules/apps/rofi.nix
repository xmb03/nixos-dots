{ config, pkgs, lib, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = lib.mkForce "JetBrainsMono Nerd Font 14";
    pass.enable = true;
    theme = lib.mkForce "drun";

    extraConfig = {
      "drun" = {
        display-name = "Apps";
      };
    };
  };

  xdg.dataFile."rofi/themes/drun.rasi".text = ''
    * {
        background: ${c.base00};
        foreground: ${c.base05};
        lightbg: ${c.base01};
        lightfg: ${c.base07};
        blue: ${c.base0D};
        red: ${c.base08};
        active-background: @background;
        active-foreground: @blue;
        active-text: @foreground;
        alternate-active-background: @lightbg;
        alternate-active-foreground: @blue;
        alternate-active-text: @foreground;
        alternate-normal-background: @lightbg;
        alternate-normal-foreground: @foreground;
        alternate-normal-text: @foreground;
        alternate-urgent-background: @lightbg;
        alternate-urgent-foreground: @red;
        alternate-urgent-text: @foreground;
        background-color: @background;
        base-text: @foreground;
        border-color: @foreground;
        normal-background: @background;
        normal-foreground: @foreground;
        normal-text: @foreground;
        selected-active-background: @blue;
        selected-active-foreground: @background;
        selected-active-text: @background;
        selected-normal-background: @lightfg;
        selected-normal-foreground: @lightbg;
        selected-normal-text: @lightbg;
        selected-urgent-background: @red;
        selected-urgent-foreground: @background;
        selected-urgent-text: @background;
        separatorcolor: @foreground;
        urgent-background: @background;
        urgent-foreground: @red;
        urgent-text: @foreground;
    }

    window {
        width: 800px;
        location: center;
        anchor: center;
        padding: 20px;
        background-color: @background;
    }

    listview {
        spacing: 4px;
        padding: 5px;
        cycle: true;
        border-color: @separatorcolor;
    }

    element {
        padding: 0.8px;
        spacing: 10px;
        border-radius: 0px;
    }

    element-icon {
        size: 1.5em;
        background-color: inherit;
        text-color: inherit;
    }

    element-text {
        horizontal-align: 0.0;
        vertical-align: 0.5;
        background-color: inherit;
        text-color: inherit;
    }

    button {
        text-color: @normal-text;
    }

    button selected {
        background-color: @selected-normal-background;
        text-color: @selected-normal-text;
    }

    case-indicator {
        text-color: @normal-text;
    }

    element alternate.active {
        background-color: @alternate-active-background;
        text-color: @alternate-active-text;
    }

    element alternate.normal {
        background-color: @alternate-normal-background;
        text-color: @alternate-normal-text;
    }

    element alternate.urgent {
        background-color: @alternate-urgent-background;
        text-color: @alternate-urgent-text;
    }

    element normal.active {
        background-color: @active-background;
        text-color: @active-text;
    }

    element normal.normal {
        background-color: @normal-background;
        text-color: @normal-text;
    }

    element normal.urgent {
        background-color: @urgent-background;
        text-color: @urgent-text;
    }

    element selected.active {
        background-color: @selected-active-background;
        text-color: @selected-active-text;
    }

    element selected.normal {
        background-color: @selected-normal-background;
        text-color: @selected-normal-text;
    }

    element selected.urgent {
        background-color: @selected-urgent-background;
        text-color: @selected-urgent-text;
    }

    entry {
        text-color: @normal-text;
    }

    inputbar {
        text-color: @normal-text;
    }

    message {
        border-color: @separatorcolor;
    }

    prompt {
        text-color: @normal-text;
    }

    scrollbar {
        handle-color: @normal-foreground;
    }

    sidebar {
        border-color: @separatorcolor;
    }

    textbox {
        text-color: @base-text;
    }

    textbox-prompt-colon {
        text-color: inherit;
    }
  '';
}
