{ openrouterKeyEnvVar }:
{
  ollama = {
    baseUrl = "http://localhost:11434/v1";
    api = "openai-completions";
    apiKey = "ollama";
    models = {
      "ornith:latest" = { };
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
    api = "openai-completions";
    apiKey = "$OPENROUTER_API_KEY";
    apiKeyEnvVar = openrouterKeyEnvVar;
  };

  groq = {
    baseUrl = "https://api.groq.com/openai/v1";
    api = "openai-completions";
    apiKey = "$GROQ_API_KEY";
    models = [
      {
        id = "openai/gpt-oss-120b";
        reasoning = true;
      }
      {
        id = "openai/gpt-oss-20b";
        reasoning = true;
      }
      {
        id = "groq/compound";
        reasoning = true;
      }
      {
        id = "groq/compound-mini";
        reasoning = true;
      }
    ];
  };

  kilo = {
    baseUrl = "https://api.kilo.ai/api/gateway";
    api = "openai-completions";
    apiKey = "$KILO_API_KEY";
    compat.thinkingFormat = "openrouter";
    models = [
      {
        id = "kilo-auto/free";
        reasoning = true;
      }
    ];
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
