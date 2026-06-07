# The Falhaezrian Isles

Player-safe Quartz site for The Falhaezrian Isles campaign setting.

This repository is meant to contain only player-safe notes. Do not commit GM/private vault material here.

## Requirements

- Windows 11 PowerShell
- Git for Windows
- Node.js 22 LTS or newer, which includes npm
- A free GitHub account

## Preview Locally

Open PowerShell in this folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-and-preview-site.ps1
```

Then open:

```text
http://localhost:8080
```

## Build Locally

```powershell
powershell -ExecutionPolicy Bypass -File .\build-site.ps1
```

The generated static website will be in:

```text
public
```

## Publish on GitHub Pages

1. Create a new GitHub repository.
2. Push this player-safe vault folder to that repository.
3. Make sure the branch is named `main`.
4. In GitHub, open repository settings.
5. Go to **Pages**.
6. Under **Build and deployment**, choose **GitHub Actions**.
7. Push to `main`.
8. Open the **Actions** tab and wait for the deploy workflow to finish.

The final website URL appears in the workflow summary and in **Settings > Pages**. It is usually:

```text
https://YOUR-USERNAME.github.io/YOUR-REPOSITORY/
```

## How This Works

The notes stay in normal Obsidian-style Markdown. The helper scripts clone Quartz into `_quartz`, copy `quartz.config.ts` and `quartz.layout.ts` into that local Quartz folder, then build this vault as the content source.

Quartz supports Obsidian-style wikilinks such as:

```markdown
[[Sentra]]
[[House of Béorn]]
[[Some Note|display text]]
![[image.png]]
```

## Troubleshooting

### Wikilinks Not Resolving

Make sure the linked note exists in this player-safe vault. If there are duplicate note names, Quartz may not resolve the link you expect. Prefer unique note names for public notes.

### Images Not Showing

Make sure the image file is inside this repository and the embed still points to it. Quartz supports common image embeds, but missing attachments cannot be displayed.

### GitHub Pages Not Deploying

Check the **Actions** tab for the failing step. Also verify **Settings > Pages > Build and deployment** is set to **GitHub Actions**.

### Node.js Not Installed

Install Node.js 22 LTS or newer from:

```text
https://nodejs.org/
```

Close and reopen PowerShell after installing it.

### Repository Uses master Instead of main

Either rename the branch to `main`, or edit `.github/workflows/deploy.yml` and change:

```yaml
branches: ["main"]
```

to:

```yaml
branches: ["master"]
```

### Accidental Private Notes Appearing

Stop and remove the repository or make it private until fixed. Regenerate the player-safe vault from the safe export script before publishing again.
