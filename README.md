# n8n Workflow Demo

A portable **n8n** automation stack with PostgreSQL — ready to run locally for client demonstrations. Showcases three real-world workflow automation patterns commonly requested on Upwork.

---

## Quick Start

```bash
./setup.sh          # create .env from template
# edit .env with your API keys
docker compose up -d  # start n8n + PostgreSQL
```

Open [http://localhost:5678](http://localhost:5678) — n8n UI loads. Import any workflow from `workflows/`.

---

## Workflows

### 1. Telegram AI Auto-Reply

Receive Telegram messages → generate AI response → reply automatically.

```
  ┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
  │  Telegram     │     │  OpenAI / Claude  │     │  Telegram        │
  │  Trigger      │────▶│  Generate Reply   │────▶│  Send Message    │
  │  (incoming    │     │  GPT-4o-mini      │     │  (reply to user) │
  │   message)    │     │  512 tokens       │     │                  │
  └──────────────┘     └──────────────────┘     └──────────────────┘
```

**Use cases:** Customer support bots, FAQ automation, community management, personal assistant.

**Requires:** `TELEGRAM_BOT_TOKEN`, `OPENAI_API_KEY`

---

### 2. Webhook → Slack / Email Notifier

Receive external webhook → filter by keyword → route to Slack and/or email.

```
                         ┌─────────────────┐
                     ┌──▶│  Send to Slack   │
                     │   │  (#alerts)       │
  ┌──────────────┐   │   └─────────────────┘
  │  Webhook      │───┤
  │  Trigger      │   │   ┌─────────────────┐
  │  POST /notify │   └──▶│  Send Email      │
  └──────────────┘       │  (admin@...)     │
          │               └─────────────────┘
          ▼
  ┌──────────────┐
  │  IF node     │  (checks message contains "urgent")
  └──────────────┘
```

**Use cases:** Alerting pipelines, form submissions, monitoring webhooks, CI/CD notifications.

**Requires:** `SLACK_WEBHOOK_URL`, `SMTP_*` credentials

---

### 3. Scheduled Scraper → Database

Scrape a target URL every hour → parse → store structured data in PostgreSQL.

```
  ┌────────────────┐     ┌────────────────┐     ┌─────────────────┐     ┌──────────────────┐
  │  Cron Trigger   │     │  HTTP Request  │     │  Code Node      │     │  PostgreSQL      │
  │  (every 60 min) │────▶│  GET target    │────▶│  Extract &      │────▶│  INSERT INTO     │
  │                 │     │  URL           │     │  Transform      │     │  scraped_data    │
  └────────────────┘     └────────────────┘     └─────────────────┘     └──────────────────┘
```

**Use cases:** Price monitoring, news aggregation, competitor tracking, inventory scraping.

**Requires:** `SCRAPER_TARGET_URL` (PostgreSQL credentials auto-configured from main stack)

---

## Architecture

```
  ┌─────────────────────────────────────────────────┐
  │                   Host Machine                   │
  │                                                  │
  │   ┌─────────────┐         ┌─────────────┐       │
  │   │  n8n         │◄───────│  Browser     │       │
  │   │  :5678       │  HTTP  │  (n8n UI)    │       │
  │   └──────┬──────┘         └─────────────┘       │
  │          │                                       │
  │          │  internal network                     │
  │          ▼                                       │
  │   ┌─────────────┐                               │
  │   │  PostgreSQL  │                               │
  │   │  :5432       │                               │
  │   └─────────────┘                               │
  └─────────────────────────────────────────────────┘
```

- n8n stores workflow definitions and execution data in PostgreSQL.
- Workflow JSON files can be imported manually via the n8n UI.
- All credentials are managed via `.env` — never committed.

---

## Importing Workflows

1. Open n8n UI at [http://localhost:5678](http://localhost:5678).
2. Click **Workflows** → **Import from File**.
3. Select a `.json` file from `workflows/`.
4. Configure credentials (click the credential icon on each node).
5. **Activate** the workflow to start receiving events.

---

## Environment Variables

| Variable | Description |
|---|---|
| `N8N_ENCRYPTION_KEY` | n8n encryption key (64-char random string) |
| `POSTGRES_USER` | PostgreSQL username |
| `POSTGRES_PASSWORD` | PostgreSQL password |
| `POSTGRES_DB` | PostgreSQL database name |
| `TELEGRAM_BOT_TOKEN` | Bot token from BotFather |
| `OPENAI_API_KEY` | OpenAI API key |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook URL |
| `SMTP_HOST` / `SMTP_PORT` | SMTP server for email sending |
| `SMTP_USER` / `SMTP_PASS` | SMTP credentials |
| `SCRAPER_TARGET_URL` | Target URL for scraper workflow |

---

## Project Structure

```
n8n-workflow-demo/
├── docker-compose.yml         # n8n + PostgreSQL stack
├── .env.example               # Environment variable template
├── .gitignore
├── setup.sh                   # First-run setup script
├── README.md                  # This file
└── workflows/
    ├── telegram-ai-auto-reply.json
    ├── webhook-slack-email-notifier.json
    └── scheduled-scraper-database.json
```

---

## References

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

## License

MIT — free to use, modify, and present to clients.
