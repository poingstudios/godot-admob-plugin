# Agent skills (Beta)

Agent skills are portable, self-contained instruction sets that help AI coding assistants (such as Antigravity, Claude Code, and Cursor) understand the Godot AdMob Editor Plugin APIs, conventions, and patterns with higher accuracy.

Rather than overloading an AI's system prompt with information about every platform, agent skills leverage progressive disclosure. This allows the AI assistant to only load the instructions and resources it needs to execute your specific task.

---

## Install the skills

You can install the pre-built AdMob agent skills directly into your Godot project using the editor:

1. Open your Godot project.
2. In the top editor menu, click on **Project > Tools > AdMob Manager**.
3. Select the **AI Copilot** tab.
4. Click **Install AI Skills to Project**.

This will automatically create a `.skills/` folder at the root of your project directory and place the available skills inside it.

!!! note
    Files or folders starting with a dot (like `.skills`) are hidden in Godot's FileSystem dock by default, but they are fully visible to external IDEs and AI coding assistants.

### Update the skills
To ensure your AI assistant has access to the latest features and best practices, keep your skills updated. To update, open the AdMob Manager in the Godot Editor and click **Install AI Skills to Project** again to overwrite the folder with the latest files.

---

## Invoke the skills
Once the skills are installed in your project repository, your AI assistant will automatically index and detect them. You do not need to explicitly use the `@` symbol in your prompt; the assistant will reference the skill context automatically when you ask questions about AdMob.

If you want to manually force the assistant to use a specific skill, you can reference it by typing `@` followed by the name, for example:
`@godot-admob-banner`

---

## View available skills

The following table describes all available skills for Godot AdMob Editor Plugin features:

| Skill | Description |
| :--- | :--- |
| `godot-admob-get-started` | Assists with initializing the Google Mobile Ads SDK, setting request configurations, and configuring the User Messaging Platform (UMP) consent flow. |
| `godot-admob-banner` | Assists with implementing banner ads (`AdView`), choosing ad sizes, and setting up collapsible banners. |
| `godot-admob-interstitial` | Assists with implementing full-screen interstitial ads, loading ads, and setting up dismiss callbacks. |
| `godot-admob-rewarded` | Assists with implementing rewarded ads and rewarded interstitial ads, listening to user earned reward events, and cleaning up ad references. |
| `godot-admob-app-open` | Assists with implementing App Open ads shown during app startup or app transitions. |
| `godot-admob-native-overlay` | Assists with implementing Native Overlay ads using customized small or medium Control node templates. |
| `godot-admob-migrate` | Assists with migrating your project between different plugin versions (e.g. from v4.x to v5.x). |
| `godot-admob-mediation` | Assists with configuring, integrating, and verifying third-party mediation networks (AppLovin, Meta Audience Network, Unity Ads, etc.). |
| `godot-admob-troubleshoot` | Assists with diagnosing ad loading errors, handling error codes, opening the Ad Inspector, and resolving integration issues. |
| `godot-admob-privacy` | Assists with configuring user consent (UMP Flow), GDPR compliance, COPPA (child-directed treatment), CCPA, and request targeting options. |

You can implement agent skills for Godot AdMob Editor Plugin by prompting your preferred AI assistant. The agent skills can guide your AI assistant to perform the following example tasks:

* *Help me initialize the Godot AdMob Editor Plugin.*
* *Add a banner ad to my game.*
* *Implement a rewarded ad.*
* *Migrate my project from v4 to v5.*
* *Configure GDPR and COPPA privacy compliance.*
* *Troubleshoot why my ads are not loading.*

