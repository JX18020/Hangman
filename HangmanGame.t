%June 8, 2018
%Julia Xie
%Ms. Krasteva
%This program will display a hangman game

import GUI
setscreen ("nocursor")
%Declaration Section
var wordName : array 1 .. 16 of string (14) := init ("motherboard", "microprocessor", "gigabyte", "monitor", "binary", "defragment", "graphics", "volatile", "megabyte", "kilobyte", "memory",
    "backup", "malware", "adapter", "debugging", "joystick")
var word : array 1 .. 27 of boolean := init (false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, true)
var key : string (1)
var rangeX, rangeY, guess, letter : int
var number : int 
var triesIncorrect, triesCorrect : int := 0
var finished, musicFinished : boolean := false
%Buttons
var button : int := 0
var menuButton, instructionsButton, level1Button, level2Button, exitButton, hintButton : int
%Window
var mainWin := Window.Open ("position:center;center, graphics:1280;720")
%music
process music
    loop
	exit when musicFinished = true  %allows the music to end when the program exits
	Music.PlayFile ("Wii Shop Channel Music.mp3")
    end loop
end music
process failSound
    Music.PlayFile ("Super Mario Dies Sound Effect.mp3")    %plays when the user loses
end failSound
process winSound
    Music.PlayFile ("Super Mario Bros. - Course Clear Sound Effect.mp3")    %plays when the player wins
end winSound
%Title
procedure title
    cls
    locate (1, 62)
    put "Hangman Game"
    put ""
end title
%Pause program
procedure pauseProgram
    var reply : string (1)
    locate (45, 1)
    put "Press any key to continue..." ..
    getch (reply)
end pauseProgram
%Random Number
procedure randNum
    title
    randint (number, 1, 16) %chooses the number for the word array
end randNum
%Instructions
procedure instructions
    title
    GUI.Hide (instructionsButton)   %prevents ghost buttons
    GUI.Hide (level1Button)
    GUI.Hide (level2Button)
    GUI.Show (menuButton)   %allows the user to go back to the main menu
    locate (5, 5)
    put "This program follows the normal hangman rules. You must guess a word, one letter at a time, by clicking on a lineup of letters"
    locate (7, 61)
    put "on the screen."
    locate (10, 5)
    put "You are allowed 6 incorrect guesses before the man is drawn and the game is over. There are 2 levels you may choose from. Level"
    locate (12, 47)
    put "1 gives you a hint, and level 2 does not."
end instructions
procedure goodbye
    setscreen ("nocursor")  %doesn't show the cursor
    title
    locate (17, 54)
    put "Thanks for playing hangman!"
    locate (19, 49)
    put "This program was created by Julia Xie."
    locate (25, 55)
    put "Press the ESC key to exit."
    getch (key)
    if key = chr (27) then
	Window.Close (mainWin)  %closes the window when the ESCAPE key is pressed
    else
	goodbye
    end if
