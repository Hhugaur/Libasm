NAME_TEST = test_c
TEST = main.c

NAME = libasm.a
SRCS = srcs/ft_write.s srcs/ft_read.s \
	srcs/ft_strlen.s srcs/ft_strcmp.s \
	srcs/ft_strcpy.s srcs/ft_strdup.s

OBJS = $(SRCS:.s=.o)
FILES = $(OBJS)

ASM = nasm -f elf64
GCC = gcc -Wall -Werror -Wextra
AR_RCS = ar -rcs

all : $(NAME)
$(NAME) : $(OBJS)
	$(AR_RCS) $(NAME) $(OBJS)

%.o : %.s
	$(ASM) $< -o $@

test: all
	$(GCC) $(TEST) $(NAME) -o $(NAME_TEST)
	@echo "Hello, World!" > test.txt

clean :
	rm -f $(FILES)

fclean : clean
	rm -f $(NAME) $(NAME_TEST)
	rm -f test.txt

re : fclean all

.PHONY: all test clean fclean re
