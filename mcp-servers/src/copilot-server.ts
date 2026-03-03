import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { runCopilot, toolSchema, toolAnnotations, getConfig } from "./helpers.js";

const server = new McpServer({ name: "quorum-copilot", version: "1.0.0" });

server.tool(
  "copilot_query",
  "Send a read-only prompt to GitHub Copilot CLI (ACP mode with plain fallback) and return the structured result",
  toolSchema,
  toolAnnotations,
  async ({ prompt, workdir }) => {
    const config = await getConfig(workdir || process.cwd());
    return runCopilot(prompt, workdir, config.timeout_ms);
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
