
ifndef BUILD_TARGET
	$(error "BUILD_TARGET is not available! You can pass it as environment variable by typing BUILD_TARGET=...")
endif

CC := $(BUILD_TARGET)-gcc

BASE_DIRECTORY := $(PWD)

OBJECTS_DIRECTORY := $(BASE_DIRECTORY)/build
RELEASE_DIRECTORY := $(BASE_DIRECTORY)/release