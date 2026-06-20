# Hermes on Render

Run [Hermes Agent](https://github.com/NousResearch/hermes-agent) as a 24/7 Telegram bot on Render's free tier.

> ⚠️ Render free tier sleeps after 15 min of inactivity. Use a Render Cron Job to ping `/health` every 10 minutes to keep it alive.

## Quick Deploy

### 1. Create a Telegram Bot

1. Open Telegram and chat with [@BotFather](https://t.me/BotFather)
2. Send `/newbot` and follow the prompts
3. Copy the bot token (looks like `123456:ABC-DEF1234ghikl...`)

### 2. Deploy on Render

1. Fork/push this repo to your GitHub
2. Go to [Render Dashboard](https://dashboard.render.com)
3. Click **New +** → **Web Service**
4. Connect your GitHub repo
5. Settings:
   - **Runtime:** Docker
   - **Instance Type:** Free
   - **Health Check Path:** `/`
6. Add environment variables:
   - `TELEGRAM_BOT_TOKEN` — your bot token from step 1
   - `LLM_BASE_URL` — your LLM API endpoint
   - `LLM_API_KEY` — your LLM API key
   - `LLM_MODEL` — model name (e.g., `deepseek-chat`)
7. Click **Deploy Web Service**

### 3. Keep It Awake (Anti-Sleep)

1. On Render, go to **Cron Jobs** → **New Cron Job**
2. Connect the same repo
3. Command: `curl -s https://YOUR-SERVICE.onrender.com/`
4. Schedule: `*/10 * * * *` (every 10 minutes)
5. Instance Type: Free

### 4. Chat with Your Bot

Open Telegram, search for your bot's username, and start chatting!

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token from @BotFather |
| `LLM_BASE_URL` | Yes | OpenAI-compatible API base URL |
| `LLM_API_KEY` | Yes | API key for your LLM provider |
| `LLM_MODEL` | Yes | Model name (e.g., `deepseek-chat`, `gpt-4o`) |

See `.env.example` for provider-specific examples.

## Using a Different Platform

To use Discord/Slack/WhatsApp instead of Telegram, edit `start.sh` and change the gateway config section + add the appropriate env vars.

## Ephemeral Storage Warning

Render's free tier has ephemeral storage — all data in `/data/.hermes/` is lost on restart. Your Hermes sessions, memory, and skills will reset each deploy. For persistent storage, add a Render Disk ($1/mo for 1GB).
