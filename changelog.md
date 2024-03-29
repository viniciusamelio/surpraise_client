# 2.0.1
## Fixed
- Bug no selecionador de imagens

# 2.0.0
## Added
- New praise flow
- Multi praised praises
- Praise reactions
- Praise animations
- Auto filling community according to last praise sent

# 1.2.6
## Added
- Slack auth

# 1.2.5
## Added
- Sentry
- private praise

## Removed
- Embrace sdk

# 1.2.4
## Added
- new member selection on praise flow

# 1.2.3
## Changed
- more meaningful praise reasons
## Added
- praises feed refresh 

# 1.2.2
## Added
- notificator call through SDK instead of http call

## Fixed
- multiple "first-time" feed loading
- multiple new praise reaction
- project name on settings screen

# 1.2.1
## Added
- protection against rooted/jailbroken devices

# 1.2.0
## Added
- authentication with github & discord

# 1.1.0
## Changed
- changed supabase edge functions call to sdk itself
- removed password attribute from user dto
- removed AuthService.signIn() on auto-login
## Added
- domain components instead repositories
    - community management
        - invite members & leave community
    - invite
        - answer invites
## Fixed
- missing blank space on received praises card text

# 1.0.2
## Fixed
- friendly auth error messages
## Added
- received praises infinite scroll pagination
- community management
- account deletion
- password recovery
## Changed
- praises dropdown position