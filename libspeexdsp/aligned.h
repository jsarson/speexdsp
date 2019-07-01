#ifndef _SPEEXDSP_ALIGNED_H
#define _SPEEXDSP_ALIGNED_H

#ifdef __GNUC__
#define ALIGNED(a) __attribute__ ((__aligned__(a)))
#elif defined(_MSC_VER)
#define ALIGNED(a) __declspec(align(a))
#else
#warning Unknown compiler
#define ALIGNED(a)
#endif

#endif
