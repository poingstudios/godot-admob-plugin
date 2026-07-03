# AI Copilot Skills (beta)

Integrate AI-powered coding assistants (such as Gemini in Antigravity, Cursor, Claude, or GitHub Copilot) into your game development workflow using **AI Copilot Skills**. 

The AdMob plugin comes with a pre-configured AI Skill containing all specifications, APIs, and code patterns for integrating various ad formats (Banners, Interstitials, Rewarded Ads, etc.) in both **GDScript** and **C#**.

---

## Quick Install (Built-in Skills)

You can install the pre-built AdMob AI skills directly into your project in one click:

1. Open your Godot project.
2. In the top editor menu, click on **Project -> Tools -> AdMob Manager**.
3. Select the **AI Copilot** submenu.
4. Click **Install AI Skills to Project**.

This will automatically create a `.skills/godot-admob-copilot` folder at the root of your project directory and place the `SKILL.md` instructions file inside it.

!!! note
    Files or folders starting with a dot (like `.skills`) are hidden in Godot's FileSystem dock by default to avoid cluttering your workspace, but they are fully visible to external IDEs (like VS Code, Cursor, Antigravity, etc.).

---

## Invoke the skill in your prompt

After you add the skill to your project, use the following example prompts to invoke it in your AI tool:

To invoke the skill, type `@` and select the `godot-admob-copilot` skill.

=== "Initialize MobileAds"

    ```text
    @godot-admob-copilot Write the complete initialization flow including UMP Consent check before initializing MobileAds in GDScript.
    ```

=== "Add Banner Ad"

    ```text
    @godot-admob-copilot Show me how to create and display a standard adaptive banner at the bottom of the screen in GDScript.
    ```

=== "Add Rewarded Ad"

    ```text
    @godot-admob-copilot Help me load a Rewarded Ad in C# and implement a callback to give the player 100 gold coins once they finish watching the ad.
    ```

