Introduction a l'Assembly:

L'Assembly etant un language de bas niveaux il a la spécificité d'avoir deux syntax differente. 
Nous allons focus que sur une seul des deux maniere celle Intex(Intel) demander par le sujet Libasm

Exemple(https://imada.sdu.dk/u/kslarsen/dm546/Material/IntelnATT.htm):

    Intex Syntax:
        mov     eax,1
        mov     ebx,0ffh
        int     80h

    AT&T Syntax:
        movl    $1,%eax
        movl    $0xff,%ebx
        int     $0x80 


Maintenant qu'on sait quel syntaxe on va utiliser nous allons voir comment compiler le code qu'on aura fait
deja le fichier finira en .s (encore une fois demande par le sujet) mais on peut compiler aussi en .asm.
La compilation ce fera en deux etapes la premiere ces transformer les .s en .o donc on va utliser le compilateur nasm(d'autre existe comme yasm).

Exemple :
    nasm -f elf64 nom_du_ficher.s

Ci-dessus on peut voir deja qu'il y a un flag a mettre et son option qui est le format, si on fait nasm --help on peut trouver 
"-f select output file format" et "elf64  ELF64 (x86-64) (Linux, most Unix variants)" on choisira le format elf64 
car le sujet demande qu'on soit en 64bits. Aussi on peut compiler qu'un fichier a la fois avec nasm.

La prochaine etape sera de transformer tous ces point .o en un seul .a on peut se reference a la commande utiliser lors du projet libft "ar -rcs".

Le projet parle de faire un testeur on le fera en C on va juste compiler un main.c avec libasm.a (nom fichier demander par le sujet).
Le compilateur utiliser pour cet etape sera GCC on peut comme pour les projets C ajouter les flags -Werror -Wextra -Wall

La question qu'on peut se poser c'est comment notre main.c peut avoir access a nos fonctions en .s la reponse c'est que dans nos fichier .s on fera "global ft_write"
global + nom de fonction et dans le fichier main.c on les appelera avec extern exemple "extern ssize_t ft_write(int fd, const void *buf, size_t count);"

Coder en Assembly:

Maintenant qu'en amont nous avons pu voir la syntaxe et comment compiler nous allons pouvoir focus sur l'actuel maniere de coder en assembly

La premiere chose a savoir c'est qu'un .s peut etre separer en trois morceaux mais pour le projet nous allons utiliser qu'un seul de ces morceaux 
sans l'ecrire de maniere explicite. Donc comme dit au dessus les trois sections sont .text .data .bss nous allons utiliser juste .text

Exemple : 

    section .text
        extern main
    main:
        mov     rax, 1 ;sys_write
        mov     rdi, 1 ;fd
        mov     rsi, msg ;buf
        mov     rdx, msg.len ;count
        syscall

        mov rax, 60 ;sys_exit
        mov rdi, 0
        syscall
    section .data
        msg   db   'Hello, world!', 13, 0
        .len:   equ     $ - msg


Dans cet exemple nous allons print la variable msg on peut voir que la section .text est compose de notre fonction avec des instructions
et .data de nos variable qui sont constante et donc non-modifiable. Le .bss n'est pas utiliser car on mettra des variable non initialiser.
Voila pourquoi nous allons juste utiliser la section .text.

En relisant l'exemple on peut voir plusieur info importante deja que signifie mov on va l'utiliser principalement comme moyen de deplacer des donnees
comme si en C on faisait *dest = *src apres on peut voir des rax, rdi, rsi, etc.  On appele sa des registre la premiere lettre defini la taille utiliser
r-64 e-32 pour le 16 il n'y aura pas de lettre pour les details vous vous referencerai a ce site https://www.cs.uaf.edu/2017/fall/cs301/lecture/09_11_registers.html.
Apres cet premiere lettre nous avons le type de registre si vous etes aller sur le site vous verrez que tous on une utilisation specifique que nous verrons plus tard

Et apres la virgule qui separe les arguments exemple "mov rax, 1" le un ici signifie la valeur qu'on va mettre dans rax on pourrai mettre autre chose par exemple rdi ou autre.

Premiere fonction :

La premiere fonction qu'on verra sera ft_write ayant sans compter errno le moins d'instruction.

Avant de commencer a coder on va juste comprendre ou passe les donnees du main.c a la fonctions .s sa nous sera utilie dans le comprehension 
des prochaines fonctions. Si on part du postulat que votre appele de fonction ressemble a ca "ft_write(1, "hello\n", 7);" 
on peut voir qu'il y a trois arguments ceux-ci comme tous les suivants vont etre stocker dans le meme registre(ex:rax) donc ils vont etre mis dans 
rdi, rsi, rdx dans cet ordre la donc par exemple "hello\n" va se stocker dans rsi etant le deuxieme argument.

Exemple:

    bits 64 ; maniere explicite de dire que ca va etre du 64bits

    global ft_write ; declaration pour l'exterieur

    ft_write: ;nom de fonction
        mov rax, 1 ; instruction 
        syscall ; appel system
        ret ; fin de fonction


Avec l'exemple donner on peut voir a quoi va ressemble nos prochaine fonctions toujours composer d'abord d'une declaration disant qu'on va travailler en 64bits
apres de la declaration de notre fonction pour l'exterieur avec le global nom_de_fonction 
et si on veut appeller une autre fonctions par exemple ft_strlen on fera extern nom_de_fonction.

On avait pu voir que l'assembly utilise trois section mais nous pour notre projet nous allons utiliser qu'une seul la section .text on a pas besoin de la declarer

Actuellement nous savons pour ft_write que nos valeurs son deja stocker au bonne endroit car comme dit toutes les fonctions vont utiliser les meme registre 
a la difference qu'on va appele le systeme avec syscall a ce moment la il faut dire quel fonction systeme utiliser.
Je vais vous donner la liste https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/ ou https://syscall.sh/about
comme on peut voir sur ces sites pour appeller sys_write il faut mettre rax a 1, comme on peut voir avec l'exemple un mov est suffisant.
Quand tous est bon on peut faire le syscall.

A ce moment la on peut se demander comment on retourne la valeur voulu car write renvoie la taille de ce qui a etait ecris.
Il faut savoir que rax sert d'input et d'output dans le cas de syscall il va changer la valeur de rax et nous la renvoyer avec ce qui nous faut.
Il nous restera juste a mettre le ret pour dire que la fonction se termine ici.


ft_read :

Si tous a bien etait retenue on va pouvoir commencer ft_read dans ce paragraphe on va principalement voir l'utilisation de errno_location
Vous verrez tres rapidement que ft_write et ft_read font la meme chose avec une seul difference.

Pour tester ft_write ou ft_read on peut ouvrir un fichier avec les mauvais flags (ex: open("test.txt", O_WRONLY);) donc syscall va casser a ce moment la 
il va nous renvoyer une valeur negatif specifique de notre cote on a besoin de set errno a la bonne valeur et de renvoyer -1 (cf: man 2 write)

Pour la suite on va devoir voir plusieur type d'instruction comme par exemple cmp, jmp, jl, j'utilise ce genre de site 
https://benoit-m.developpez.com/assembleur/tutoriel/#LI ou https://www.tutorialspoint.com/assembly_programming/assembly_basic_syntax.htm

Comme dit précédemment si syscall a un problem rax va devenir negatif il font donc check si rax a changer de valeur
On va faire ce qu'on appelle une operation avec cmp(compare) apres cet 'OPERATION' on va utiliser un jump specifique qui est 
jl(Jump if Less) ce jump va check l'OPERATION precedante et voir si le premier argument(rax) est plus petit que le deuxieme(0)
si plus petit on va mettre apres le jl l'endroit ou on veut aller donc on va creer une sous fonction dans ft_read qui sera appeler .err
cet sous fonction va etre pareille qu'une fonction a la difference qui debutera avec un point. Bien sur si tous se passe bien le jump
va etre ignorer pour eviter que la lecture de la fonction continue on va utiliser ret pour signifier la fin de fonction.

Exemple :

    ft_read:
        ;instruction
        ;syscall
        ;operation
        jl .err;jump
        ret
    .err:
        ;instruction
        ret

Maintenant qu'on a check la valeur de rax on va passer a .err c'est ici qu'on va utliser errno. Je vais passer directement avec la reponse car pas 
trouver de documentation donnant les instruction a faire. 

Exemple :

    extern __errno_location

    ft_read:
        ;
        ret
    .err:
        neg rax ; errno a besoin d'une valeur absolue (positif)
        mov rdi, rax ;on va donner rax et le mettre dans le premier argument de la fonction errno_location
        call __errno_location wrt ..plt ; on appele la fonction __errno_location 
        mov [rax], rdi ; on va la mettre dans une zone vide de rax
        mov rax, -1; ici on va renvoyer la valeur d'erreur
        ret ; fin de fonction

La question qu'on peut se poser d'ou viens wrt ..plt deja un lien vers un element de reponse https://www.tortall.net/projects/yasm/manual/html/objfmt-elf32-wrt.html
mais sinon la raison de son utilisation est lie a gcc oui notre compilateur pour compile le .a avec le .c on va partir sur une explication assez detailler.
En gros GCC utilise le systeme PIE(Position Independent Executable) qui signifie que nos address ne sont pas fix donc quand on veut utiliser une fonction en
dehors de nos fichier on ne pourra pas compiler car il n'arrive pas a trouver de quoi on parle. A ce moment la on utilisera le PLT(Procedure Linkage Table)
en complement de wrt qui signifie juste "with respect to ..". On reutilisera ces deux mots pour l'utilisation de malloc.




