#include <fcntl.h> // open
#include <unistd.h> // ssize_t
#include <stdio.h> // printf
#include <errno.h> // __errno_location
#include <string.h> // strlen, strcmp
#include <stdlib.h> // free

extern ssize_t ft_write(int fd, const void *buf, size_t count);

void tester_write()
{
    {
        printf("WRITE TEST\n");
        ft_write(1, "hello\n", 7);
    }
    {
        printf("ERROR TEST\n");
        int fd = open("test.txt", O_RDONLY);
        printf("opening test.txt file with O_RDONLY flag\n");
        if(fd < 0)
            return;
        printf("%ld\n", ft_write(fd, "hello\n", 7));
        printf("errno : %d (if value at 9 bad fd)\n", *__errno_location()); //EBADF 9 /* Bad file number */
        close(fd);
    }
}

extern ssize_t ft_read(int fd, void *buf, size_t count);

#define BUFFER_SIZE 5

void tester_read()
{
    {
        printf("READ TEST\n");
        int fd = open("test.txt", O_RDONLY);
        if(fd < 0)
            return; 
        char buf[BUFFER_SIZE];
        ft_read(fd, buf, BUFFER_SIZE);
        printf("reading test.txt file : %s\n", buf);
        close(fd);
    }
    {
        printf("ERROR TEST\n");
        int fd = open("test.txt", O_WRONLY);
        printf("opening test.txt file with O_WRONLY flag\n");
        if(fd < 0)
            return; 
        char buf[BUFFER_SIZE];
        printf("%ld\n", ft_read(fd, buf, BUFFER_SIZE));
        printf("errno : %d (if value at 9 bad fd)\n", *__errno_location()); //EBADF 9 /* Bad file number */
        close(fd);
    }
}


extern size_t ft_strlen(const char *s);


void    tester_strlen()
{
    printf("STRLEN TEST\n");
    printf("value: hello it's me\nmy strlen : %ld\nstrlen : %ld\n", ft_strlen("hello it's me"), strlen("hello it's me"));
    printf("empty string: %ld\n", ft_strlen(""));
}

extern int ft_strcmp(const char *s1, const char *s2);

void    tester_strcmp()
{
    printf("STRCMP TEST\n");
    printf("ft : %d\nstrcmp :%d\n", ft_strcmp("hello", "hello"), strcmp("hello", "hello"));
    printf("ft : %d\nstrcmp :%d\n", ft_strcmp("", "hello"), strcmp("", "hello"));
    printf("ft : %d\nstrcmp :%d\n", ft_strcmp("hello", ""), strcmp("hello", ""));
    printf("ft : %d\nstrcmp :%d\n", ft_strcmp("hello", "helle"), strcmp("hello", "helle"));
    printf("ft : %d\nstrcmp :%d\n", ft_strcmp("hello", "hellz"), strcmp("hello", "hellz"));

}

extern char *ft_strcpy(char *dest, const char *src);

void tester_strcpy()
{
    char dst[5];
    printf("STRCPY TEST\n");
    printf("%s\n", ft_strcpy(dst, "hello"));
    printf("%s\n", ft_strcpy(dst, ""));
    printf("%s\n", ft_strcpy(dst, "qwe"));
}

extern char *ft_strdup(const char *s);

void    tester_strdup()
{
    printf("STRDUP TEST\n");
    {
        char *empty;
        empty = ft_strdup("");
        printf("arg empty: %s\n", empty);
        free(empty);
    }
    {
        char *str;
        str = ft_strdup("Hello");
        printf("%s\n", str);
        free(str);
    }
}


int check_av(char *av)
{
    int i; 

    i = 0;
    while(av[i])
    {
        if(i > 0)
            return 1;
        if(av[i] < 97 || av[i] > 102)
            return 1;
        i++;
    }
    return 0;
}

int main(int ac, char **av)
{
    if(ac != 2)
    {
        printf(" a - test write\n b - test read\n c - test strlen\n \
d - test strcmp\n e - test strcpy\n f - test strdup\n");
        return 0;
    }
    if(check_av(av[1]) != 0)
        return 1;
    switch(av[1][0] - 97)
    {
        case 0:
            tester_write();
            return 0;
        case 1:
            tester_read();
            return 0;
        case 2:
            tester_strlen();
            return 0;
        case 3: 
            tester_strcmp();
            return 0;
        case 4:
            tester_strcpy();
            return 0;
        case 5:
            tester_strdup();
            return 0;
        default:
            return 0;
    }
}