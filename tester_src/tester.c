#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define SIZEOF_ARRAY(x) (sizeof(x) / sizeof(x[0]))

extern size_t	ft_strlen(char const *str);
extern char		*ft_strcpy(char *dest, char const *src);
extern int		ft_strcmp(char const *a, char const *b);
extern char		*ft_strdup(const char *str);
extern ssize_t	ft_read(int fd, void *buf, size_t count);
extern ssize_t	ft_write(int fd, const void *buf, size_t count);

int signum_i32(int32_t n)
{
	if (n < 0)
		return -1;
	else if (n > 0)
		return 1;
	else
		return 0;
}

int main()
{
	// strlen
	{
		const char *tests[] = {
			"This is a test",
			"",
			"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
		};
		for (size_t i = 0; i < SIZEOF_ARRAY(tests); ++i)
		{
			size_t a = strlen(tests[i]);
			size_t b = ft_strlen(tests[i]);
			assert(a == b);
		}
	}
	// strcpy
	{
		char dest1[] = "Coucou";
		char dest2[] = "Coucou";
		char *a = strcpy(dest1, "abcdef");
		char *b = ft_strcpy(dest2, "abcdef");
		assert(a == dest1);
		assert(b == dest2);
		assert(strcmp(dest1, "abcdef") == 0);
		assert(strcmp(dest2, "abcdef") == 0);

		a = strcpy(dest1, "abc");
		b = ft_strcpy(dest2, "abc");
		assert(a == dest1);
		assert(b == dest2);
		assert(strcmp(dest1, "abc") == 0);
		assert(strcmp(dest2, "abc") == 0);
	}
	// strcmp
	{
		const char *tests[] = {
			"ab1", "ab2",
			"HI", "HI",
			"abc", "abcdef",
			"abcdef", "abc",
			"", "",
			"", "Hello, world!",
			"Hello, world!", "",
			"12", "21",
			"21", "12",
		};
		for (size_t i = 0; i < SIZEOF_ARRAY(tests); i += 2)
		{
			int a = strcmp(tests[i], tests[i + 1]);
			int b = ft_strcmp(tests[i], tests[i + 1]);
			printf("a: %s, b: %s\na: %d, b: %d\n", tests[i], tests[i + 1], a, b);

			// Spec only specifies the sign, not the value.
			// The == assert behaves fine regardless, except in valgrind for some reason.
			// assert(a == b);
			assert(signum_i32(a) == signum_i32(b));
		}
	}
	// read
	{
		char buffer1[512];
		char buffer2[512];
		int fd1, fd2;
		ssize_t retval1, retval2;
		int errno1, errno2;

		// Read entire file
		fd1 = open("src/ft_read.s", O_RDONLY);
		fd2 = open("src/ft_read.s", O_RDONLY);
		memset(buffer1, 0, sizeof(buffer1));
		memset(buffer2, 0, sizeof(buffer2));
		retval1 = read(fd1, buffer1, sizeof(buffer1));
		errno1 = errno;
		retval2 = ft_read(fd2, buffer2, sizeof(buffer2));
		errno2 = errno;

		assert(memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Try to read after entire file has been read
		retval1 = read(fd1, buffer1, sizeof(buffer1));
		errno1 = errno;
		retval2 = ft_read(fd2, buffer2, sizeof(buffer2));
		errno2 = errno;
		close(fd1);
		close(fd2);

		assert(memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Read invalid FD
		retval1 = read(123456, buffer1, sizeof(buffer1));
		errno1 = errno;
		retval2 = ft_read(123456, buffer2, sizeof(buffer2));
		errno2 = errno;

		assert(memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Read file without read permission
		fd1 = open("src/ft_read.s", O_WRONLY);
		fd2 = open("src/ft_read.s", O_WRONLY);
		memset(buffer1, 0, sizeof(buffer1));
		memset(buffer2, 0, sizeof(buffer2));
		retval1 = read(fd1, buffer1, sizeof(buffer1));
		errno1 = errno;
		retval2 = ft_read(fd2, buffer2, sizeof(buffer2));
		errno2 = errno;
		close(fd1);
		close(fd2);

		assert(memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Read with size 0
		fd1 = open("src/ft_read.s", O_RDONLY);
		fd2 = open("src/ft_read.s", O_RDONLY);
		memset(buffer1, 0, sizeof(buffer1));
		memset(buffer2, 0, sizeof(buffer2));
		retval1 = read(fd1, buffer1, 0);
		errno1 = errno;
		retval2 = ft_read(fd2, buffer2, 0);
		errno2 = errno;

		assert(memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
		assert(retval1 == retval2);
		assert(errno1 == errno2);
	}
	// write
	{
		int fd1, fd2;
		ssize_t retval1, retval2;
		int errno1, errno2;

		// Write to file
		fd1 = open("output_std.txt", O_RDWR | O_CREAT, 0644);
		fd2 = open("output_ft.txt", O_RDWR | O_CREAT, 0644);
		retval1 = write(fd1, "Hello, world!", 13);
		retval2 = ft_write(fd2, "Hello, world!", 13);

		assert(retval1 == retval2);

		// Write empty string
		retval1 = write(fd1, "", 0);
		errno1 = errno;
		retval2 = ft_write(fd2, "", 0);
		errno2 = errno;

		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Write string but with size 0
		retval1 = write(fd1, "hello, world!", 0);
		errno1 = errno;
		retval2 = ft_write(fd2, "Hello, world!", 0);
		errno2 = errno;

		assert(retval1 == retval2);
		assert(errno1 == errno2);

		close(fd1);
		close(fd2);

		// Write to invalid FD
		retval1 = write(123456, "Hello, world!", 13);
		errno1 = errno;
		retval2 = ft_write(123456, "Hello, world!", 13);
		errno2 = errno;

		assert(retval1 == retval2);
		assert(errno1 == errno2);

		// Write to file without write permission
		fd1 = open("empty_std.txt", O_RDONLY | O_CREAT, 0644);
		fd2 = open("empty_ft.txt", O_RDONLY | O_CREAT, 0644);
		retval1 = write(fd1, "Hello, world!", 13);
		errno1 = errno;
		retval2 = ft_write(fd2, "Hello, world!", 13);
		errno2 = errno;
		close(fd1);
		close(fd2);

		assert(retval1 == retval2);
		assert(errno1 == errno2);
	}
	// strdup
	{
		const char *tests[] = {
			"Coucou",
			"",
			"qwertyuiopasdfghjklzxcvbnmfQWERTYUIOPASDFGHJKLZXCVBNM",
		};
		for (size_t i = 0; i < SIZEOF_ARRAY(tests); ++i)
		{
			char *a = strdup(tests[i]);
			char *b = ft_strdup(tests[i]);
			assert(a != b);
			assert(strcmp(a, b) == 0);
			free(a);
			free(b);
		}
	}
	return 0;
}
