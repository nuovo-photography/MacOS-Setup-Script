#! /bin/bash

say -v Moira "Welcome to the Nuovo MacOS Setup Script!"
say -v Moira "Let's get started!"

# ---------------------------------------------------------------------------------------------

# Entering as Root
printf "🔐 Enter root password...\n"
sudo -v

# Keep alive Root
printf "⌚️ Keep Root Account Alive...\n"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ---------------------------------------------------------------------------------------------

# Configure macOS Finder
say -v Moira "Let's setup your finder!"
printf "📁 Configure Finder Settings...\n"

# Show All Files & Extensions
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
# Path Bar
defaults write com.apple.finder ShowPathbar -bool true
# Show Status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Scrollbar Visibility
defaults write -g AppleShowScrollBars -string "Always"
# Show "Quit Finder" Menu Item
defaults write com.apple.finder QuitMenuItem -bool true && \
# Show External Media
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true && \
# Show Internal Media
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true && \
# Show Removable Media
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true && \
# Show Network Volumes
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true && \
chflags nohidden ~/Library
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

printf "⚙️ Finder - Show the $HOME/Library folder."
chflags nohidden $HOME/Library

printf "⚙️ Set Default Finder Location to Home Folder"
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# ---------------------------------------------------------------------------------------------

# Configure macOS Screen Capture
say -v Moira "Let's setup Screen Capture!"
printf "⚙️ Save screenshots in PNG format...\n"

mkdir ~/Screenshots
defaults write com.apple.screencapture location -string "~/Screenshots"
defaults write com.apple.screencapture type -string "png"

# ---------------------------------------------------------------------------------------------

# Configure macOS Keyboard
say -v Moira "Let's setup your Keyboard!"
printf "⚙️ Configure Keyboard...\n"

defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

# ---------------------------------------------------------------------------------------------

# Configure macOS Safari
say -v Moira "Let's setup Safari!"
printf "⚙️ Configure Safari...\n"

defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari ShowFavoritesBar -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true

printf "⚙️ Safari - Set home page to 'about:blank' for faster loading."
defaults write com.apple.Safari HomePage -string "about:blank"

# ---------------------------------------------------------------------------------------------

# Configure macOS Core System
say -v Moira "Applying System Wide Performance Enhancements"
printf "⚙️ Tweaking Core Mac OS System & Applying Configurations...\n"

printf "⚙️ Configure energy saving...\n"
sudo pmset -a displaysleep 15
sudo pmset -c sleep 0
sudo pmset -a hibernatemode 0

# Mac OS Tweaks

printf "⚙️ App Store - Disable the WebKit Developer Tools in the Mac App Store."
defaults write com.apple.appstore WebKitDeveloperExtras -bool false

printf "⚙️ Game Center - Disable Game Center."
defaults write com.apple.gamed Disabled -bool true

printf "⚙️ Printer - Automatically quit printer app once the print jobs complete."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

printf "⚙️ Chrome - Prevent native print dialog, use system dialog instead."
defaults write com.google.Chrome DisablePrintPreview -boolean true

printf "⚙️ System - Disable window resume system-wide."
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

printf "⚙️ System - Reveal IP address, hostname, OS version, etc. when clicking login window clock."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

printf "⚙️ Reduce Transparency"
defaults write com.apple.universalaccess reduceTransparency -bool true

printf "⚙️ Hide Debug Mode From App Store"
defaults write com.apple.appstore ShowDebugMenu -bool fals

printf "⚙️ Activate - Restart the ARD Agent & Helper"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -restart -agent -console

printf "⚙️ Allow Access for All Users and Give All Users Full Access"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all

printf "⚙️ Disable SIP iTunes"
sudo chmod 0000 /Applications/iTunes.app

printf "⚙️ Prevent Time Machine from Prompting to Use New Hard Drives as Backup Volume"
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

printf "⚙️ Disable Time Machine"
sudo tmutil disable

printf "⚙️ Save to Disk by Default"
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

printf "⚙️ Disable Creation of Metadata Files on Network Volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

printf "⚙️ Disable Creation of Metadata Files on USB Volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

printf "⚙️ Put Display to Sleep after 15 Minutes of Inactivity"
sudo pmset displaysleep 15

printf "⚙️ Turn Off System Sleep Completely"
sudo systemsetup -setcomputersleep Never

printf "⚙️ Enable Remote Login"
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

printf "⚙️ Disable Startup Chime"
sudo nvram StartupMute=%01

printf "⚙️ Enable Bonjour Service"
sudo defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist ProgramArguments -array "/usr/sbin/mDNSResponder" "-launchd"

printf "⚙️ Enable Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

printf "⚙️ Set Timezone"
sudo systemsetup -settimezone America/Toronto

printf "⚙️ Disable Unsigned Apps Gatekeeper prompt"
sudo spctl --master-disable

printf "⚙️ Enable Remote Apple Events"
sudo systemsetup -setremoteappleevents on

printf "⚙️ Enable Root User"
dsenableroot

printf "⚙️ Improving Animation Speed of the Save Dialog Prompt"
defaults write NSGlobalDomain NSWindowResizeTime .001

printf "⚙️ Disable Spotlight Indexing"
mdutil -i off -d /


# Change name if you do not own a MacBook
# printf "⚙️ Configure computer name...\n"
# sudo scutil --set ComputerName "MacBook"
# sudo scutil --set HostName "MacBook"
# sudo scutil --set LocalHostName "MacBook"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "MacBook"