end goodbye
%Output
procedure display
    title
    var font3 := Font.New ("Chiller:50:Bold")   %game over font
    if triesIncorrect = 6 then
	colourback (4) %changes background of text to red
	colour (0)  %changes the text colour to white
	fork failSound  %plays the fail music
	drawfillbox (0, 0, 1080, 720, 4)
	Font.Draw ("GAME OVER", 400, 400, font3, 0)
	locate (23, 57)
	put "You ran out of guesses!"
	locate (25, 53)
	put "The correct word is ", wordName (number), "."
    else
	fork winSound   %plays the win music
	locate (18, 60)
	put "Congratulations!"
	locate (20, 48)
	put "You guessed the correct word, ", wordName (number), "!"

	%Congratulatory animation
	for i : 0 .. 1300
	    drawfillbox (240, -154 + i, 300, 0 + i, 0)  %erase
	    Draw.ThickLine (270, -32 + i, 270, -152 + i, 3, 255)    %balloon string
	    drawfilloval (270, -32 + i, 30, 32, 12) %red balloon
	    drawfillbox (265, -67 + i, 275, -50 + i, 12)    %red balloon tie

	    drawfillbox (770, -214 + i, 830, -60 + i, 0)    %erase
	    Draw.ThickLine (800, -92 + i, 800, -212 + i, 3, 255)    %balloon string
	    drawfilloval (800, -92 + i, 30, 32, 44) %yellow balloon
	    drawfillbox (795, -124 + i, 805, -130 + i, 44)  %yelloow balloon tie

	    drawfillbox (900, -314 + i, 960, -160 + i, 0)   %erase
	    Draw.ThickLine (930, -192 + i, 930, -312 + i, 3, 255)   %balloon string
	    drawfilloval (930, -192 + i, 30, 32, 55)    %blue balloon
	    drawfillbox (925, -224 + i, 935, -230 + i, 55)  %blue balloon tie

	    drawfillbox (100, -414 + i, 160, -260 + i, 0)   %erase
	    Draw.ThickLine (130, -292 + i, 130, -412 + i, 3, 255)   %balloon string
	    drawfilloval (130, -292 + i, 30, 32, 35)    %purple balloon
	    drawfillbox (125, -324 + i, 135, -330 + i, 35)  %purple balloon tie

	    drawfillbox (800, -514 + i, 860, -360 + i, 0)   %erase
	    Draw.ThickLine (830, -392 + i, 830, -512 + i, 3, 255)   %balloon string
	    drawfilloval (830, -392 + i, 30, 32, 120)   %green balloon
	    drawfillbox (825, -424 + i, 835, -430 + i, 120) %green balloon tie

	    View.Update
	    delay (4)
	end for
    end if
    GUI.Show (menuButton)
