{
  programs.pi-coding-agent = {
    enable = true;

    settings = {
      defaultProvider = "ollama";
      defaultModel = "qwen3-coder";
      defaultThinkingLevel = "medium";
      theme = "dark";
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      collapseChangelog = true;
    };

    models = {
      providers = {
        ollama = {
          baseUrl = "http://localhost:11434/v1";
          api = "openai-completions";
          apiKey = "ollama";
          models = [
            { id = "qwen3-coder"; }
            {
              id = "gemma4:26b";
              reasoning = true;
            }
          ];
        };
        openrouter = {
          baseUrl = "https://openrouter.ai/api/v1";
          api = "openai-completions";
          models = [
            { id = "google/gemma-4-26b-it"; }
          ];
        };
      };
    };
  };
}
