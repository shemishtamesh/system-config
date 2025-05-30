{ inputs, pkgs, ... }:
{
  # home.packages = with pkgs; [ discord ];
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    discord.autoscroll.enable = true;
    config = {
      frameless = true;
      disableMinSize = true;
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
        # mutualGroupDMs.enable = true;
        noUnblockToJump.enable = true;
        permissionsViewer.enable = true;
        pinDMs.enable = true;
        previewMessage.enable = true;
        relationshipNotifier.enable = true;
        revealAllSpoilers.enable = true;
        serverInfo.enable = true;
        showHiddenChannels.enable = true;
        showHiddenThings.enable = true;
        silentTyping.enable = true;
        typingIndicator.enable = true;
        unlockedAvatarZoom.enable = true;
        userVoiceShow.enable = true;
        vencordToolbox.enable = true;
        viewRaw.enable = true;
        voiceDownload.enable = true;
        voiceMessages.enable = true;
        volumeBooster.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