end display
%User Input
procedure userInput
    var font1 := Font.New ("Courier:25:bold")   %letter font
    var font2 := Font.New ("Calibri:16:bold")   %incorrect letter font
    GUI.Hide (instructionsButton)   %prevents ghost buttons
    GUI.Hide (level1Button)
    GUI.Hide (level2Button)
    locate (35, 53)
    put "Please select a letter below."
    for i : 1 .. length (wordName (number)) %draws the correct number of dashes for letters
	locate (42, 10 + (8 * i))
	put "____" ..
    end for
    drawfillbox (300, 200, 310, 620, 114)   %draws the gallows
    drawfillbox (270, 200, 570, 210, 114)
    drawfillbox (300, 620, 460, 630, 114)
    drawfillbox (460, 630, 450, 600, 114)
    Draw.ThickLine (305, 245, 345, 205, 10, 114)

    Font.Draw ("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z", 30, 120, font1, 255)  %draws the lineup of letters
    Font.Draw ("INCORRECT LETTERS", 730, 480, font2, 255)   %labels the incorrect letter box

    drawbox (20, 110, 1060, 150, 255)   %letter box
    for i : 1 .. 26
	drawline (20 + 40 * i, 110, 20 + 40 * i, 150, 255)  %draws the lines separating the letters
    end for

    drawbox (640, 300, 1000, 500, 255)  %incorrect letter box

    loop
	mousewhere (rangeX, rangeY, button)
	View.Update
	locate (5, 1)
	if button = 1 then
	    if (rangeX > 20 and rangeX < 60) and (rangeY > 110 and rangeY < 150) then   %area for A
		letter := 1
		guess := index (wordName (number), "a")
		drawfillbox (21, 111, 59, 149, 0)   %erase
		if number = 1 then
		    Font.Draw ("A", 653, 55, font1, 255)     %9th blank
		elsif number = 3 or number = 5 or number = 8 or number = 9 then
		    Font.Draw ("A", 334, 55, font1, 255)     %4th blank
		elsif number = 6 then
		    Font.Draw ("A", 398, 55, font1, 255)     %5th blank
		elsif number = 7 then
		    Font.Draw ("A", 270, 55, font1, 255)     %3rd blank
		elsif number = 12 then
		    Font.Draw ("A", 206, 55, font1, 255)     %2nd blank
		elsif number = 13 then
		    Font.Draw ("A", 206, 55, font1, 255)     %2nd blank
		    Font.Draw ("A", 398, 55, font1, 255)     %5th blank
		elsif number = 14 then
		    Font.Draw ("A", 142, 55, font1, 255)     %1st blank
		    Font.Draw ("A", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("A", 670, 440, font1, 255)
		end if
	    elsif (rangeX > 60 and rangeX < 100) and (rangeY > 110 and rangeY < 150) then   %area for B
		letter := 2
		guess := index (wordName (number), "b")
		drawfillbox (61, 111, 99, 149, 0)   %erase
		if number = 1 then
		    Font.Draw ("B", 525, 55, font1, 255)     %7th blank
		elsif number = 3 or number = 9 or number = 10 then
		    Font.Draw ("B", 398, 55, font1, 255)     %5th blank
		elsif number = 5 or number = 12 then
		    Font.Draw ("B", 142, 55, font1, 255)     %1st blank
		elsif number = 15 then
		    Font.Draw ("B", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("B", 710, 440, font1, 255)
		end if
	    elsif (rangeX > 100 and rangeX < 140) and (rangeY > 110 and rangeY < 150) then  %area for C
		letter := 3
		guess := index (wordName (number), "c")
		drawfillbox (101, 111, 139, 149, 0) %erase
		if number = 2 then
		    Font.Draw ("C", 270, 55, font1, 255)     %3rd blank
		    Font.Draw ("C", 653, 55, font1, 255)     %9th blank
		elsif number = 7 or number = 16 then
		    Font.Draw ("C", 525, 55, font1, 255)     %7th blank
		elsif number = 12 then
		    Font.Draw ("C", 270, 55, font1, 255)     %3rd blank
		elsif number = 16 then
		    Font.Draw ("C", 525, 55, font1, 255)     %7th blank
		else
		    Font.Draw ("C", 750, 440, font1, 255)
		end if
	    elsif (rangeX > 140 and rangeX < 180) and (rangeY > 110 and rangeY < 150) then  %area for D
		letter := 4
		guess := index (wordName (number), "d")
		drawfillbox (141, 111, 179, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("D", 782, 55, font1, 255)     %11th blank
		elsif number = 6 or number = 15 then
		    Font.Draw ("D", 142, 55, font1, 255)     %1st blank
		elsif number = 14 then
		    Font.Draw ("D", 206, 55, font1, 255)     %2nd blank
		else
		    Font.Draw ("D", 790, 440, font1, 255)
		end if
	    elsif (rangeX > 180 and rangeX < 220) and (rangeY > 110 and rangeY < 150) then  %area for E
		letter := 5
		guess := index (wordName (number), "e")
		drawfillbox (181, 111, 219, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("E", 398, 55, font1, 255)     %5th blank
		elsif number = 2 then
		    Font.Draw ("E", 718, 55, font1, 255)     %10th blank
		elsif number = 3 or number = 8 or number = 10 then
		    Font.Draw ("E", 589, 55, font1, 255)     %8th blank
		elsif number = 6 or number = 9 then
		    Font.Draw ("E", 206, 55, font1, 255)     %2nd blank
		    Font.Draw ("E", 589, 55, font1, 255)     %8th blank
		elsif number = 11 or number = 15 then
		    Font.Draw ("E", 206, 55, font1, 255)     %2nd blank
		elsif number = 13 then
		    Font.Draw ("E", 525, 55, font1, 255)     %7th blank
		elsif number = 14 then
		    Font.Draw ("E", 462, 55, font1, 255)     %6th blank
		else
		    Font.Draw ("E", 830, 440, font1, 255)
		end if
	    elsif (rangeX > 220 and rangeX < 260) and (rangeY > 110 and rangeY < 150) then  %area for F
		letter := 6
		guess := index (wordName (number), "f")
		drawfillbox (221, 111, 259, 149, 0) %erase
		if number = 6 then
		    Font.Draw ("F", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("F", 870, 440, font1, 255)
		end if
	    elsif (rangeX > 260 and rangeX < 300) and (rangeY > 110 and rangeY < 150) then  %area for G
		letter := 7
		guess := index (wordName (number), "g")
		drawfillbox (261, 111, 299, 149, 0) %erase
		if number = 3 then
		    Font.Draw ("G", 142, 55, font1, 255)     %1st blank
		    Font.Draw ("G", 270, 55, font1, 255)     %3rd blank
		elsif number = 6 then
		    Font.Draw ("G", 462, 55, font1, 255)     %6th blank
		elsif number = 7 then
		    Font.Draw ("G", 142, 55, font1, 255)     %1st blank
		elsif number = 9 then
		    Font.Draw ("G", 270, 55, font1, 255)     %3rd blank
		elsif number = 15 then
		    Font.Draw ("G", 398, 55, font1, 255)     %5th blank
		    Font.Draw ("G", 462, 55, font1, 255)     %6th blank
		    Font.Draw ("G", 653, 55, font1, 255)     %9th blank
		else
		    Font.Draw ("G", 910, 440, font1, 255)
		end if
	    elsif (rangeX > 300 and rangeX < 340) and (rangeY > 110 and rangeY < 150) then  %area for H
		letter := 8
		guess := index (wordName (number), "h")
		drawfillbox (301, 111, 339, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("H", 334, 55, font1, 255)     %4th blank
		elsif number = 7 then
		    Font.Draw ("H", 398, 55, font1, 255)     %5th blank
		else
		    Font.Draw ("H", 950, 440, font1, 255)
		end if
	    elsif (rangeX > 340 and rangeX < 380) and (rangeY > 110 and rangeY < 150) then  %area for I
		letter := 9
		guess := index (wordName (number), "i")
		drawfillbox (341, 111, 379, 149, 0) %erase
		if number = 2 or number = 3 or number = 5 or number = 10 then
		    Font.Draw ("I", 206, 55, font1, 255)     %2nd blank
		elsif number = 4 then
		    Font.Draw ("I", 334, 55, font1, 255)     %4th blank
		elsif number = 7 or number = 8 or number = 16 then
		    Font.Draw ("I", 462, 55, font1, 255)     %6th blank
		elsif number = 15 then
		    Font.Draw ("I", 525, 55, font1, 255)     %7th blank
		else
		    Font.Draw ("I", 670, 400, font1, 255)
		end if
	    elsif (rangeX > 380 and rangeX < 420) and (rangeY > 110 and rangeY < 150) then  %area for J
		letter := 10
		guess := index (wordName (number), "j")
		drawfillbox (381, 111, 419, 149, 0) %erase
		if number = 16 then
		    Font.Draw ("J", 142, 55, font1, 255)    %1st blank
		else
		    Font.Draw ("J", 710, 400, font1, 255)
		end if
	    elsif (rangeX > 420 and rangeX < 460) and (rangeY > 110 and rangeY < 150) then  %area for K
		letter := 11
		guess := index (wordName (number), "k")
		drawfillbox (421, 111, 459, 149, 0) %erase
		if number = 10 then
		    Font.Draw ("K", 142, 55, font1, 255)     %1st blank
		elsif number = 12 then
		    Font.Draw ("K", 334, 55, font1, 255)     %4th blank
		elsif number = 16 then
		    Font.Draw ("K", 589, 55, font1, 255)     %8th blank
		else
		    Font.Draw ("K", 750, 400, font1, 255)
		end if
	    elsif (rangeX > 460 and rangeX < 500) and (rangeY > 110 and rangeY < 150) then  %area for L
		letter := 12
		guess := index (wordName (number), "l")
		drawfillbox (461, 111, 499, 149, 0) %erase
		if number = 8 then
		    Font.Draw ("L", 270, 55, font1, 255)     %3rd blank
		    Font.Draw ("L", 525, 55, font1, 255)     %7th blank
		elsif number = 10 or number = 13 then
		    Font.Draw ("L", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("L", 790, 400, font1, 255)
		end if
	    elsif (rangeX > 500 and rangeX < 540) and (rangeY > 110 and rangeY < 150) then  %area for M
		letter := 13
		guess := index (wordName (number), "m")
		drawfillbox (501, 111, 539, 149, 0) %erase
		if number = 1 or number = 2 or number = 4 or number = 9 or number = 13 then
		    Font.Draw ("M", 142, 55, font1, 255)     %1st blank
		elsif number = 6 then
		    Font.Draw ("M", 525, 55, font1, 255)     %7th blank
		elsif number = 11 then
		    Font.Draw ("M", 142, 55, font1, 255)     %1st blank
		    Font.Draw ("M", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("M", 830, 400, font1, 255)
		end if
	    elsif (rangeX > 540 and rangeX < 580) and (rangeY > 110 and rangeY < 150) then  %area for N
		letter := 14
		guess := index (wordName (number), "n")
		drawfillbox (541, 111, 579, 149, 0) %erase
		if number = 4 or number = 5 then
		    Font.Draw ("N", 270, 55, font1, 255)     %3rd blank
		elsif number = 6 then
		    Font.Draw ("N", 653, 55, font1, 255)     %9th blank
		elsif number = 15 then
		    Font.Draw ("N", 589, 55, font1, 255)     %8th blank
		else
		    Font.Draw ("N", 870, 400, font1, 255)
		end if
	    elsif (rangeX > 580 and rangeX < 620) and (rangeY > 110 and rangeY < 150) then  %area for O
		letter := 15
		guess := index (wordName (number), "o")
		drawfillbox (581, 111, 619, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("O", 206, 55, font1, 255)     %2nd blank
		    Font.Draw ("O", 589, 55, font1, 255)     %8th blank
		elsif number = 2 then
		    Font.Draw ("O", 398, 55, font1, 255)     %5th blank
		    Font.Draw ("O", 589, 55, font1, 255)     %8th blank
		    Font.Draw ("O", 910, 55, font1, 255)     %13th blank
		elsif number = 4 then
		    Font.Draw ("O", 206, 55, font1, 255)     %2nd blank
		    Font.Draw ("O", 462, 55, font1, 255)     %6th blank
		elsif number = 8 or number = 16 then
		    Font.Draw ("O", 206, 55, font1, 255)     %2nd blank
		elsif number = 10 or number = 11 then
		    Font.Draw ("O", 334, 55, font1, 255)     %4th blank
		else
		    Font.Draw ("O", 910, 400, font1, 255)
		end if
	    elsif (rangeX > 620 and rangeX < 660) and (rangeY > 110 and rangeY < 150) then  %area for P
		letter := 16
		guess := index (wordName (number), "p")
		drawfillbox (621, 111, 659, 149, 0) %erase
		if number = 2 or number = 12 then
		    Font.Draw ("P", 462, 55, font1, 255)     %6th blank
		elsif number = 7 or number = 14 then
		    Font.Draw ("P", 334, 55, font1, 255)     %4th blank
		else
		    Font.Draw ("P", 950, 400, font1, 255)
		end if
	    elsif (rangeX > 660 and rangeX < 700) and (rangeY > 110 and rangeY < 150) then  %area for Q
		letter := 17
		guess := index (wordName (number), "q")
		drawfillbox (661, 111, 699, 149, 0) %erase
		Font.Draw ("Q", 670, 360, font1, 255)
	    elsif (rangeX > 700 and rangeX < 740) and (rangeY > 110 and rangeY < 150) then  %area for R
		letter := 18
		guess := index (wordName (number), "r")
		drawfillbox (701, 111, 739, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("R", 462, 55, font1, 255)     %6th blank
		    Font.Draw ("R", 718, 55, font1, 255)     %10th blank
		elsif number = 2 then
		    Font.Draw ("R", 334, 55, font1, 255)     %4th blank
		    Font.Draw ("R", 525, 55, font1, 255)     %7th blank
		    Font.Draw ("R", 974, 55, font1, 255)     %14th blank
		elsif number = 4 or number = 14 then
		    Font.Draw ("R", 525, 55, font1, 255)     %7th blank
		elsif number = 5 or number = 11 then
		    Font.Draw ("R", 398, 55, font1, 255)     %5th blank
		elsif number = 6 then
		    Font.Draw ("R", 334, 55, font1, 255)     %4th blank
		elsif number = 7 then
		    Font.Draw ("R", 206, 55, font1, 255)     %2nd blank
		elsif number = 13 then
		    Font.Draw ("R", 462, 55, font1, 255)     %6th blank
		else
		    Font.Draw ("R", 710, 360, font1, 255)
		end if
	    elsif (rangeX > 740 and rangeX < 780) and (rangeY > 110 and rangeY < 150) then  %area for S
		letter := 19
		guess := index (wordName (number), "s")
		drawfillbox (741, 111, 779, 149, 0) %erase
		if number = 2 then
		    Font.Draw ("S", 782, 55, font1, 255)     %11th blank
		    Font.Draw ("S", 846, 55, font1, 255)     %12th blank
		elsif number = 7 then
		    Font.Draw ("S", 589, 55, font1, 255)     %8th blank
		elsif number = 16 then
		    Font.Draw ("S", 334, 55, font1, 255)     %4th blank
		else
		    Font.Draw ("S", 750, 360, font1, 255)
		end if
	    elsif (rangeX > 780 and rangeX < 820) and (rangeY > 110 and rangeY < 150) then  %area for T
		letter := 20
		guess := index (wordName (number), "t")
		drawfillbox (781, 111, 819, 149, 0) %erase
		if number = 1 then
		    Font.Draw ("T", 270, 55, font1, 255)     %3rd blank
		elsif number = 3 or number = 9 or number = 10 then
		    Font.Draw ("T", 525, 55, font1, 255)     %7th blank
		elsif number = 4 or number = 8 or number = 14 or number = 16 then
		    Font.Draw ("T", 398, 55, font1, 255)     %5th blank
		elsif number = 6 then
		    Font.Draw ("T", 718, 55, font1, 255)     %10th blank
		else
		    Font.Draw ("T", 790, 360, font1, 255)
		end if
	    elsif (rangeX > 820 and rangeX < 860) and (rangeY > 110 and rangeY < 150) then  %area for U
		letter := 21
		guess := index (wordName (number), "u")
		drawfillbox (821, 111, 859, 149, 0) %erase
		if number = 12 then
		    Font.Draw ("U", 398, 55, font1, 255)     %5th blank
		elsif number = 15 then
		    Font.Draw ("U", 334, 55, font1, 255)     %4th blank
		else
		    Font.Draw ("U", 830, 360, font1, 255)
		end if
	    elsif (rangeX > 860 and rangeX < 900) and (rangeY > 110 and rangeY < 150) then  %area for V
		letter := 22
		guess := index (wordName (number), "v")
		drawfillbox (861, 111, 899, 149, 0) %erase
		if number = 8 then
		    Font.Draw ("V", 142, 55, font1, 255)     %1st blank
		else
		    Font.Draw ("V", 870, 360, font1, 255)
		end if
	    elsif (rangeX > 900 and rangeX < 940) and (rangeY > 110 and rangeY < 150) then  %area for W
		letter := 23
		guess := index (wordName (number), "w")
		drawfillbox (901, 111, 939, 149, 0) %erase
		if number = 13 then
		    Font.Draw ("W", 334, 55, font1, 255)     %4th blank
		else
		    Font.Draw ("W", 910, 360, font1, 255)
		end if
	    elsif (rangeX > 940 and rangeX < 980) and (rangeY > 110 and rangeY < 150) then  %area for X
		letter := 24
		guess := index (wordName (number), "x")
		drawfillbox (941, 111, 979, 149, 0) %erase
		Font.Draw ("X", 950, 360, font1, 255)
	    elsif (rangeX > 980 and rangeX < 1020) and (rangeY > 110 and rangeY < 150) then %area for Y
		letter := 25
		guess := index (wordName (number), "y")
		drawfillbox (981, 111, 1019, 149, 0)    %erase
		if number = 3 or number = 5 or number = 9 or number = 10 or number = 11 then
		    Font.Draw ("Y", 462, 55, font1, 255)     %6th blank
		elsif number = 16 then
		    Font.Draw ("Y", 270, 55, font1, 255)     %3rd blank
		else
		    Font.Draw ("Y", 670, 320, font1, 255)
		end if
	    elsif (rangeX > 1020 and rangeX < 1060) and (rangeY > 110 and rangeY < 150) then    %area for Z
		letter := 26
		guess := index (wordName (number), "z")
		drawfillbox (1021, 111, 1059, 149, 0)   %erase
		Font.Draw ("Z", 710, 320, font1, 255)
	    else
		letter := 27
		guess := 0
	    end if
	    if guess = 0 and word (letter) = false then
		triesIncorrect := triesIncorrect + 1    %counts number of wrong answers
	    elsif guess not= 0 and word (letter) = false then
		triesCorrect := triesCorrect + 1    %counts the number of correct answers
	    end if
	    if triesIncorrect = 1 then
		drawfilloval (455, 550, 50, 50, 255)    %head
		drawfilloval (455, 550, 40, 40, 0)
	    elsif triesIncorrect = 2 then
		Draw.ThickLine (455, 500, 455, 370, 10, 255)    %body
	    elsif triesIncorrect = 3 then
		Draw.ThickLine (455, 370, 420, 270, 10, 255)    %left leg
	    elsif triesIncorrect = 4 then
		Draw.ThickLine (455, 370, 490, 270, 10, 255)    %right leg
	    elsif triesIncorrect = 5 then
		Draw.ThickLine (455, 500, 410, 400, 10, 255)    %left arm
	    elsif triesIncorrect = 6 then
		Draw.ThickLine (455, 500, 500, 400, 10, 255)    %right arm
	    end if
	    if number = 5 or number = 7 or number = 10 or number = 12 or number = 16 then
		if triesCorrect = length (wordName (number)) then   %for words with all different letters
		    finished := true
		end if
	    elsif number = 3 or number = 4 or number = 6 or number = 8 or number = 9 or number = 11 or number = 13 or number = 14 then
		if triesCorrect = length (wordName (number)) - 1 then   %for words with 1 same letter
		    finished := true
		end if
	    elsif number = 1 or number = 15 then
		if triesCorrect = length (wordName (number)) - 2 then   %for words with 2 same letters
		    finished := true
		end if
	    elsif number = 2 then
		if triesCorrect = length (wordName (number)) - 6 then   %for words with 6 same letters
		    finished := true
		end if
	    end if
	    word (letter) := true   %prevents the same letters from being clicked twice
	end if
	exit when triesIncorrect = 6 or finished = true %exits the mousewhere loop when the user either wins or loses
    end loop
    pauseProgram
    display
end userInput
%hints
procedure hint
    locate (8, 102)
    put "HINT:"
    if number = 1 then  %motherboard
	locate (10, 89)
	put "First know as a 'breadboard'."
    elsif number = 2 then   %microprocessor
	locate (10, 94)
	put "Also known as a CPU."
    elsif number = 3 then   %gigabyte
	locate (10, 89)
	put "Made up of 1,000,000,000 bytes."
    elsif number = 4 then   %monitor
	locate (10, 91)
	put "A screen that displays an"
	locate (11, 89)
	put "image generated by a computer."
    elsif number = 5 then   %binary
	locate (10, 91)
	put "01100010 01101001 01101110"    %"binary" in binary
	locate (11, 91)
	put "01100001 01110010 01111001"
    elsif number = 6 then   %defragment
	locate (10, 92)
	put "A form of sorting files."
    elsif number = 7 then   %graphics
	locate (10, 81)
	put "Visual images produced by computer processing."
    elsif number = 8 then   %volatile
	locate (10, 86)
	put "A type of memory which is temporary."
    elsif number = 9 then   %megabyte
	locate (10, 90)
	put "Made up of 1,000,000 bytes."
    elsif number = 10 then  %kilobyte
	locate (10, 93)
	put "Made up of 1000 bytes."
    elsif number = 11 then  %memory
	locate (10, 88)
	put "Also known as 'primary storage'."
    elsif number = 12 then  %backup
	locate (10, 83)
	put "The act of creating a second copy of data."
    elsif number = 13 then  %malware
	locate (10, 85)
	put "Software that is intended to damage or"
	locate (11, 84)
	put "disable computers and computer systems."
    elsif number = 14 then  %adapter
	locate (10, 82)
	put "A device for connecting pieces of equipment"
	locate (11, 87)
	put "that cannot be connected directly."
    elsif number = 15 then  %debugging
	locate (10, 83)
	put "The act of detecting and removing errors."
    elsif number = 16 then  %joystick
	locate (10, 91)
	put "A type of game controller."
    end if
end hint
%Level 1
procedure level1
    title
    hint    %level 1 allows hint
    userInput
end level1
%Level2
procedure level2
    title
    userInput
end level2
%Main Menu
procedure mainMenu
    colourback (0) %sets background to white
    colour (255)    %sets the text colour back to black
    title
    randNum %generates random number for array
    triesCorrect := 0   %sets the number of correct tries back to 0
    triesIncorrect := 0 %sets the number of incorrect tries back to 0
    finished := false   %sets the finished variable to false so the loop doesn't exit in userInput
    for i : 1 .. 26
	word (i) := false   %sets all the words back to 0
    end for
    locate (3, 60)
    put "Select an option."
    instructionsButton := GUI.CreateButton (498, 500, 0, "Intructions", instructions)   %button leads to instructions
    level1Button := GUI.CreateButton (508, 400, 0, "Level 1", level1)   %button leads to userInput but with hint
    level2Button := GUI.CreateButton (508, 300, 0, "Level 2", level2)   %button leads to userInput but without hint
    exitButton := GUI.CreateButtonFull (517, 200, 0, "Exit", GUI.Quit, 0, KEY_ESC, false)   %button exits the program
    GUI.Show (instructionsButton)   %shows the buttons
    GUI.Show (level1Button)
    GUI.Show (level2Button)
    GUI.Hide (menuButton)   %hides the menu button
end mainMenu
%Program introduction
procedure introduction
    title
    fork music  %plays the music in the background
    locate (3, 30)
    put "This program will help you learn computer terms through the game of hangman!"
    %animation
    drawfillbox (300, 200, 310, 620, 114)   %gallows
    drawfillbox (270, 200, 570, 210, 114)
    drawfillbox (300, 620, 460, 630, 114)
    drawfillbox (460, 630, 450, 600, 114)
    Draw.ThickLine (305, 245, 345, 205, 10, 114)
    for i : 0 .. 200
	drawfillbox (1080 - i, 216, 1251 - i, 550, 0)   %erase
	drawfilloval (1125 - i, 500, 50, 50, 255)   %head
	drawfilloval (1125 - i, 500, 40, 40, 0)
	Draw.ThickLine (1125 - i, 450, 1125 - i, 320, 10, 255)  %body
	Draw.ThickLine (1125 - i, 320, 1090 - i, 220, 10, 255)  %left leg
	Draw.ThickLine (1125 - i, 320, 1160 - i, 220, 10, 255)  %right leg
	Draw.ThickLine (1125 - i, 450, 1080 - i, 350, 10, 255)  %left arm
	Draw.ThickLine (1125 - i, 450, 1220 - i, 400, 10, 255)  %right arm

	Draw.ThickLine (1220 - i, 380, 1220 - i, 500, 3, 255)   %balloon string
	drawfilloval (1220 - i, 510, 30, 32, 12)    %balloon
	drawfillbox (1215 - i, 475, 1225 - i, 480, 12)  %balloon tie
	View.Update
	delay (5)
    end for
    for i : 0 .. 400
	drawfillbox (880 - i, 216, 1025 - i, 550, 0)    %stickman erase
	drawfilloval (925 - i, 500, 50, 50, 255)    %head
	drawfilloval (925 - i, 500, 40, 40, 0)
	Draw.ThickLine (925 - i, 450, 925 - i, 320, 10, 255)    %body
	Draw.ThickLine (925 - i, 320, 890 - i, 220, 10, 255)    %left leg
	Draw.ThickLine (925 - i, 320, 960 - i, 220, 10, 255)    %right leg
	Draw.ThickLine (925 - i, 450, 880 - i, 350, 10, 255)    %left arm
	Draw.ThickLine (925 - i, 450, 970 - i, 350, 10, 255)    %right arm

	drawfillbox (990, 378 + i, 1050, 500 + i, 0)    %balloon erase
	Draw.ThickLine (1020, 380 + i, 1020, 500 + i, 3, 255)   %balloon string
	drawfilloval (1020, 510 + i, 30, 32, 12)    %balloon
	drawfillbox (1015, 475 + i, 1025, 480 + i, 12)  %balloon tie
	View.Update
	delay (5)
    end for
    menuButton := GUI.CreateButtonFull (510, 50, 0, "Menu", mainMenu, 0, KEY_ENTER, false)  %button leads to main menu
    GUI.Show (menuButton)   %shows the button
end introduction
%Main Program
introduction
loop
    exit when GUI.ProcessEvent  %exits when the exit button is clicked
end loop
goodbye %shows the goodbye
musicFinished := true   %finishes the music
Music.PlayFileStop  %ends the music
%End Program

