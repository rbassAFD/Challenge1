#!/bin/bash

# Fonction pour mettre les variables à cocher (o/x)
function grid_init()
{
	A1=' ' && A2=' ' && A3=' '
	B1=' ' && B2=' ' && B3=' '
	C1=' ' && C2=' ' && C3=' '
}

# Fonction afin de dessiner le jeu
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

# Echo en cas d'erreur
function answer()
{
	ANSWERTYPE="$1"
	ALREADY="Cette position est occupé, entrer une position valide puis appuyer ENTER"
	OUTSIDE="Cette position n'existe pas, renseigner une position valide puis appuyer sur ENTER"
	INVALID="Invalide, appuyer sur yes ou no puis appuyer ENTER" 

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


# Fonction pour la croix ou rond + joueur
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



#Prendre les différentes positions sur le morpions
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


#Fonction de chaque tour un joueur occupera une place
function turn() 
{
	grid_print

	echo '-------------------------------'
	echo "Tour: $TURN - Joueur: $PLAYER"
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


#Vérification en cas de victoire
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


#Fonction de sortie 
function exit_game()
{
	echo "Êtes-vous sûr de quitter la matrice ? (yes/no)"
	read EXITINPUT

	if [[ "$EXITINPUT" = 'yes' ]] || [[ "$EXITINPUT" = 'y' ]]
		then clear && exit 
	elif [[ "$EXITINPUT" = 'no' ]] || [[ "$EXITINPUT" = 'n' ]]
		then clear && turn
	else
		answer invalid && exit_game
	fi
}


#Fonction de replay
function play_again()
{
	echo "Allez, une autre partie ? (yes/no)"
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

#En cas de défaite
function game_over() { clear && echo "Looser" && grid_print && play_again; }

#En cas de victoire
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


