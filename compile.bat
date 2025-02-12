@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM ----------------------------------------------------------------------------
REM Create folders
REM ----------------------------------------------------------------------------

ECHO Checking folder structure..

SET "foldernames[0]=_compiled"
SET "foldernames[1]=_compiled\enums"
SET "foldernames[2]=_compiled\constants"
SET "foldernames[3]=_compiled\config"
SET "foldernames[4]=_compiled\core"
SET "foldernames[5]=_compiled\core\trick_handlers"
SET /A folderCount = 6
SET /A folderLoopMaxIndex = 5

FOR /L %%i IN (0, 1, %folderLoopMaxIndex%) DO (
	CALL :CreateFolderIfNotExist !foldernames[%%i]!
)

REM ----------------------------------------------------------------------------
REM File list
REM ----------------------------------------------------------------------------

@REM Print a blank line - https://stackoverflow.com/a/20691061
ECHO:
ECHO Declaring array of file name..

SET "filePaths[0]="
SET "filenames[0]=STimeCycle"

SET "filePaths[1]=constants/"
SET "filenames[1]=anim"
SET "filePaths[2]=constants/"
SET "filenames[2]=index"
SET "filePaths[3]=constants/"
SET "filenames[3]=nodetime"

SET "filePaths[4]=core/trick_handlers/"
SET "filenames[4]=BarspinTrickHandler"
SET "filePaths[5]=core/trick_handlers/"
SET "filenames[5]=FrontnudgeTrickHandler"
SET "filePaths[6]=core/trick_handlers/"
SET "filenames[6]=StoppieTrickHandler"
SET "filePaths[7]=core/trick_handlers/"
SET "filenames[7]=TrickHandler"
SET "filePaths[8]=core/trick_handlers/"
SET "filenames[8]=WheelieTrickHandler"
SET "filePaths[9]=core/trick_handlers/"
SET "filenames[9]=WhiplashTrickHandler"
SET "filePaths[10]=core/"
SET "filenames[10]=BMXTrick"
SET "filePaths[11]=core/"
SET "filenames[11]=Config"
SET "filePaths[12]=core/"
SET "filenames[12]=EventManager"
SET "filePaths[13]=core/"
SET "filenames[13]=init"
SET "filePaths[14]=core/"
SET "filenames[14]=Util"

SET "filePaths[15]=enums/"
SET "filenames[15]=Button"
SET "filePaths[16]=enums/"
SET "filenames[16]=Config"
SET "filePaths[17]=enums/"
SET "filenames[17]=Controller"
SET "filePaths[18]=enums/"
SET "filenames[18]=Event"
SET "filePaths[19]=enums/"
SET "filenames[19]=index"
SET "filePaths[20]=enums/"
SET "filenames[20]=TrickName"
SET "filePaths[21]=enums/"
SET "filenames[21]=TrickState"

SET "filePaths[22]=config/"
SET "filenames[22]=bmx_tricks"

SET /A fileCount = 23
SET /A fileLoopMaxIndex = 22

ECHO Iterating each item in the array, call the function, and put the array
ECHO item as an argument..

REM ----------------------------------------------------------------------------
REM Iterate and call the function - compile every lua file
REM ----------------------------------------------------------------------------

ECHO:
ECHO Compiling every single file..

FOR /L %%i IN (0, 1, %fileLoopMaxIndex%) DO (
	CALL :CompileLuaFile "!filenames[%%i]!" "!filePaths[%%i]!"
)

ECHO:
COLOR A
ECHO Compile process complete..
PAUSE

REM ----------------------------------------------------------------------------
REM Function definitions
REM ----------------------------------------------------------------------------

@REM Script will automatically aborts if function declared before it gets
@REM called.

:CreateFolderIfNotExist
	SET "foldername=%~1"
	IF NOT EXIST %foldername%\ (
		ECHO "Creating folder "%foldername%".."
		MKDIR %foldername%
	)
EXIT /B

:CompileLuaFile
	SET "filename=%~1"
	SET "directory=%~2"

	ECHO:

	ECHO "Compiling "%directory%%filename%.lua".."
	luac -s "%directory%%filename%.lua"

	IF EXIST "%filename%.lur" (
		ECHO "Deleting existing "%filename%.lur".."
		DEL "%filename%.lur"
	)

	ECHO "Renaming "luac.out" to "%filename%.lur".."
	RENAME luac.out "%filename%.lur"

	ECHO "Moving "%filename%.lur" to "_compiled/%directory%%filename%.lur".."
	MOVE /Y "%filename%.lur" "_compiled/%directory%"
EXIT /B
