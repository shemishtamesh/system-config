import {
    type Api,
    type AssistantMessageEventStream,
    type Context,
    type Model,
    type SimpleStreamOptions,
} from '@earendil-works/pi-ai';
import {
    anthropicMessagesApi,
    googleGenerativeAIApi,
    openAICompletionsApi,
    openAIResponsesApi,
} from '@earendil-works/pi-ai/compat';
import { getBuiltinModels } from '@earendil-works/pi-ai/providers/all';
import type {
    ExtensionAPI,
    ProviderModelConfig,
} from '@earendil-works/pi-coding-agent';
import { createHash, randomUUID } from 'node:crypto';

const BASE_URL = 'https://opencode.ai/zen/v1';

const zenModels: ProviderModelConfig[] = getBuiltinModels('opencode')
    .filter((m) => (m as { status?: string }).status !== 'deprecated')
    .filter((m) => m.cost?.input === 0)
    .map((m) => {
        const input = (m.input ?? []).filter(
            (value): value is 'text' | 'image' => value === 'text' || value === 'image',
        );
        return {
            id: m.id,
            name: m.name ?? m.id,
            reasoning: m.reasoning ?? false,
            input,
            cost: m.cost ? { ...m.cost } : undefined,
            contextWindow: m.contextWindow,
            maxTokens: m.maxTokens,
        };
    });

const zenSessionId = randomUUID().replace(/-/g, '').slice(0, 26);
const zenProjectId = createHash('sha256').update(process.cwd()).digest('hex').slice(0, 26);

const zenClientHeaders: Record<string, string> = {
    'User-Agent': 'opencode/latest/1.3.15/cli',
    'x-opencode-client': 'cli',
    'x-opencode-session': zenSessionId,
    'x-opencode-project': zenProjectId,
};

function opencodeHeaders(): Record<string, string> {
    return {
        ...zenClientHeaders,
        'x-opencode-request': randomUUID().replace(/-/g, '').slice(0, 26),
    };
}

function streamOpencodeZen(
    model: Model<Api>,
    context: Context,
    options?: SimpleStreamOptions,
): AssistantMessageEventStream {
    const wrappedModel = {
        ...model,
        baseUrl: BASE_URL,
    } as Model<Api>;
    const zenToken = process.env.OPENCODE_API_KEY?.trim();
    const wrappedOptions: SimpleStreamOptions = {
        ...options,
        headers: zenToken
            ? { ...options?.headers, ...opencodeHeaders(), Authorization: `Bearer ${zenToken}` }
            : { ...options?.headers, ...opencodeHeaders(), Authorization: null as unknown as string },
    };
    switch (model.api) {
        case 'anthropic-messages':
            return anthropicMessagesApi().streamSimple(wrappedModel, context, wrappedOptions);
        case 'google-generative-ai':
            return googleGenerativeAIApi().streamSimple(wrappedModel, context, wrappedOptions);
        case 'openai-responses':
            return openAIResponsesApi().streamSimple(wrappedModel, context, wrappedOptions);
        default:
            return openAICompletionsApi().streamSimple(wrappedModel, context, wrappedOptions);
    }
}

export default function (pi: ExtensionAPI): void {
    pi.registerProvider('opencode-zen', {
        name: 'OpenCode Zen',
        baseUrl: BASE_URL,
        // placeholder the real authorization is decided per request
        apiKey: 'none',
        api: 'openai-completions',
        headers: { ...zenClientHeaders },
        streamSimple: streamOpencodeZen,
        models: zenModels,
    });
}
