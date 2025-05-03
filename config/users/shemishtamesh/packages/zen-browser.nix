{
  pkgs,
  inputs,
  host,
  ...
}:
if (host.system == "x86_64-linux") || (host.system == "aarch64-linux") then
  {
    imports = [ inputs.zen-browser.homeModules.twilight ];
    programs.zen-browser = {
      enable = true;
      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
    };
  }
else
  {
    home.programs = [
      (inputs.zen-browser.packages."${host.system}".default)
    ];
  }
