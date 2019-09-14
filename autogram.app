global numPhotos
set numPhotos to 0

#open eyeem website, upload photo, get rating and caption, store these in iPhoto database, and return them
on uploadPhotoForAnalysis(photoFilePath)
	tell application "Google Chrome"
		activate
		set the bounds of the first window to {0, 0, 1024, 1024}
		tell front window
			set URL of active tab to "https://www.eyeem.com/eyeem-vision"
		end tell
		if (numPhotos = 0) then
			delay 3
			do shell script "/usr/local/bin/cliclick c:253,607" # ADVANCED
			delay 1
			do shell script "/usr/local/bin/cliclick c:333,765" # Proceed to www.eyeem.com (unsafe)
			set numPhotos to (numPhotos + 1)
		end if
		delay 15
	end tell
	tell application "System Events"
		repeat 25 times
			key code 125
			delay 0.1
		end repeat
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:600,825" #Try Now
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
	end tell
	set photoTags to replace_chars(photoTags, "-", "")
	tell application "Google Chrome"
		set photoScore to execute front window's tab 1 javascript "document.getElementsByName('showcase')[0].contentWindow.document.getElementsByClassName('tech-aesthetics__text-score')[0].innerText"
		set photoScore to text 1 thru -2 of photoScore
		set photoScoreTag to " | aesthetic score: " & photoScore & "% | "
		#display dialog (photoScoreTag)
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
		#set photoCaption to photoCaption & space & photoTags
		set photoCaption to photoCaption & space & photoScoreTag & space & photoTags
		quit
	end tell
	return {photoCaption, photoScore, starRating}
end uploadPhotoForAnalysis

#set Chrome to UserAgent iPhone 6, open and log in to Instagram, upload photo with caption, log out
on uploadToInstagram(imageLocation, imageCaption)
	set instagramPassword to setPassword()
	tell application "Google Chrome"
		activate
		delay 5
		set the bounds of the first window to {0, 0, 650, 950}
		do shell script "/usr/local/bin/cliclick c:607,80" # User Agent plugin
		delay 1
		do shell script "/usr/local/bin/cliclick c:571,153" # iOS
		delay 1
		do shell script "/usr/local/bin/cliclick c:406,112" # iPhone 6
		delay 3
		tell front window
			set URL of active tab to "https://www.instagram.com/accounts/login/"
		end tell
		delay 10
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:330,582" # refocus pointer
			do shell script "/usr/local/bin/cliclick c:330,582" # username
			keystroke "jasoneppink"
			delay 2
			do shell script "/usr/local/bin/cliclick c:330,625" # password
			keystroke instagramPassword
			delay 2
			do shell script "/usr/local/bin/cliclick c:330,670" # Log In (location 1)
			delay 1
			do shell script "/usr/local/bin/cliclick c:330,717" # Log In (location 2)
			delay 10
			do shell script "/usr/local/bin/cliclick c:330,634" # Not Now
			delay 10
			
			# we repeat this part a few times because sometimes the bottom menu bar doesn't load
			
			do shell script "/usr/local/bin/cliclick c:330,950" # add image (+)
			delay 2
		end tell
	end tell
	tell application "Google Chrome"
		set the bounds of the first window to {0, 0, 650, 950} # reposition because the file finder shifts it to the right
		delay 1
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:75,77"
			delay 1
			do shell script "/usr/local/bin/cliclick c:330,950" # add image (+)
			delay 1
		end tell
	end tell
	tell application "Google Chrome"
		set the bounds of the first window to {0, 0, 650, 950} # reposition because the file finder shifts it to the right
		delay 1
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:75,77"
			delay 1
			do shell script "/usr/local/bin/cliclick c:330,950" # add image (+)
			delay 1
		end tell
	end tell
	tell application "Google Chrome"
		set the bounds of the first window to {0, 0, 650, 950} # reposition because the file finder shifts it to the right
		delay 1
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:75,77"
			delay 1
			do shell script "/usr/local/bin/cliclick c:330,950" # add image (+)
			delay 1
		end tell
	end tell
	tell application "Google Chrome"
		set the bounds of the first window to {0, 0, 650, 950} # reposition because the file finder shifts it to the right
		delay 2
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:75,77"
			delay 2
			do shell script "/usr/local/bin/cliclick c:330,950" # add image (+)
			delay 2
		end tell
		
		keystroke "G" using {command down, shift down}
		delay 1
		keystroke imageLocation
		delay 10
		keystroke return
		delay 1
		keystroke return
		delay 2
	end tell
	tell application "Google Chrome"
		set the bounds of the first window to {0, 0, 650, 950} # reposition because the file finder shifts it to the right
		delay 2
	end tell
	tell application "System Events"
		tell process "chrome"
			do shell script "/usr/local/bin/cliclick c:33,760" # toggle crop (↙↗)
			delay 2
			do shell script "/usr/local/bin/cliclick c:608,120" # Next
			delay 2
			#do shell script "/usr/local/bin/cliclick c:147,147" # Write a caption...
			do shell script "/usr/local/bin/cliclick c:147,165" # Write a caption...
			delay 2
			keystroke imageCaption # paste in text
			delay 10
			do shell script "/usr/local/bin/cliclick c:600,120" # Share
			delay 10
			do shell script "/usr/local/bin/cliclick c:585,953" # profile (👤)
			delay 2
			do shell script "/usr/local/bin/cliclick c:30,120" # settings (⚙)
			delay 2
			do shell script "/usr/local/bin/cliclick c:70,845" # Log Out
			delay 2
			do shell script "/usr/local/bin/cliclick c:325,570" # Log Out (confirm)
			delay 2
			do shell script "/usr/local/bin/cliclick c:607,80" # User Agent plugin
			delay 1
			do shell script "/usr/local/bin/cliclick c:394,107" # Chrome
			delay 1
			do shell script "/usr/local/bin/cliclick c:394,107" # Default
			delay 1
		end tell
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


on replace_chars(this_text, search_string, replacement_string)
	#from: https://www.macosxautomation.com/applescript/sbrt/sbrt-06.html
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

on setPassword()
	return "YOUR-PASSWORD-HERE"
end setPassword
