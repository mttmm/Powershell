REM Setting location variables

@ECHO OFF
:Set Path Location
set publicDesktop=Users\Public\Desktop
set publicStart=ProgramData\Microsoft\Windows\Start Menu\Programs

set location1=\\TONRDSHTRI02.nuvestack.com\C$
set location2=\\TONRDSHTRI02.nuvestack.com\C$
set location3=\\TONRDSHTRI03.nuvestack.com\C$

@ECHO ON
ECHO.
ECHO deleting %location1%
del /f /q "%location1%\%publicDesktop%\2X Client.lnk"
del /f /q "%location1%\%publicDesktop%\ExACCT.lnk"
del /f /q "%location1%\%publicDesktop%\Excel 2013.lnk"
del /f /q "%location1%\%publicDesktop%\FE Release Notes.lnk"
del /f /q "%location1%\%publicDesktop%\Outlook 2013.lnk"
del /f /q "%location1%\%publicDesktop%\PowerPoint 2013.lnk"
del /f /q "%location1%\%publicDesktop%\RE Release Notes.lnk"
del /f /q "%location1%\%publicDesktop%\The Financial Edge.lnk"
del /f /q "%location1%\%publicDesktop%\Word 2013.lnk"
del /f /q "%location1%\%publicDesktop%\The Raiser's Edge.lnk"
del /f /q "%location1%\%publicDesktop%\Skype.lnk"
del /f /q "%location1%\%publicDesktop%\Mozilla Firefox.lnk"
del /f /q "%location1%\%publicStart%\Java\About Java.lnk"
del /f /q "%location1%\%publicStart%\Java\Check For Updates.lnk"
del /f /q "%location1%\%publicStart%\Java\Configure Java.lnk"
del /f /q "%location1%\%publicStart%\Java\Get Help.url"
del /f /q "%location1%\%publicStart%\Java\Visit Java.com.url"

ECHO.
ECHO deleting %location2%
del /f /q "%location2%\%publicDesktop%\2X Client.lnk"
del /f /q "%location2%\%publicDesktop%\ExACCT.lnk"
del /f /q "%location2%\%publicDesktop%\Excel 2013.lnk"
del /f /q "%location2%\%publicDesktop%\FE Release Notes.lnk"
del /f /q "%location2%\%publicDesktop%\Outlook 2013.lnk"
del /f /q "%location2%\%publicDesktop%\PowerPoint 2013.lnk"
del /f /q "%location2%\%publicDesktop%\RE Release Notes.lnk"
del /f /q "%location2%\%publicDesktop%\The Financial Edge.lnk"
del /f /q "%location2%\%publicDesktop%\Word 2013.lnk"
del /f /q "%location2%\%publicDesktop%\The Raiser's Edge.lnk"
del /f /q "%location2%\%publicDesktop%\Skype.lnk"
del /f /q "%location2%\%publicDesktop%\Mozilla Firefox.lnk"
del /f /q "%location2%\%publicStart%\Java\About Java.lnk"
del /f /q "%location2%\%publicStart%\Java\Check For Updates.lnk"
del /f /q "%location2%\%publicStart%\Java\Configure Java.lnk"
del /f /q "%location2%\%publicStart%\Java\Get Help.url"
del /f /q "%location2%\%publicStart%\Java\Visit Java.com.url"
ECHO.
ECHO deleting %location3%
del /f /q "%location3%\%publicDesktop%\2X Client.lnk"
del /f /q "%location3%\%publicDesktop%\ExACCT.lnk"
del /f /q "%location3%\%publicDesktop%\Excel 2013.lnk"
del /f /q "%location3%\%publicDesktop%\FE Release Notes.lnk"
del /f /q "%location3%\%publicDesktop%\Outlook 2013.lnk"
del /f /q "%location3%\%publicDesktop%\PowerPoint 2013.lnk"
del /f /q "%location3%\%publicDesktop%\RE Release Notes.lnk"
del /f /q "%location3%\%publicDesktop%\The Financial Edge.lnk"
del /f /q "%location3%\%publicDesktop%\Word 2013.lnk"
del /f /q "%location3%\%publicDesktop%\The Raiser's Edge.lnk"
del /f /q "%location3%\%publicDesktop%\Skype.lnk"
del /f /q "%location3%\%publicDesktop%\Mozilla Firefox.lnk"
del /f /q "%location3%\%publicStart%\Java\About Java.lnk"
del /f /q "%location3%\%publicStart%\Java\Check For Updates.lnk"
del /f /q "%location3%\%publicStart%\Java\Configure Java.lnk"
del /f /q "%location3%\%publicStart%\Java\Get Help.url"
del /f /q "%location3%\%publicStart%\Java\Visit Java.com.url"