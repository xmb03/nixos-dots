# NetworkManager configuration module
# ===================================
#
# This module provides a comprehensive configuration for NetworkManager,
# the default network management daemon on NixOS. It fine-tunes various
# aspects of network connectivity including DHCP behavior, DNS resolution,
# WiFi scanning, IPv6 handling, and systemd integration.
#
# The settings here are optimized for a desktop environment with a focus on
# faster boot times, reliable DHCP lease acquisition, predictable DNS
# resolution, and minimal network overhead. All configuration is done
# through native NixOS options without relying on external config files
# or NetworkManager dispatcher scripts.
#
# Key design decisions in this configuration:
# - Internal DHCP client (faster and more reliable than dhclient)
# - Static DNS servers as fallback when DHCP-provided DNS is unavailable
# - Extended DHCP timeouts to handle slow or unreliable network links
# - Disabled random MAC address scanning (useful for enterprise WiFi)
# - IPv6 disabled entirely (reduces network stack complexity)
# - Connectivity checking bypassed (improves responsiveness on air-gapped networks)
# - NetworkManager-wait-online disabled (faster boot, no delay for network)

{ config, pkgs, lib, ... }:

{
  # NetworkManager core settings
  # -----------------------------
  # These options configure the NetworkManager daemon itself, including
  # which DHCP backend to use and what log verbosity to enable.
  networking.networkmanager = {
    # Enable the NetworkManager service at boot time
    enable = true;

    # DHCP backend selection
    # "internal" uses NetworkManager's built-in DHCP client which is
    # lightweight, fast, and supports all modern DHCP features. The
    # alternative "dhclient" uses the ISC DHCP client which is heavier
    # and slower to obtain leases but may be needed for exotic setups.
    dhcp = "internal";

    # Raw NetworkManager.conf settings
    # ----------------------------------
    # The `settings` attribute maps directly to NetworkManager.conf
    # sections and key-value pairs. This provides access to advanced
    # options that don't have dedicated NixOS abstractions yet.
    settings = {
      # Connection-level defaults
      # These settings act as default values for all network connections
      # managed by NetworkManager. They can be overridden per-connection
      # using nmcli or the GNOME Settings panel.
      connection = {
        # DHCP timeout in seconds for IPv4
        # Increase from default to handle slow DHCP servers or
        # congested networks without timing out prematurely.
        "ipv4.dhcp-timeout" = 10;

        # DHCP timeout in seconds for IPv6
        # Same rationale as IPv4 - gives more time for DHCPv6
        # handshake on networks with high latency.
        "ipv6.dhcp-timeout" = 10;
      };

      # WiFi scanning configuration
      # When set to false, NetworkManager will not randomize the MAC
      # address during WiFi network scans. This is useful when:
      # - The network uses MAC-based authentication (captive portals, enterprise)
      # - The router has MAC filtering enabled
      # - Network administrator tracks connections by MAC address
      wifi.scan-rand-mac-address = false;

      # Connectivity checking
      # Interval of 0 disables the periodic connectivity check that
      # NetworkManager performs by pinging a known web server. This
      # is useful for:
      # - Offline/air-gapped machines
      # - Reducing background network traffic
      # - Privacy (no periodic requests to canonical servers)
      connectivity.interval = 0;
    };

    # NetworkManager log verbosity
    # "INFO" provides essential operational messages without being
    # too verbose. Available levels: OFF, ERR, WARN, INFO, DEBUG, TRACE.
    logLevel = "INFO";
  };

  # Global DNS name servers
  # ------------------------
  # These DNS servers are written to /etc/resolv.conf and used as
  # fallback resolvers when NetworkManager does not provide DNS
  # via DHCP or manual configuration.
  # Yandex DNS (77.88.8.8) - fast and reliable, hosted in Russia
  # Google DNS (8.8.8.8) - globally available fallback
  networking.nameservers = [ "77.88.8.8" "8.8.8.8" ];

  # IPv6 support
  # -------------
  # Disable IPv6 entirely at the kernel level via sysctl. This means:
  # - IPv6 addresses will not be assigned to any interface
  # - IPv6 DNS queries (AAAA records) will not be performed
  # - All traffic uses IPv4 exclusively
  # This is useful when IPv6 is not supported by the ISP or network,
  # or when dual-stack complexity is undesirable.
  networking.enableIPv6 = false;

  # Systemd service configuration
  # ------------------------------
  # NetworkManager-wait-online is a systemd service that blocks the
  # boot process until NetworkManager reports network connectivity.
  # Disabling it allows the system to finish booting even without
  # network access, which is desirable on:
  # - Desktop/laptop machines (user can connect after login)
  # - Systems with slow or intermittent network links
  # - Offline use cases
  systemd.services.NetworkManager-wait-online.enable = false;
}
