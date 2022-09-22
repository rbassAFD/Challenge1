#!/bin/bash
#
# Brain Bash Tic-Tac-Toe (2B3T)
#
# Author: Christophe Casalegno / Brain 0verride
# Contact: brain@christophe-casalegno.com
# Version 1.0.0
#
# Copyright (c) 2020 Christophe Casalegno
# 
# This program is free software: you can redistribute it and/or modify
#
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>
#
# The license is available on this server here: 
# https://www.christophe-casalegno.com/licences/gpl-3.0.txt

function grid_init()
{
	A1=' ' && A2=' ' && A3=' '
	B1=' ' && B2=' ' && B3=' '
	C1=' ' && C2=' ' && C3=' '
}

function grid_print() 
{
	GRID="
    A   B   C
  +---+---+---+
1 | $A1 | $B1 | $C1 |
  +---+---+---+
2 | $A2 | $B2 | $C2 |
  +---+---+---+
3 | $A3 | $B3 | $C3 |
  +---+---+---+
	"
	echo "$GRID"
}

function answer()
{
	ANSWERTYPE="$1"
	ALREADY="This position is already taken, please enter a valid position and press ENTER"
	OUTSIDE="This position doesn't exist in this world, please enter a valid position and press ENTER"
	INVALID="An invalid answer has been entered, please enter yes or no and press ENTER" 

	if [[ "$ANSWERTYPE" = 'already' ]]
	then
		clear && echo "$ALREADY" && turn
	elif [[ "$ANSWERTYPE" = 'outside' ]]
		then
			clear && echo "$OUTSIDE" && turn
	elif [[ "$ANSWERTYPE" = 'invalid' ]]
		then
			clear && echo "$INVALID" && turn
	else
		clear ; echo 'Invalid option, please review your code' && turn
	fi
}

function test_pos() 
{
	XO="$1"
	if [[ "$XO" = 'X' ]] || [[ "$XO" = 'O' ]]
	then
		answer already
	else
		true
	fi
}

function take_pos() 
{

case "$PLAY" in

	A1|a1) test_pos "$A1" ;;
	A2|a2) test_pos "$A2" ;;
	A3|a3) test_pos "$A3" ;;
	B1|b1) test_pos "$B1" ;;
	B2|b2) test_pos "$B2" ;;
	B3|b3) test_pos "$B3" ;;
	C1|c1) test_pos "$C1" ;;
	C2|c2) test_pos "$C2" ;;
	C3|c3) test_pos "$C3" ;;
esac
}

function turn() 
{
	grid_print

	echo '-------------------------------'
	echo "Turn: $TURN - Player: $PLAYER"
	echo '-------------------------------'

	read PLAY 
	take_pos

	case "$PLAY" in

		A1|a1) A1="$PLAYER" ;;
		A2|a2) A2="$PLAYER" ;;
		A3|a3) A3="$PLAYER" ;;
		B1|b1) B1="$PLAYER" ;;
		B2|b2) B2="$PLAYER" ;;
		B3|b3) B3="$PLAYER" ;;
		C1|c1) C1="$PLAYER" ;;
		C2|c2) C2="$PLAYER" ;;
		C3|c3) C3="$PLAYER" ;;
		exit) clear && exit_game ;;
		*) answer outside ;;

	esac

}

function check_victory() 
{
	function check_line()
	{
		CHECK1="$1"
		CHECK2="$2"
		CHECK3="$3"

		if [[ "$CHECK1" = "$PLAYER" ]] && [[ "$CHECK2" = "$PLAYER" ]] && [[ "$CHECK3" = "$PLAYER" ]]
		then
			clear && echo "$PLAYER wins!" && grid_print && play_again
		else
			true
		fi  
	}

	check_line $A1 $A2 $A3
	check_line $B1 $B2 $B3
	check_line $C1 $C2 $C3
	check_line $A1 $B1 $C1
	check_line $A2 $B2 $C2
	check_line $A3 $B3 $C3
	check_line $A1 $B2 $C3
	check_line $A3 $B2 $C1
}

function exit_game()
{
	echo "Are you sure you want to exit? (yes/no)"
	read EXITINPUT

	if [[ "$EXITINPUT" = 'yes' ]] || [[ "$EXITINPUT" = 'y' ]]
		then clear && exit 
	elif [[ "$EXITINPUT" = 'no' ]] || [[ "$EXITINPUT" = 'n' ]]
		then clear && turn
	else
		answer invalid && exit_game
	fi
}

function play_again()
{
	echo "Do you want to play again? (yes/no)"
	read PLAYAGAININPUT

	if [[ "$PLAYAGAININPUT" = 'yes' ]] || [[ "$PLAYAGAININPUT" = 'y' ]]
		then game_start
	elif [[ "$PLAYAGAININPUT" = 'no' ]] || [[ "$PLAYAGAININPUT" = 'n' ]]
		then clear && exit
	else
		answer invalid
		play_again
	fi
}

function game_over() { clear && echo "Game Over" && grid_print && play_again; }

function game_start()
{
	grid_init

	TURN='1'
	PLAYER=X && clear && turn && ((TURN++)) # TURN +1

	until [[ $A1 != ' ' ]] && [[ $A2 != ' ' ]] && [[ $A3 != ' ' ]] \
	&& [[ $B1 != ' ' ]] && [[ $B2 != ' ' ]] && [[ $B3 != ' ' ]] \
	&& [[ $C1 != ' ' ]] && [[ $C2 != ' ' ]] && [[ $C3 != ' ' ]]

	do  
		PLAYER=O && clear && turn && check_victory && ((TURN++)) 
		PLAYER=X && clear && turn && check_victory && ((TURN++)) 
	done
		game_over
}

game_start


