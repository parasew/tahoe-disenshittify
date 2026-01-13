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

echo "--- RESTARTING THE CORE ---"
# This will make your screen flash black for a second—that's normal.
killall Finder
killall Dock
killall SystemUIServer
killall WindowManager

echo "--- COMPLETE: Your Mac should now behave like a computer, not a tablet. ---"
