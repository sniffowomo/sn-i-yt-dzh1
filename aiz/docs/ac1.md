# Agentic CLI Tools: A Comparative Analysis

This document provides a concise comparison of several agentic CLI tools, focusing on high-impact differences in pricing and production usage as of January 2026. All information is sourced from publicly available documents and articles.

## OpenCode

**Pricing:**
*   OpenCode is an open-source tool and is free to use [1, 2].
*   Costs are associated with the underlying AI models (e.g., Claude, GPT, Gemini) that the user integrates with the tool [2].

**Production Usage:**
*   It is used by over 650,000 developers monthly and has a large open-source community [2].
*   The tool is described as "privacy-first," as it does not store user code or context, making it suitable for sensitive environments [2].
*   However, the official GitHub repository has an "Early Development Notice," stating that the tool is "not yet ready for production use" [5].

## Droids

**Pricing:**
*   Droid CLI is free when using your own API keys for models or when using local models [1, 2].
*   The creating company, Factory.ai, offers paid plans for "Factory Standard Tokens," starting from $20 for 10 million tokens [3].

**Production Usage:**
*   Droid CLI is designed to generate "production-ready code that you can deploy right away" [1].
*   It is used for complex, real-world software engineering tasks, including building entire SaaS applications [1, 4].
*   The tool supports long-running processes and can be integrated into CI/CD pipelines [6, 7].

## AMP CLI

**Pricing:**
*   Amp offers a free tier supported by advertisements, with a daily allowance of $10 in credits [1, 4].
*   The paid usage model is $10 per day for access to all modes and models [1].
*   An "Enterprise" solution is available for large organizations with custom pricing [7].

**Production Usage:**
*   Amp is an AI coding agent from Sourcegraph, designed for autonomous reasoning and complex tasks [7].
*   It can be used via its CLI or as a VS Code extension and supports other IDEs [7, 8].
*   Key features include agentic code review, interactive diagrams, and automation of development workflows [9].
*   Amp CLI commands can be integrated into Git hooks or CI/CD pipelines [10].

## Gemini CLI

**Pricing:**
*   Pricing for Gemini models is based on static data, with rates defined per 1,000 tokens in USD for models like "gemini-pro" and "gemini-1.5-pro".

**Production Usage:**
*   Gemini models can automatically invoke agentic tools like `GoogleSearchTool`.
*   Production usage is tracked through a `Usage` class that records metrics such as tokens and requests, which can be stored in a database.

## Claude code

**Pricing:**
*   **Claude Pro:** $20/month for enhanced usage limits and access to Claude Code [3, 4, 5].
*   **Claude Team Plan:** $25/person/month (billed annually) with a minimum of five members [4, 5].
*   **API Usage (Pay-as-you-go):** Access through Anthropic's API or cloud providers like AWS Bedrock and Google Cloud Vertex AI, with pricing per million tokens (e.g., Claude 3.5 Sonnet is $3.00/million input tokens and $15.00/million output tokens) [3, 6, 7].

**Production Usage:**
*   Claude Code is a CLI tool for agentic coding designed for complex, multi-step reasoning tasks, including code analysis, generation, and verification [11].
*   The tool can be used directly in the terminal or integrated into an IDE and leverages the shell environment for customization [10, 9].
*   Claude models are available on Google Cloud's Vertex AI, offering fully managed and serverless API access for production environments [14].

## Mods

The search did not yield a specific, widely recognized agentic CLI tool named "Mods." The term appears to be used more generally in the context of modifications or modules for other tools.

# Summary: Which Platform to Use with Clients Today?

Based on the research, the following platforms appear ready for production use with clients:

*   **Droids:** Explicitly marketed as generating "production-ready code" and is used for building complex applications. The free tier with user-provided keys makes it an attractive option for client work.
*   **AMP CLI:** Developed by Sourcegraph, a reputable company, Amp is designed for professional development workflows and team collaboration. Its integration capabilities and enterprise options suggest it is ready for client projects.
*   **Claude code:** Backed by Anthropic and available through major cloud providers, Claude Code is designed for complex, agentic workflows. The availability of team and enterprise plans, along with detailed API pricing, indicates its suitability for professional and client-based work.
*   **Gemini CLI:** As a Google product, Gemini and its associated tools are built for production environments. The clear pricing structure and usage tracking capabilities make it a reliable choice for client projects.

**OpenCode**, despite its large user base, is still in early development according to its official repository, which may pose a risk for production client work.

# References

[1] youtube.com (Droid)
[2] factory.ai (Droid)
[3] factory.ai (Droid Pricing)
[4] aimind.so (Droid)
[5] github.com (OpenCode)
[6] factory.ai (Droid)
[7] factory.ai (Droid)
[8] ampcode.com
[9] slashdot.org (Amp)
[10] dev.to (Amp)
[11] ikangai.com (Claude)
[12] infoq.com (Claude)
[13] dev.to (Claude)
[14] google.com (Claude on Vertex AI)
[15] claude.com (Claude on Vertex AI)

*Note: Some references from the initial search were generic and have been omitted for clarity. The numbering in this reference list is for this document and does not correspond to the search result numbering.*
