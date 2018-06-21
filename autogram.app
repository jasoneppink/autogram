#open eyeem website, upload photo, get rating and caption, store these in iPhoto database, and return them
on uploadPhotoForAnalysis(photoFilePath)
	tell application "Google Chrome"
		activate
		set the bounds of the first window to {0, 0, 1024, 1024}
		tell front window
			set URL of active tab to "https://www.eyeem.com/eyeem-vision"
		end tell
		delay 15
	end tell
	tell application "System Events"
		repeat 25 times
			key code 125
			delay 0.1
		end repeat
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:120,900" #Try Now
			delay 2
			do shell script "/usr/local/bin/cliclick c:255,263" #select from your computer
		end tell
		keystroke "G" using {command down, shift down}
		delay 1
		keystroke photoFilePath
		delay 2
		keystroke return
		delay 2
		keystroke return
		delay 60
	end tell
	tell application "Google Chrome"
		set photoCaption to execute front window's tab 1 javascript "document.getElementsByName('showcase')[0].contentWindow.document.getElementsByClassName('tech-analyzed-caption__text')[0].innerText"
		set photoTags to execute front window's tab 1 javascript "for (var i=0, tags='', arr=document.getElementsByName('showcase')[0].contentWindow.document.getElementsByClassName('tech-analyzed-concepts__tags-item'); i<arr.length; i++) { tags+= '#' + arr[i].innerText.split(' ').join('') + ' ';}"
		set photoCaption to photoCaption & "

" & photoTags
		
		set photoScore to execute front window's tab 1 javascript "document.getElementsByName('showcase')[0].contentWindow.document.getElementsByClassName('tech-aesthetics__text-score')[0].innerText"
		set photoScore to text 1 thru -2 of photoScore
		set photoScore to photoScore as number
		#display dialog (photoScore)
		if photoScore ≥ 0 and photoScore < 15 then
			set starRating to 0
		else if photoScore ≥ 15 and photoScore < 30 then
			set starRating to 1
		else if photoScore ≥ 30 and photoScore < 45 then
			set starRating to 2
		else if photoScore ≥ 45 and photoScore < 60 then
			set starRating to 3
		else if photoScore ≥ 60 and photoScore < 75 then
			set starRating to 4
		else if photoScore ≥ 75 and photoScore ≤ 100 then
			set starRating to 5
		end if
		quit
	end tell
	return {photoCaption, photoScore, starRating}
end uploadPhotoForAnalysis

#set Safari to user Agent iPod Touch iOS 9.3, open and log in to Instagram, upload photo with caption
on uploadToInstagram(imageLocation, imageCaption)
	tell application "Safari"
		if not (exists window 1) then reopen
		activate
	end tell
	delay 1
	tell application "System Events"
		tell process "Safari"
			tell menu bar 1
				click menu bar item "Safari"
				tell menu "Safari"
					click menu item "Private Browsing"
				end tell
			end tell
		end tell
		tell process "Safari"
			tell menu bar 1
				tell menu bar item "Develop"
					tell menu "Develop"
						tell menu item "User Agent"
							tell menu "User Agent"
								#click menu item "Internet Explorer 11"
								click menu item "Safari — iOS 9.3 — iPod touch"
							end tell
						end tell
					end tell
				end tell
			end tell
		end tell
	end tell
	tell application "Safari"
		if not (exists window 1) then reopen
		activate
		set the URL of the front document to "https://www.instagram.com/accounts/login"
		delay 3
		do JavaScript "document.getElementsByName('username')[0].focus()" in document 1 #username
		do JavaScript "document.getElementsByName('username')[0].select()" in document 1
	end tell
	
	tell application "System Events"
		keystroke "YOUR-INSTAGRAM-USER-NAME"
		delay 1
	end tell
	
	tell application "Safari"
		do JavaScript "document.getElementsByName('password')[0].focus()" in document 1 #password
		do JavaScript "document.getElementsByName('password')[0].select()" in document 1
	end tell
	
	tell application "System Events"
		keystroke "YOUR-INSTAGRAM-PASSWORD"
		delay 1
	end tell
	
	tell application "Safari"
		do JavaScript "if(document.getElementsByTagName('button')[0].innerHTML == 'Log in'){document.getElementsByTagName('button')[0].click()} else if(document.getElementsByTagName('button')[1].innerHTML == 'Log in'){document.getElementsByTagName('button')[1].click()}" in document 1 # login
		delay 10
		do JavaScript "if(document.getElementsByTagName('button')[0].innerHTML == 'Not Now'){document.getElementsByTagName('button')[0].click()} else if(document.getElementsByTagName('button')[1].innerHTML == 'Not Now'){document.getElementsByTagName('button')[1].click()}" in document 1 # skip "save info"
		delay 10
		do JavaScript "document.getElementsByClassName('coreSpriteFeedCreation')[0].click()" in document 1 # add image (+)
		delay 3
	end tell
	
	tell application "System Events"
		keystroke "G" using {command down, shift down}
		delay 1
		keystroke imageLocation
		delay 3
		keystroke return
		delay 2
		keystroke return
		delay 2
	end tell
	
	tell application "Safari"
		do JavaScript "document.getElementsByClassName('createSpriteExpand')[0].click()" in document 1 # toggle crop (↙↗)
		delay 1
		do JavaScript "document.getElementsByTagName('button')[1].click()" in document 1 # Next
		delay 1
		do JavaScript "document.getElementsByTagName('textarea')[0].focus()" in document 1 # Write a caption...
		do JavaScript "document.getElementsByTagName('textarea')[0].select()" in document 1
	end tell
	
	tell application "System Events"
		keystroke imageCaption
		delay 1
	end tell
	
	tell application "Safari"
		do JavaScript "document.getElementsByTagName('button')[1].click()" in document 1 # Share
		delay 10
		do JavaScript "document.getElementsByClassName('coreSpriteMobileNavProfileInactive')[0].click()" in document 1 # profile (👤)
		delay 1
		do JavaScript "document.getElementsByTagName('button')[2].click()" in document 1 # settings (⚙)
		delay 1
		do JavaScript "document.getElementsByClassName('coreSpriteNotificationRightChevron')[8].click()" in document 1 # Log Out
		delay 1
		quit
	end tell
end uploadToInstagram

#-------#
# main #
#-------#

tell application "iPhoto"
	activate
	select album "Photos"
	set thisPhotoScore to 0
	set topPhotoScore to 0
	set PhotoList to every photo of last import album
	repeat with eachPhoto in PhotoList
		if text -3 thru -1 of (original path of eachPhoto as string) is "JPG" and comment of eachPhoto does not contain "✅" and comment of eachPhoto does not contain "❌" then
			if comment of eachPhoto is "" then
				set photoFilePath to original path of eachPhoto
				set photoInfo to my uploadPhotoForAnalysis(photoFilePath)
				set comment of eachPhoto to item 1 of photoInfo #photoCaption
				set thisPhotoScore to item 2 of photoInfo #photoScore
				set rating of eachPhoto to item 3 of photoInfo #starRating
			end if
		end if
		if thisPhotoScore is greater than topPhotoScore then
			set topPhotoScore to thisPhotoScore
			set topPhotoComment to comment of eachPhoto
		end if
	end repeat
	set topPhoto to every photo of last import album whose comment contains topPhotoComment
	my uploadToInstagram(original path of item 1 of topPhoto, comment of item 1 of topPhoto)
	set comment of item 1 of topPhoto to comment of item 1 of topPhoto & "✅"
end tell
