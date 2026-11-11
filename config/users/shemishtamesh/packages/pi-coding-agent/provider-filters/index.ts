import { getBuiltinModels } from '@earendil-works/pi-ai/providers/all';
import type {
    ExtensionAPI,
    ProviderModelConfig,
} from '@earendil-works/pi-coding-agent';

type CatalogModel = {
    id: string;
    name?: string;
    status?: string;
    reasoning?: boolean;
    input?: unknown[];
    cost?: { input?: number; output?: number; cacheRead?: number; cacheWrite?: number };
    contextWindow?: number;
    maxTokens?: number;
};

function toProviderModelConfig(m: CatalogModel): ProviderModelConfig {
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
}

const openrouterModels: ProviderModelConfig[] = getBuiltinModels('openrouter')
    .filter((m) => m.cost?.input === 0 && m.cost?.output === 0)
    .map(toProviderModelConfig);

export default function (pi: ExtensionAPI): void {
    pi.registerProvider('opencode', { models: [] });
    pi.registerProvider('opencode-go', { models: [] });

    pi.registerProvider('openrouter', { models: openrouterModels });
}
