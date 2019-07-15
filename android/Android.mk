LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

PROJ_DIR := $(LOCAL_PATH)/..
LOCAL_ARM_MODE := arm
LOCAL_MODULE := speexdsp

LOCAL_C_INCLUDES := $(PROJ_DIR) $(PROJ_DIR)/include

LOCAL_CFLAGS := -Wall -fno-strict-aliasing -fvisibility=hidden -DEXPORT=""

DEBUG_CFLAGS    := -D_DEBUG -g
DEBUG_LDFLAGS   := -g

RELEASE_CFLAGS  := -DNDEBUG
RELEASE_LDFLAGS :=

SOURCES := fftwrap.c filterbank.c mdf.c preprocess.c

ifeq ($(TARGET_ARCH_ABI), x86)
 LOCAL_CFLAGS += -DSPEEXDSP_ENABLE_SSE -DFLOATING_POINT -DUSE_SMALLFT
 SOURCES += resample.c smallft.c
else
ifeq ($(TARGET_ARCH_ABI), x86_64)
 LOCAL_CFLAGS += -DSPEEXDSP_ENABLE_SSE -DFLOATING_POINT -DUSE_SMALLFT
 SOURCES += resample.c smallft.c
else
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
 LOCAL_CFLAGS += -DSPEEXDSP_ENABLE_NEON -DFLOATING_POINT -DUSE_SMALLFT
 SOURCES += resample.c.neon smallft.c
else
ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
 LOCAL_CFLAGS += -DFLOATING_POINT -DUSE_SMALLFT
 SOURCES += resample.c smallft.c
else
 LOCAL_CFLAGS += -DFIXED_POINT -DUSE_KISS_FFT
 SOURCES += resample.c kiss_fft.c kiss_fftr.c 
endif
endif
endif
endif

LOCAL_CFLAGS += -DRESAMPLE_FULL_SINC_TABLE

# Additional features, comment if not needed
SOURCES += buffer.c jitter.c scal.c

LOCAL_SRC_FILES := $(addprefix $(PROJ_DIR)/libspeexdsp/, $(SOURCES))

APP_DEBUG := $(strip $(NDK_DEBUG))
ifeq ($(APP_DEBUG),1)
 LOCAL_CFLAGS += $(DEBUG_CFLAGS)
 LOCAL_LDLIBS += $(DEBUG_LDFLAGS)
else
 LOCAL_CFLAGS += $(RELEASE_CFLAGS)
 LOCAL_LDLIBS += $(RELEASE_LDFLAGS)
endif

include $(BUILD_STATIC_LIBRARY)
