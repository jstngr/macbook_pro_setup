# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# SSH                                                                         #
###############################################################################
echo "Welcome..."

echo "Generating SSH Key"

ssh-keygen -t rsa

echo "Done. Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing Git..."
brew install git

echo "Git config"

git config --global user.name "USERNAME"
git config --global user.email EMAIL@Domain.de


echo "Installing other brew stuff..."
brew install tree wget trash n

# install jq for json edit. Used for vscode settings
brew install jq

# install node
brew install node

echo "Cleaning up brew"
brew cleanup

# Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

# Apps
apps=(
    1password
    firefox
    google-chrome
    spectacle
    docker
    spotify
    visual-studio-code
    whatsapp
    signal
    scroll-reverser # Tool to reverse the direction of scrolling
    microsoft-outlook
    mattermost # Slack alternative
    steam # Gaming
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
brew install --cask --appdir="/Applications" ${apps[@]}

brew cleanup

echo "Setting some Mac settings... closing system preferences"

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


###############################################################################
# General                                                                     #
###############################################################################
echo "General..."

# Enable the battery percentage in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "INSERT NAME"
#sudo scutil --set HostName "name"
#sudo scutil --set LocalHostName "name"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "name"

# Disabling system-wide resume
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disabling automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Expanding the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Saving to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Speeding up Mission Control animations and grouping windows by application
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

# Setting Dock to auto-hide and removing the auto-hiding delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Show scroll bars only when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Disable the sudden motion sensor as its not useful for SSDs
sudo pmset -a sms 0

# set menu clock format
defaults write com.apple.menuextra.clock "DateFormat" 'EEE HH:mm:ss'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner → no-op
# defaults write com.apple.dock wvous-tl-corner -int 0
# defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner → no-op
# defaults write com.apple.dock wvous-tr-corner -int 0
# defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom left screen corner → Desktop
# defaults write com.apple.dock wvous-bl-corner -int 4
# defaults write com.apple.dock wvous-bl-modifier -int 0

# Bottom right screen corner → Start screen saver
# defaults write com.apple.dock wvous-br-corner -int 5
# defaults write com.apple.dock wvous-br-modifier -int 0

# Save screenshots to the Pictures/Screenshots
mkdir ${HOME}/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Setting screenshot format to PNG
defaults write com.apple.screencapture type -string "png"

# Enabling subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2


###############################################################################
# Typing and Input                                                            #
###############################################################################
echo "Typing and Input..."

# Disable smart quotes and smart dashes as they are annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disabling press-and-hold for keys in favor of a key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Setting trackpad & mouse speed to a reasonable number
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Map bottom right corner to right-click 
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Magic mouse: enable right click button
# defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

###############################################################################
# Finder                                                                      #
###############################################################################
echo "Finder..."

# Showing icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Showing all filename extensions in Finder by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Disabling the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle Clmv

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Restart the dock to apply changes
killall Dock

# Enabling snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate
defaults write com.apple.dock tilesize -int 50

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Set Code as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
mkdir ${HOME}/Code
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Code/"

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool TRUE


###############################################################################
# Mail                                                                        #
###############################################################################
echo "Mail..."

# Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable send and reply animations in Mail.app
# defaults write com.apple.mail DisableReplyAnimations -bool true
# defaults write com.apple.mail DisableSendAnimations -bool true

# Disable inline attachments (just show the icons)
# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true


###############################################################################
# Safari & WebKit                                                             #
###############################################################################
echo "Safari & WebKit..."

# Don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
# defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

#"Hiding Safari's bookmarks bar by default"
# defaults write com.apple.Safari ShowFavoritesBar -bool false

#"Hiding Safari's sidebar in Top Sites"
# defaults write com.apple.Safari ShowSidebarInTopSites -bool false

#"Disabling Safari's thumbnail cache for History and Top Sites"
# defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

#"Enabling Safari's debug menu"
# defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

#"Making Safari's search banners default to Contains instead of Starts With"
# defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

#"Removing useless icons from Safari's bookmarks bar"
# defaults write com.apple.Safari ProxiesInBookmarksBar "()"

#"Allow hitting the Backspace key to go to the previous page in history"
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

#"Enabling the Develop menu and the Web Inspector in Safari"
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

#"Adding a context menu item for showing the Web Inspector in web views"
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

#"Use `~/Downloads/Incomplete` to store incomplete downloads"
# defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
# defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"


###############################################################################
# Time Machine                                                                #
###############################################################################
echo "Time Machine..."

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal


###############################################################################
# Messages                                                                    #
###############################################################################
echo "Messages..."

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false


###############################################################################
# Google Chrome                                                               #
###############################################################################
echo "Google Chrome..."

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Visual studio code                                                          #
###############################################################################
echo "Visual studio code..."

# Open the VS Code extensions directory
# code --user-data-dir ~/.vscode/extensions

extensions=(
  dsznajder.es7-react-js-snippets
  dbaeumer.vscode-eslint
  eamodio.gitlens
  oderwat.indent-rainbow
  pkief.material-icon-theme
  esbenp.prettier-vscode
  netcorext.uuid-generator
  alefragnani.project-manager
  meganrogge.template-string-converter
  lokalise.i18n-ally 
)

# install extensions
for extension in "${extensions[@]}"
do
    code --install-extension $extension
done

# set user preferences

# Navigate to the VS Code User Settings directory
cd ~/Library/Application\ Support/Code/User
if [ ! -e "settings.json" ]; then
    touch "settings.json"
    echo "File created: settings.json"
else
    echo "File already exists: settings.json"
fi

json='{
  "workbench.colorTheme": "Default Dark+",
  "workbench.startupEditor": "none",
  "terminal.integrated.shell.osx": "/bin/zsh",
  "workbench.iconTheme": "material-icon-theme",
  "editor.defaultFormatter": ".prettierrc",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "editor.tabSize": 2,
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "redhat.telemetry.enabled": false,
  "[xml]": {
    "editor.defaultFormatter": "redhat.vscode-xml"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "git.autofetch": "all",
  "svg.preview.mode": "svg",
  "[svg]": {
    "editor.defaultFormatter": "jock.svg"
  },
  "turboConsoleLog.insertEnclosingClass": false,
  "git.confirmSync": false
}'
jq ${json} settings.json > temp.json && mv temp.json settings.json



echo "Please restart VS Code"

killall Finder

echo "Done!"

echo "Restart your mac"