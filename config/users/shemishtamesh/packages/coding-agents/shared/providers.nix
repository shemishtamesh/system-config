{ openrouterKeyEnvVar }:
{
  ollama = {
    baseUrl = "http://localhost:11434/v1";
    models = {
      qwen3-coder = { };
      ornith = {
        supportsThinking = true;
      };
      "gemma4:26b" = {
        supportsThinking = true;
      };
    };
  };

  openrouter = {
    baseUrl = "https://openrouter.ai/api/v1";
    apiKeyEnvVar = openrouterKeyEnvVar;
    models = {
      "google/gemma-4-26b-it" = { };
    };
  };

  opencode = {
    apiKeyEnvVar = "OPENCODE_API_KEY";
    models = {
      "big-pickle" = {
        supportsThinking = true;
        contextWindow = 200000;
        maxTokens = 32000;
        cost = {
          input = 0;
          output = 0;
          cacheRead = 0;
          cacheWrite = 0;
        };
      };
    };
  };
}
