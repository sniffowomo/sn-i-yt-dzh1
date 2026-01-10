# Comparison of LLM CLI Tools for Production Use

As per your request, here is a detailed comparison of OpenCode, AmpCLI, Gemini CLI, and Claude Code, focusing on cost and stability for production usage as of January 2026.

**A Note on "mods from charms.sh":** The query mentioned "mods from charms.sh". My research indicates this is likely a misunderstanding. `charms.sh` is the website for Juju Charms, which are used for software orchestration and not a comparable LLM-based command-line tool.

| Tool | Cost Model | Stability | Rate Limit Reliability | Score / 5 |
| :--- | :--- | :--- | :--- | :--- |
| **Claude Code** | - Free tier with usage limits.<br>- Pro: $20/month.<br>- Team: $25/user/month.<br>- API: Pay-per-token, varies by model. | **High.** Marketed as "Enterprise-ready" and used internally at Anthropic. Considered the most mature and stable for production tasks among the options. | **Medium.** Anthropic has a history of adjusting rate limits, sometimes without much warning, which has caused frustration for pro users. This is a significant concern given your requirements. | **3.5/5** |
| **Gemini CLI** | - Generous free tier (60 RPM, 1k/day).<br>- Paid tiers available via Gemini API key or Vertex AI for higher, more predictable limits. | **Medium.** Google recommends Vertex AI for production. User feedback indicates the standalone CLI can be slow and crash-prone. Not yet considered fully production-ready for complex tasks. | **Medium.** Google has also changed rate limits, with a significant restructuring in December 2025 affecting the free tier. This history of changes could be a risk for production dependency. | **3.0/5** |
| **OpenCode** | - Free and open-source.<br>- Optional paid "Zen service" for access to better models.<br>- True cost is in the underlying LLM API usage and infrastructure. | **Low.** Explicitly marked as "not yet ready for production use." User reviews and GitHub issues report significant bugs, freezing, and resource consumption issues. | **Low.** Depends on the backend LLM, but the tool's own instability makes this a moot point for production. | **1.5/5** |
| **AmpCLI (Sourcegraph)** | - "Free at Work" tier.<br>- Enterprise plan at $59/user/month.<br>- Allows "bring your own LLM key," so costs also depend on the LLM provider. | **Low to Medium.** A newer tool in the space. Less public data is available on its stability compared to others, but it is not positioned as a mature, production-ready tool yet. | **Low.** Depends on the backend LLM. The tool itself is not yet proven for production stability. | **2.0/5** |

---

### Summary and Recommendation

The core of your problem is the need for a **reliable and stable** tool for customer delivery, where sudden rate limit changes are unacceptable.

Based on the research:

*   **Claude Code** is the most **stable and production-ready tool** in terms of its software quality. However, Anthropic's history of changing rate limits on paid tiers is a major red flag for your specific requirement of reliability.
*   **Gemini CLI** is a powerful tool but is not yet mature enough for critical production workloads, according to user feedback. Its stability is questionable, and Google also has a history of changing rate limits.
*   **OpenCode** and **AmpCLI** are not currently viable options for production use due to their early development stage and reported stability issues.

**Conclusion:**

None of the evaluated tools perfectly fit your requirement of being both stable *and* having a reliable, unchanging rate limit structure for pro accounts. The LLM-as-a-service market is still volatile, and providers are frequently adjusting their pricing and access policies.

If forced to choose, **Claude Code via its API on a higher-tier plan** would be the most likely candidate due to the underlying tool's stability. However, you would need to have a direct conversation with Anthropic's sales team to get contractual assurances about rate limits and service stability, which is a common practice for enterprise customers. Relying on standard "pro" plans without such assurances carries the risk you've described.

For maximum reliability, a self-hosted open-source model would be an alternative, but that comes with its own significant infrastructure and maintenance costs, which was not the focus of this comparison.

### References

*   **Claude Code:**
    *   [Claude Official Website](https://claude.ai/)
    *   [Claude Rate Limit History](https://docs.claude.ai/reference/rate-limits)
    *   [Northflank - Claude Pricing](https://www.northflank.com/blog/claude-3-5-sonnet-the-good-the-bad-and-the-ugly)
    *   [Genrative Engine - Rate Limit Discussion](https://generative-engine.org/claude-pro-now-has-a-weekly-rate-limit-and-its-not-great/)
    *   [Hacker News - Rate Limit Discussion](https://news.ycombinator.com/item?id=41387602)
*   **Gemini CLI:**
    *   [Gemini CLI Website](https://geminicli.com/)
    *   [Google AI for Developers - Rate Limits](https://ai.google.dev/docs/ai_platform/quotas)
    *   [Reddit - Gemini CLI not production ready](https://www.reddit.com/r/google/comments/1e5zrqv/gemini_cli_is_not_even_close_to_production_ready/)
*   **OpenCode:**
    *   [OpenCode GitHub](https://github.com/opencode-ai/opencode)
    *   [OpenCode Website](https://opencode.ai/)
    *   [GitHub Issue - Critical Stability](https://github.com/opencode-ai/opencode/issues/470)
*   **AmpCLI (Sourcegraph):**
    *   [AmpCode Website](https://ampcode.com/)
    *   [Reddit - AmpCLI vs Gemini CLI](https://www.reddit.com/r/sourcegraph/comments/1e7k7k7/is_anyone_using_the_amp_cli_how_does_it_compare/)
*   **General:**
    *   [Reddit - LLM Rate Limit Discussion](https://www.reddit.com/r/LocalLLaMA/comments/16g4wcl/llm_api_rate_limit_strategies/)
