# Hermes on Render (with DeepSeek Proxy)

Run [Hermes Agent](https://github.com/NousResearch/hermes-agent) as a 24/7 Telegram bot on Render's free tier.

The container bundles:
- **DeepSeek proxy** (`localhost:8000/v1`) — translates OpenAI-format requests to DeepSeek API via `aiodeepseek`
- **Hermes gateway** — connects to the local proxy, reachable via Telegram

> Render free tier sleeps after 15 min of inactivity. Use a Render Cron Job to ping every 10 minutes.

## Quick Deploy

### 1. Create a Telegram Bot

1. Chat with [@BotFather](https://t.me/BotFather) on Telegram
2. Send `/newbot`, pick a name and username
3. Copy the bot token

### 2. Deploy on Render

1. Fork/push this repo to GitHub
2. Go to [Render Dashboard](https://dashboard.render.com)
3. **New + -> Web Service** -> connect your repo
4. Settings:
   - **Runtime:** Docker
   - **Instance Type:** Free
   - **Health Check Path:** `/`
5. Add environment variables (see `.env.example`):
   - `TELEGRAM_BOT_TOKEN`
   - `DEEPSEEK_EMAIL`
   - `DEEPSEEK_PASSWORD`
   - `DEEPSEEK_TOKEN` (if you have one)
6. Click **Deploy Web Service**

### 3. Keep It Awake (Anti-Sleep)

1. **Cron Jobs -> New Cron Job** -> same repo
2. Command: `curl -s https://YOUR-SERVICE.onrender.com/`
3. Schedule: `*/10 * * * *`
4. Instance: Free

### 4. Chat with Your Bot

Open Telegram, search your bot's username, send a message.

## How It Works

```
Telegram -> Render (Hermes gateway)
              |
         localhost:8000/v1 (DeepSeek proxy)
              |
         DeepSeek API (via aiodeepseek)
```

The proxy handles OpenAI tool-calling format translation, streaming, and conversation threading.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Yes | Telegram bot token from @BotFather |
| `DEEPSEEK_EMAIL` | Yes | DeepSeek account email |
| `DEEPSEEK_PASSWORD` | Yes | DeepSeek account password |
| `DEEPSEEK_TOKEN` | No | Alternative to email+password |
| `MODEL_TYPE` | No | DeepSeek model type (default: DEFAULT) |
| `REQUEST_DELAY` | No | Seconds to wait before API calls (default: 0) |

## Files

```
hermes-render/
  Dockerfile           # Python 3.13 + proxy deps + Hermes
  start.sh             # Health server -> proxy -> Hermes gateway
  deepseek-proxy/      # FastAPI proxy (main.py, config.py, etc.)
  .env.example         # Template for env vars
  README.md
```

## Ephemeral Storage Warning

Free Render has ephemeral storage — `session_state.json` and Hermes sessions/skills/memory reset on restart. Add a Render Disk ($1/mo for 1GB) for persistence.
