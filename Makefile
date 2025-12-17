SRC_DIR = src
OBJ_DIR = obj
SRC_FILES = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_read.s ft_write.s ft_strdup.s ft_atoi_base.s
SRC = $(addprefix $(SRC_DIR)/, $(SRC_FILES))
OBJ = $(subst $(SRC_DIR)/, $(OBJ_DIR)/, $(patsubst %.s, %.o, $(SRC)))

TESTER_SRC_DIR = tester_src
TESTER_OBJ_DIR = tester_obj
TESTER_SRC_FILES = tester.c
TESTER_SRC = $(addprefix $(TESTER_SRC_DIR)/, $(TESTER_SRC_FILES))
TESTER_OBJ = $(subst $(TESTER_SRC_DIR)/, $(TESTER_OBJ_DIR)/, $(patsubst %.c, %.o, $(TESTER_SRC)))

ASFLAGS = -felf64 -g
CFLAGS := -Wall -Wextra
LDFLAGS =

# CC ?= cc
# AR ?= ar

TARGET = libasm.a
TESTER_TARGET = tester

$(TARGET): $(OBJ)
	$(AR) rcs $(TARGET) $(OBJ)

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.s
	@mkdir -p $(@D)
	nasm $(ASFLAGS) $< -o $@

$(TESTER_TARGET): $(TARGET) $(TESTER_OBJ)
	$(CC) $(TESTER_OBJ) $(TARGET) -o $(TESTER_TARGET) $(LDFLAGS)

$(TESTER_OBJ_DIR)/%.o : $(TESTER_SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@



all: $(TESTER_TARGET)

re: fclean all

fclean: clean
	rm -rf $(TARGET) $(TESTER_TARGET)

clean:
	rm -rf $(OBJ_DIR) $(TESTER_OBJ_DIR)

# Build the library with FT_DEBUG defined for both asm and C
bonus: ASFLAGS += -DFT_BONUS
bonus: CFLAGS += -DFT_BONUS
bonus: $(TARGET)

# Build the tester with FT_DEBUG defined (affects assembler and C compilation)
tester_bonus: ASFLAGS += -DFT_BONUS
tester_bonus: CFLAGS += -DFT_BONUS
tester_bonus: $(TESTER_TARGET)

.PHONY: clean fclean re all bonus tester_bonus
