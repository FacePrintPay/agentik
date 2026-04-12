# Deployment

<<<<<<< HEAD
## Termux
- Install dependencies: pkg install git gh python
- Authenticate: gh auth login
- Ship: ./scripts/ship-agentik.sh

## Web UI
Open: product/web/index.html

## Notes
- Keep repo local-first.
- Do not commit caches, secrets, or nested repos.
=======
## Termux (Local)
- Ensure `gh` is authenticated: `gh auth status`
- Run: `./ship-agentik.sh`

## Vercel
- Import the repo
- Root Directory: `product/web`
>>>>>>> origin/main
