{ config, pkgs, inputs, lib, ... }:
with lib;

{
  imports = [ inputs.textfox.homeManagerModules.default ];

  programs.firefox.policies = {
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/search-by-image/latest.xpi";
        installation_mode = "force_installed";
      };
      "jid1-MnnxcxisBPnSXQ@jetpack" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        installation_mode = "force_installed";
      };
      "vimium-c@gdh1995.cn" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
        installation_mode = "force_installed";
      };
      "{531906d3-e22f-4a6c-a102-8057b88a1a63}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
        installation_mode = "force_installed";
      };
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
      "{rto@rto.rto}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/rutracker-add-on/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };

  programs.firefox.profiles.default.extensions.force = true;

  programs.firefox.profiles.default = {
    search = {
      default = "ddg";
      force = true;
    };
    settings = {
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.server" = "";
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "browser.discovery.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "font.name.monospace.x-western" = mkForce "JetBrainsMono Nerd Font";
      "font.name.serif.x-western" = mkForce "JetBrainsMono Nerd Font";
      "font.name.sans-serif.x-western" = mkForce "JetBrainsMono Nerd Font";
      "font.name.monospace.x-cyrillic" = mkForce "JetBrainsMono Nerd Font";
      "font.name.serif.x-cyrillic" = mkForce "JetBrainsMono Nerd Font";
      "font.name.sans-serif.x-cyrillic" = mkForce "JetBrainsMono Nerd Font";
      "font.default.x-western" = mkForce "sans-serif";
      "font.default.x-cyrillic" = mkForce "sans-serif";
      "font.size.variable.x-western" = mkForce 14;
      "font.size.variable.x-cyrillic" = mkForce 14;
      "browser.display.use_document_fonts" = mkForce 0;
    };
  };

  textfox = {
    enable = true;
    profiles = [ "default" ];
  };
}
