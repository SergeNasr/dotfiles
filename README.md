# Installation

## 0. Overview

This setup process involves a few manual prerequisite steps, followed by an automated script (`install.sh`) that handles the bulk of the configuration. Finally, a couple of post-installation manual steps are required to complete the setup.

**Manual Prerequisites:**

1.  Install [iTerm2](https://iterm2.com/)
2.  Configure iTerm2:
    -   Go to Profiles > Keys > Key Bindings > Presets
    -   Select "Natural Text Editing"

**The `install.sh` script will perform the following actions:**

-   Install Homebrew (if not already installed).
-   Install `neovim`, `pyenv`, and `skhd` (a hotkey daemon for macOS) using Homebrew.
-   Back up your existing `~/.zshrc` to `~/.zshrc.backup` (if it exists).
-   Create symbolic links for `.zshrc`, `nvim`, and `skhdrc` configuration files.
-   Set macOS keyboard repeat rate and Press and Hold preferences for a faster typing experience.
-   Configure Git to disable the pager for the `branch` command, improving its usability.

## 1. Automated Installation Script

1.  Clone this repository (if you haven't already):
    ```bash
    git clone <your-repo-url> ~/dotfiles
    cd ~/dotfiles
    ```
2.  Make the installation script executable:
    ```bash
    chmod +x install.sh
    ```
3.  Run the installation script:
    ```bash
    ./install.sh
    ```

## 2. Manual Post-Installation Steps

After running the `install.sh` script, you still need to perform the following manual steps:

1.  **Install Fira Code Font**:
    - Download and install a Fira Code Nerd Font from [NerdFonts](https://www.nerdfonts.com/).
    - Select the `.ttf` font you like, double-click it, and install it.
    - In iTerm2, go to Profiles > Your Profile > Text > Font, and select the installed Fira Code font.
2.  **Install Vim Plugins**:
    - Open Neovim (`nvim`).
    - Run the command `:PlugInstall` to install all configured plugins.
3.  **Apply Configuration**:
    - Open a new terminal tab/window, or
    - Run `source ~/.zshrc` in your current terminal to apply the Zsh and p10k configuration.

Enjoy your new setup!
