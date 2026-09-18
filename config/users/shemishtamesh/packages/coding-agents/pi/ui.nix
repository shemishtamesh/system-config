{ palette }:
{
  keybindings = {
    "tui.select.confirm" = [
      "enter"
      "ctrl+y"
    ];
    "tui.select.up" = [
      "up"
      "ctrl+k"
    ];
    "tui.select.down" = [
      "down"
      "ctrl+j"
    ];
    "tui.editor.cursorUp" = [
      "up"
      "ctrl+k"
    ];
    "tui.editor.cursorDown" = [
      "down"
      "ctrl+j"
    ];
    "tui.editor.cursorLeft" = [
      "left"
      "ctrl+h"
    ];
    "tui.editor.cursorRight" = [
      "right"
      "ctrl+l"
    ];
  };

  theme = {
    name = "stylix";
    colors = {
      accent = palette.base0D;
      border = palette.base03;
      borderAccent = palette.base0D;
      borderMuted = palette.base01;
      success = palette.base0B;
      error = palette.base08;
      warning = palette.base0A;
      muted = palette.base04;
      dim = palette.base02;
      text = palette.base06;
      thinkingText = palette.base03;
      selectedBg = palette.base02;
      scrollbarThumb = palette.base03;
      searchMatchBg = palette.base0A;
      searchMatchText = palette.base00;
      userMessageBg = palette.base01;
      userMessageText = palette.base05;
      customMessageBg = palette.base01;
      customMessageText = palette.base05;
      customMessageLabel = palette.base0E;
      toolPendingBg = palette.base01;
      toolSuccessBg = palette.base01;
      toolErrorBg = palette.base02;
      toolTitle = palette.base0D;
      toolOutput = palette.base04;
      mdHeading = palette.base0D;
      mdLink = palette.base0D;
      mdLinkUrl = palette.base0C;
      mdCode = palette.base0B;
      mdCodeBlock = palette.base05;
      mdCodeBlockBorder = palette.base03;
      mdQuote = palette.base04;
      mdQuoteBorder = palette.base03;
      mdHr = palette.base03;
      mdListBullet = palette.base0A;
      toolDiffAdded = palette.base0B;
      toolDiffRemoved = palette.base08;
      toolDiffContext = palette.base04;
      syntaxComment = palette.base03;
      syntaxKeyword = palette.base0E;
      syntaxFunction = palette.base0D;
      syntaxVariable = palette.base08;
      syntaxString = palette.base0B;
      syntaxNumber = palette.base09;
      syntaxType = palette.base0A;
      syntaxOperator = palette.base05;
      syntaxPunctuation = palette.base05;
      thinkingOff = palette.base03;
      thinkingMinimal = palette.base0C;
      thinkingLow = palette.base0B;
      thinkingMedium = palette.base0A;
      thinkingHigh = palette.base09;
      thinkingXhigh = palette.base08;
      thinkingMax = palette.base0E;
      bashMode = palette.base0E;
    };
  };
}
