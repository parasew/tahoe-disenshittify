#!/bin/bash

echo "--- PHASE 1: Kill All Animations (Zero Delay Mode) ---"
# 1. Disable opening/closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# 2. Disable window resizing animations (makes it instant)
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# 3. Disable Mission Control / Expose animations
defaults write com.apple.dock expose-animation-duration -float 0
# 4. Disable Launchpad animations
defaults write com.apple.dock springboard-show-duration -int 0
defaults write com.apple.dock springboard-hide-duration -int 0
# 5. Disable the 'Genie' and 'Scale' dock effects
defaults write com.apple.dock mineffect -string "scale"
# 6. Disable the bouncing dock icons (no more jumping crap)
defaults write com.apple.dock no-bouncing -bool TRUE

echo "--- PHASE 2: Nuke the Tahoe 'Glitter' & UI Gunk ---"
# 7. Disable 'Solarium' (Tahoe's heavy blurring and high-contrast engine)
defaults write -g com.apple.SwiftUI.DisableSolarium -bool YES
# 8. Disable Wallpaper Tinting (stops windows from taking on background colors)
defaults write -g AppleReduceDesktopTinting -bool YES
# 9. Kill Stage Manager completely
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 0
defaults write com.apple.shell.stage-manager.enabled -bool false
# 10. Kill Desktop Widgets
defaults write com.apple.widgets.allow-widgets -bool false

echo "--- PHASE 3: Kill Background 'Intelligent' Services ---"
# 11. Disable Siri and her listeners
launchctl disable user/$(id -u)/com.apple.Siri.agent
defaults write com.apple.Siri SiriHelpEnabled -bool false
# 12. Disable Predictive Text (the floating gray ghost text)
defaults write -g NSAutomaticInlinePredictionEnabled -bool false
# 13. Stop macOS from rearranging your Spaces (keeps them where YOU put them)
defaults write com.apple.dock mru-spaces -bool false

echo "--- PHASE 4: Fix Screenshot Logic & Latency ---"
# 14. Stop the 3-press lag by disabling the 'Screenshot Options' delay
defaults write com.apple.screencapture show-thumbnail -bool false

# 15. Force screenshots to go straight to a folder without 'processing' time
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture location -string "~/Desktop/Screenshots"

echo "--- PHASE 5: Disabling the 'Intelligence' Bloat (New for 2026) ---"
# Kill the Apple Intelligence 'generative' daemons that index your data in background
launchctl disable gui/$(id -u)/com.apple.generativeexperiencesd
launchctl disable gui/$(id -u)/com.apple.intelligenceplatformd
launchctl disable gui/$(id -u)/com.apple.intelligencecontextd

echo "--- PHASE 6: Nuking Handoff & Universal Control (The Network Lag) ---"
# Disable Handoff and Universal Clipboard (huge source of clipboard delays)
defaults write ~/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled -bool false
defaults write ~/Library/Preferences/com.apple.coreservices.useractivityd.plist SyncUserActivity -bool false

# Disable Universal Control 'Magic Edges' (stops the cursor from sticking to screen edges)
defaults write com.apple.universalcontrol Disable -bool true

echo "--- PHASE 7: Disabling Spotlight Indexing (The CPU Hog) ---"
echo "(you have to uncomment this feature if you really want this)"

# Stop the background indexing (mds/mdutil) entirely
# sudo mdutil -a -i off

# Hide the Spotlight icon from the menu bar to reclaim space
# defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool false

echo "--- PHASE 8: Killing Update Nags & Notifications ---"
# Disable the 'Updates Available' popup and background downloads
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool false
# Remove the 'Attention' badge from System Settings
defaults write com.apple.systempreferences AttentionPrefBundleIDs 0

echo "--- PHASE 9: Deep UI Cleaning ---"
# Remove the 'Recent Applications' from the Dock
defaults write com.apple.dock show-recents -bool false
# Disable the 'Shake mouse pointer to locate' (annoying when coding)
defaults write NSGlobalDomain NSTextPlacementSmartQuotesEnabled -bool false
defaults write CGDisableCursorLocationMagnification -bool YES

echo "--- PHASE 10: Nuking Keyboard 'Intelligence' & Autocorrect ---"

# Disable auto-correct (The "Fixed it for you" annoyance)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart quotes and smart dashes (the bane of programmers)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable the "double space for period" shortcut
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable the "Press and Hold" for accents (enables key repeat for gaming/coding)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Warning: This will disable the "Emoji & Symbols" picker and system-wide spellcheck. If you want a raw, "dumb" keyboard, add these:

# Disable the Spelling/Typo daemon
# launchctl disable user/$(id -u)/com.apple.AppleSpell

# Disable the Text Input Menu agent (stops the floating input switchers)
# launchctl disable user/$(id -u)/com.apple.TextInputMenuAgent
# launchctl disable user/$(id -u)/com.apple.TextInputSwitcher


echo "--- RESTARTING THE CORE ---"
# This will make your screen flash black for a second—that's normal.
killall Finder
killall Dock
killall SystemUIServer
killall WindowManager

echo "--- COMPLETE: Your Mac should now behave like a computer, not a tablet. ---"