# ---------------------------------------------------------------------------------------------

# Install Homebrew Unattended
say -v Moira "Installing HomeBrew"
printf "⚙️ Installing HomeBrew"

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Disable Brew Analytics
brew analytics off
# Check Brew Analytics
brew analytics

# ---------------------------------------------------------------------------------------------

# Installing the Xcode command line tools on 10.7.x or higher
say -v Moira "Installing XCode Dev tools"
printf "⚙️ Installing XCODE Command Line Utilities"

# Save current IFS state
OLDIFS=$IFS
IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"

# restore IFS to previous state
IFS=$OLDIFS
cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

# Installing the latest Xcode command line tools on 10.9.x or higher
if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 9 ) || ( ${osvers_major} -eq 11 && ${osvers_minor} -ge 0 ) ]]; then

	# Create the placeholder file which is checked by the softwareupdate tool 
	# before allowing the installation of the Xcode command line tools.
	touch "$cmd_line_tools_temp_file"
	# Identify the correct update in the Software Update feed with "Command Line Tools" in the name for the OS version in question.
	if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 15 ) || ( ${osvers_major} -eq 11 && ${osvers_minor} -ge 0 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)	
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -gt 9 ) ]] && [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -lt 15 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$macos_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 9 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	fi
	
	# Check to see if the softwareupdate tool has returned more than one Xcode
	# command line tool installation option. If it has, use the last one listed
	# as that should be the latest Xcode command line tool installer.
	if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
	   cmd_line_tools_output="$cmd_line_tools"
	   cmd_line_tools=$(printf "$cmd_line_tools_output" | tail -1)
	fi
	
	#Install the command line tools
	softwareupdate -i "$cmd_line_tools" --verbose
	# Remove the temp file
	if [[ -f "$cmd_line_tools_temp_file" ]]; then
	  rm "$cmd_line_tools_temp_file"
	fi
fi

# Installing the latest Xcode command line tools on 10.7.x and 10.8.x

# on 10.7/10.8, instead of using the software update feed, the command line tools are downloaded
# instead from public download URLs, which can be found in the dvtdownloadableindex:
# https://devimages.apple.com.edgekey.net/downloads/xcode/simulators/index-3905972D-B609-49CE-8D06-51ADC78E07BC.dvtdownloadableindex

if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 7 ) || ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 8 ) ]]; then
	if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 7 ) ]]; then	
	    DMGURL=http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg
	fi
	
	if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 8 ) ]]; then
	     DMGURL=http://devimages.apple.com/downloads/xcode/command_line_tools_for_osx_mountain_lion_april_2014.dmg
	fi
		TOOLS=cltools.dmg
		curl "$DMGURL" -o "$TOOLS"
		TMPMOUNT=`/usr/bin/mktemp -d /tmp/clitools.XXXX`
		hdiutil attach "$TOOLS" -mountpoint "$TMPMOUNT" -nobrowse
		# The "-allowUntrusted" flag has been added to the installer
		# command to accomodate for now-expired certificates used
		# to sign the downloaded command line tools.
		installer -allowUntrusted -pkg "$(find $TMPMOUNT -name '*.mpkg')" -target /
		hdiutil detach "$TMPMOUNT"
		rm -rf "$TMPMOUNT"
		rm "$TOOLS"
fi

# ---------------------------------------------------------------------------------------------

# Download, Mount, Install & Clear Google Drive App and Download Folder
# make temp folder for downloads
say -v Moira "Deploying Google Drive!"
printf "⚙️ Installing Google Drive"

mkdir "/tmp/googledrive"

# change working directory
cd "/tmp/googledrive"
#download Google Drive File Stream
curl -L -o "/tmp/googledrive/GoogleDrive.dmg" "https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
# Mount the DMG
hdiutil attach GoogleDrive.dmg -nobrowse
# Get Volume Name
Volume=$(diskutil info / | grep "Volume Name:" | awk '{print $3,$4,$5,$6}')
# Install Google Drive
sudo installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target /
#Tidy Up
hdiutil unmount "/Volumes/Install Google Drive"
sleep 5
sudo rm -rf "/tmp/googledrive"
sleep 5
#Bless Google Drive app
xattr -rc "/Applications/Google Drive.app"

# ---------------------------------------------------------------------------------------------

say -v Moira "Installing HomeBrew Apps"
printf "⚙️ Installing HomeBrew Apps"

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php74 --with-gmp
brew install wget
brew install mas
brew cask install --appdir="/Applications" adobe-creative-cloud
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" zoom
brew cask install --appdir="/Applications" rustdesk

# ---------------------------------------------------------------------------------------------

printf "⚙️ Cleanup and final touches...\n"

printf "⚙️ Restarting Finder"
killall Finder

printf "⚙️ Purge Memory Cache"
sudo purge

printf "⚙️ Resetting Hard Drive Permissions on Main Drive"
sudo diskutil repairPermissions /

printf "⚙️ Cleaning up Brew Installation & Configuration"
brew -v update && brew -v upgrade && mas upgrade && brew -v cleanup --prune=2 && brew doctor && brew -v upgrade --casks --greedy

# ---------------------------------------------------------------------------------------------

# Enabling Trimforce will cause a reboot, putting this as a last step
printf "⚙️ Enabling TrimForce"
sudo trimforce enable