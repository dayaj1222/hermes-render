# Hermes on Render

Run [Hermes Agent](https://github.com/NousResearch/hermes-agent) as a 24/7 Telegram bot on Render's free tier, using a DeepSeek proxy or API.

> ⚠️ Render free tier sleeps after 15 min of inactivity. Use a Render Cron Job to ping `/health` every 10 minutes to keep it alive.

## Your Setup

- **Provider:** `custom` (OpenAI-compatible endpoint)
- **Model:** `deepseek-reasoner`
- **Local proxy:** `http://localhost:8000/v1` (won't work from Render!)

For Render, you need a **publicly reachable** endpoint. Options:
1. **Expose your local proxy** — use ngrok, Cloudflare Tunnel, or Tailscale Funnel
2. **Use DeepSeek API directly** — set `LLM_BASE_URL=https://api.deepseek.com/v1`
3. **Use OpenRouter** — set `LLM_BASE_URL=https://openrouter.ai/api/v1`

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
   - `LLM_BASE_URL` — your publicly reachable proxy URL
   - `LLM_MODEL` — `deepseek-reasoner`
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
| `LLM_BASE_URL` | Yes | Publicly reachable OpenAI-compatible endpoint (not localhost!) |
| `LLM_MODEL` | Yes | Model name (`deepseek-reasoner`) |

If your proxy requires authentication, add the API key env var your proxy expects.

## Exposing Your Local Proxy

Quickest free option — Cloudflare Tunnel:

```bash
# Install
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o ~/.local/bin/cloudflared
chmod +x ~/.local/bin/cloudflared

# Expose your local proxy
cloudflared tunnel --url http://localhost:8000
```

Copy the `*.trycloudflare.com` URL and use it as `LLM_BASE_URL` on Render.

## Ephemeral Storage Warning

Render's free tier has ephemeral storage — all data in `/data/.hermes/` is lost on restart. Your Hermes sessions, memory, and skills will reset each deploy. For persistent storage, add a Render Disk ($1/mo for 1GB).
