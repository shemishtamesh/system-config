{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    discord.autoscroll.enable = true;
    config = {
      frameless = true;
      enableReactDevtools = true;
      plugins = {
        callTimer.enable = true;
        copyFileContents.enable = true;
        fullUserInChatbox.enable = true;
        iLoveSpam.enable = true;
        imageZoom.enable = true;
        implicitRelationships.enable = true;
        mentionAvatars.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        mutualGroupDMs.enable = true;
        noUnblockToJump.enable = true;
        oneko.enable = true;
        #   hideAttachments.enable = true; # Enable a Vencord plugin
        #   ignoreActivities = {
        #     # Enable a plugin and set some options
        #     enable = true;
        #     ignorePlaying = true;
        #     ignoreWatching = true;
        #     ignoredActivities = [ "someActivity" ];
        #   };
      };
      # extraConfig = {
      #   # Some extra JSON config here
      #   # ...
      # };
    };
  };
}
