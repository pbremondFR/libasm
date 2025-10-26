#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

#define SIZEOF_ARRAY(x) (sizeof(x) / sizeof(x[0]))

extern size_t	ft_strlen(char const *str);
extern char		*ft_strcpy(char *dest, char const *src);
extern int		ft_strcmp(char const *a, char const *b);
extern char		*ft_strdup(const char *str);

int main()
{
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
			// printf("%s\na: %zu, b: %zu\n", tests[i], a, b);
			assert(a == b);
		}
	}
	{
		char dest1[] = "Coucou";
		char dest2[] = "Coucou";
		char *a = strcpy(dest1, "abcdef");
		char *b = ft_strcpy(dest2, "abcdef");
		assert(a == dest1);
		assert(strcmp(dest1, "abcdef") == 0);
		assert(b == dest2);
		assert(strcmp(dest2, "abcdef") == 0);
	}
	{
		const char *tests[] = {
			"ab1", "ab2",
			"HI", "HI",
			"abc", "abcdef",
			"abcdef", "abc",
			"", "",
		};
		for (size_t i = 0; i < SIZEOF_ARRAY(tests); i += 2)
		{
			int a = strcmp(tests[i], tests[i + 1]);
			// printf("COUCOU %d\n", a);
			int b = ft_strcmp(tests[i], tests[i + 1]);
			// printf("COUCOU %s: %d\n", tests[i], b);
			// printf("<%s> / <%s>\na: %d, b: %d\n", tests[i], tests[i + 1], a, b);
			// assert(a == b);
		}
	}
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
