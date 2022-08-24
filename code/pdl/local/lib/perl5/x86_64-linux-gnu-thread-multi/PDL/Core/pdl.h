#line 17 "pdl.h.PL"

/*
 * THIS FILE IS GENERATED FROM pdl.h.PL! Do NOT edit!
 */

#ifndef __PDL_H
#define __PDL_H

#include <complex.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>

#define IND_FLAG "td"

#define PDL_DEBUGGING 1

#ifdef PDL_DEBUGGING
extern int pdl_debugging;
#define PDLDEBUG_f(a)           if(pdl_debugging) { a; fflush(stdout); }
#else
#define PDLDEBUG_f(a)
#endif

typedef struct pdl pdl;
#define PDL_TYPELIST_ALL(X) \
 X(PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\
 X(PDL_CF,PDL_CFloat,G,CFloat,(-FLT_MAX - I*FLT_MAX),complex float)\
 X(PDL_CD,PDL_CDouble,C,CDouble,(-DBL_MAX - I*DBL_MAX),complex double)\
 X(PDL_CLD,PDL_CLDouble,H,CLDouble,(-LDBL_MAX - I*LDBL_MAX),complex long double)\


#define PDL_TYPELIST2_ALL(X, X2) \
 X(X2, PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(X2, PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(X2, PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(X2, PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(X2, PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(X2, PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(X2, PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(X2, PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(X2, PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(X2, PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(X2, PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(X2, PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\
 X(X2, PDL_CF,PDL_CFloat,G,CFloat,(-FLT_MAX - I*FLT_MAX),complex float)\
 X(X2, PDL_CD,PDL_CDouble,C,CDouble,(-DBL_MAX - I*DBL_MAX),complex double)\
 X(X2, PDL_CLD,PDL_CLDouble,H,CLDouble,(-LDBL_MAX - I*LDBL_MAX),complex long double)\


#define PDL_TYPELIST2_ALL_(X, X2) \
 X(X2, PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(X2, PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(X2, PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(X2, PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(X2, PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(X2, PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(X2, PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(X2, PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(X2, PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(X2, PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(X2, PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(X2, PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\
 X(X2, PDL_CF,PDL_CFloat,G,CFloat,(-FLT_MAX - I*FLT_MAX),complex float)\
 X(X2, PDL_CD,PDL_CDouble,C,CDouble,(-DBL_MAX - I*DBL_MAX),complex double)\
 X(X2, PDL_CLD,PDL_CLDouble,H,CLDouble,(-LDBL_MAX - I*LDBL_MAX),complex long double)\


#define PDL_TYPELIST_REAL(X) \
 X(PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\


#define PDL_TYPELIST2_REAL(X, X2) \
 X(X2, PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(X2, PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(X2, PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(X2, PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(X2, PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(X2, PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(X2, PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(X2, PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(X2, PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(X2, PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(X2, PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(X2, PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\


#define PDL_TYPELIST_COMPLEX(X) \
 X(PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\


#define PDL_TYPELIST2_COMPLEX(X, X2) \
 X(X2, PDL_SB,PDL_SByte,A,SByte,SCHAR_MIN,signed char)\
 X(X2, PDL_B,PDL_Byte,B,Byte,UCHAR_MAX,unsigned char)\
 X(X2, PDL_S,PDL_Short,S,Short,SHRT_MIN,short)\
 X(X2, PDL_US,PDL_Ushort,U,Ushort,USHRT_MAX,unsigned short)\
 X(X2, PDL_L,PDL_Long,L,Long,INT32_MIN,int32_t)\
 X(X2, PDL_UL,PDL_ULong,K,ULong,UINT32_MAX,uint32_t)\
 X(X2, PDL_IND,PDL_Indx,N,Indx,PTRDIFF_MIN,ptrdiff_t)\
 X(X2, PDL_ULL,PDL_ULongLong,P,ULongLong,UINT64_MAX,uint64_t)\
 X(X2, PDL_LL,PDL_LongLong,Q,LongLong,INT64_MIN,int64_t)\
 X(X2, PDL_F,PDL_Float,F,Float,-FLT_MAX,float)\
 X(X2, PDL_D,PDL_Double,D,Double,-DBL_MAX,double)\
 X(X2, PDL_LD,PDL_LDouble,E,LDouble,-LDBL_MAX,long double)\


#line 69 "pdl.h.PL"

#define X(sym, ...) \
  , sym
typedef enum {
   PDL_INVALID=-1
PDL_TYPELIST_ALL(X)
} pdl_datatypes;
#undef X

#define X(sym, ctype, ppsym, shortctype, defbval, realctype, ...) \
  typedef realctype ctype;
PDL_TYPELIST_ALL(X)
#undef X

typedef union {
#define X(sym, ctype, ppsym, shortctype, defbval, realctype, ...) \
  ctype ppsym;
PDL_TYPELIST_ALL(X)
#undef X
} PDL_Value;

typedef struct {
  pdl_datatypes type;
  PDL_Value value;
} PDL_Anyval;

#define PDL_CHKMAGIC_GENERAL(it,this_magic,type) \
  if((it)->magicno != this_magic) \
    return pdl_make_error(PDL_EFATAL, \
      "INVALID " type " MAGICNO, got hex=%p (%lu)%s\n", \
      it,(unsigned long)((it)->magicno), \
      ((it)->magicno) == PDL_CLEARED_MAGICNO ? " (cleared)" : "" \
    ); \
  else (void)0
#define PDL_CLEARED_MAGICNO 0x99876134 /* value once "cleared" */
#define PDL_CLRMAGIC(it) (it)->magicno = PDL_CLEARED_MAGICNO

#include "pdlbroadcast.h"

/* Auto-PThreading (i.e. multi-threading) settings for PDL functions */
/*  Target number of pthreads: Actual will be this number or less.
    A 0 here means no pthreading */
extern int pdl_autopthread_targ;

/*  Actual number of pthreads: This is the number of pthreads created for the last
    operation where pthreading was used
    A 0 here means no pthreading */
extern int pdl_autopthread_actual;
/* Minimum size of the target PDL involved in pdl function to attempt pthreading (in MBytes )
    For small PDLs, it probably isn't worth starting multiple pthreads, so this variable
    is used to define that threshold (in M-elements, or 2^20 elements ) */
extern int pdl_autopthread_size;
extern PDL_Indx pdl_autopthread_dim;

#define PDL_GENERICSWITCH_CASE(X, symbol, ...) \
  case symbol: { X(symbol, __VA_ARGS__) } break;
#define PDL_GENERICSWITCH(LISTER2, typevar, X2, dflt) \
  switch (typevar) { \
    LISTER2(PDL_GENERICSWITCH_CASE, X2) \
    default: dflt; \
  }
/* extra as first one gets painted blue */
#define PDL_GENERICSWITCH_CASE2(X, symbol, ...) \
  case symbol: { X(symbol, __VA_ARGS__) } break;
/* for use in inner loops avoiding extreme lambda-calculus stuff */
#define PDL_GENERICSWITCH2(LISTER2, typevar, X2, dflt) \
  switch (typevar) { \
    LISTER2(PDL_GENERICSWITCH_CASE2, X2) \
    default: dflt; \
  }
#define PDL_ISNAN_A(x) (0)
#define PDL_ISFINITE_A(x) (1)
#define PDL_ISNAN_B(x) (0)
#define PDL_ISFINITE_B(x) (1)
#define PDL_ISNAN_S(x) (0)
#define PDL_ISFINITE_S(x) (1)
#define PDL_ISNAN_U(x) (0)
#define PDL_ISFINITE_U(x) (1)
#define PDL_ISNAN_L(x) (0)
#define PDL_ISFINITE_L(x) (1)
#define PDL_ISNAN_K(x) (0)
#define PDL_ISFINITE_K(x) (1)
#define PDL_ISNAN_N(x) (0)
#define PDL_ISFINITE_N(x) (1)
#define PDL_ISNAN_P(x) (0)
#define PDL_ISFINITE_P(x) (1)
#define PDL_ISNAN_Q(x) (0)
#define PDL_ISFINITE_Q(x) (1)
#define PDL_ISNAN_F(x) (isnan(x)?1:0)
#define PDL_ISFINITE_F(x) (isfinite(x)?1:0)
#define PDL_ISNAN_D(x) (isnan(x)?1:0)
#define PDL_ISFINITE_D(x) (isfinite(x)?1:0)
#define PDL_ISNAN_E(x) (isnan(x)?1:0)
#define PDL_ISFINITE_E(x) (isfinite(x)?1:0)
#define PDL_ISNAN_G(x) ((isnan(crealf(x)) || isnan(cimagf(x)))?1:0)
#define PDL_ISFINITE_G(x) ((isfinite(crealf(x)) && isfinite(cimagf(x)))?1:0)
#define PDL_ISNAN_C(x) ((isnan(creal(x)) || isnan(cimag(x)))?1:0)
#define PDL_ISFINITE_C(x) ((isfinite(creal(x)) && isfinite(cimag(x)))?1:0)
#define PDL_ISNAN_H(x) ((isnan(creall(x)) || isnan(cimagl(x)))?1:0)
#define PDL_ISFINITE_H(x) ((isfinite(creall(x)) && isfinite(cimagl(x)))?1:0)
#line 154 "pdl.h.PL"
#define ANYVAL_FROM_CTYPE(outany,avtype,inval) do { switch (avtype) { \
case PDL_SB: outany.type = avtype; outany.value.A = (PDL_SByte)(inval); break; \
case PDL_B: outany.type = avtype; outany.value.B = (PDL_Byte)(inval); break; \
case PDL_S: outany.type = avtype; outany.value.S = (PDL_Short)(inval); break; \
case PDL_US: outany.type = avtype; outany.value.U = (PDL_Ushort)(inval); break; \
case PDL_L: outany.type = avtype; outany.value.L = (PDL_Long)(inval); break; \
case PDL_UL: outany.type = avtype; outany.value.K = (PDL_ULong)(inval); break; \
case PDL_IND: outany.type = avtype; outany.value.N = (PDL_Indx)(inval); break; \
case PDL_ULL: outany.type = avtype; outany.value.P = (PDL_ULongLong)(inval); break; \
case PDL_LL: outany.type = avtype; outany.value.Q = (PDL_LongLong)(inval); break; \
case PDL_F: outany.type = avtype; outany.value.F = (PDL_Float)(inval); break; \
case PDL_D: outany.type = avtype; outany.value.D = (PDL_Double)(inval); break; \
case PDL_LD: outany.type = avtype; outany.value.E = (PDL_LDouble)(inval); break; \
case PDL_CF: outany.type = avtype; outany.value.G = (PDL_CFloat)(inval); break; \
case PDL_CD: outany.type = avtype; outany.value.C = (PDL_CDouble)(inval); break; \
case PDL_CLD: outany.type = avtype; outany.value.H = (PDL_CLDouble)(inval); break; \
   default:      outany.type = -1;     outany.value.B = 0; \
  } \
 } while (0)
#line 166 "pdl.h.PL"
#define ANYVAL_TO_CTYPE(outval,ctype,inany) do { switch (inany.type) { \
case PDL_SB: outval = (ctype)(inany.value.A); break; \
case PDL_B: outval = (ctype)(inany.value.B); break; \
case PDL_S: outval = (ctype)(inany.value.S); break; \
case PDL_US: outval = (ctype)(inany.value.U); break; \
case PDL_L: outval = (ctype)(inany.value.L); break; \
case PDL_UL: outval = (ctype)(inany.value.K); break; \
case PDL_IND: outval = (ctype)(inany.value.N); break; \
case PDL_ULL: outval = (ctype)(inany.value.P); break; \
case PDL_LL: outval = (ctype)(inany.value.Q); break; \
case PDL_F: outval = (ctype)(inany.value.F); break; \
case PDL_D: outval = (ctype)(inany.value.D); break; \
case PDL_LD: outval = (ctype)(inany.value.E); break; \
case PDL_CF: outval = (ctype)(inany.value.G); break; \
case PDL_CD: outval = (ctype)(inany.value.C); break; \
case PDL_CLD: outval = (ctype)(inany.value.H); break; \
default:      outval = 0; \
            } \
        } while (0)
#define ANYVAL_FROM_CTYPE_OFFSET(outany,avtype,indata,ioff) do { switch (avtype) { \
case PDL_SB: outany.type = avtype; outany.value.A = (PDL_SByte)((PDL_SByte *)indata)[ioff]; break; \
case PDL_B: outany.type = avtype; outany.value.B = (PDL_Byte)((PDL_Byte *)indata)[ioff]; break; \
case PDL_S: outany.type = avtype; outany.value.S = (PDL_Short)((PDL_Short *)indata)[ioff]; break; \
case PDL_US: outany.type = avtype; outany.value.U = (PDL_Ushort)((PDL_Ushort *)indata)[ioff]; break; \
case PDL_L: outany.type = avtype; outany.value.L = (PDL_Long)((PDL_Long *)indata)[ioff]; break; \
case PDL_UL: outany.type = avtype; outany.value.K = (PDL_ULong)((PDL_ULong *)indata)[ioff]; break; \
case PDL_IND: outany.type = avtype; outany.value.N = (PDL_Indx)((PDL_Indx *)indata)[ioff]; break; \
case PDL_ULL: outany.type = avtype; outany.value.P = (PDL_ULongLong)((PDL_ULongLong *)indata)[ioff]; break; \
case PDL_LL: outany.type = avtype; outany.value.Q = (PDL_LongLong)((PDL_LongLong *)indata)[ioff]; break; \
case PDL_F: outany.type = avtype; outany.value.F = (PDL_Float)((PDL_Float *)indata)[ioff]; break; \
case PDL_D: outany.type = avtype; outany.value.D = (PDL_Double)((PDL_Double *)indata)[ioff]; break; \
case PDL_LD: outany.type = avtype; outany.value.E = (PDL_LDouble)((PDL_LDouble *)indata)[ioff]; break; \
case PDL_CF: outany.type = avtype; outany.value.G = (PDL_CFloat)((PDL_CFloat *)indata)[ioff]; break; \
case PDL_CD: outany.type = avtype; outany.value.C = (PDL_CDouble)((PDL_CDouble *)indata)[ioff]; break; \
case PDL_CLD: outany.type = avtype; outany.value.H = (PDL_CLDouble)((PDL_CLDouble *)indata)[ioff]; break; \
   default:      outany.type = -1;     outany.value.B = 0; \
  } \
 } while (0)
#line 189 "pdl.h.PL"
/* input vars have to be called exactly these as not expanded */
#define ANYVAL_TO_CTYPE_OFFSET_X(datatype, ctype, ...) \
    ANYVAL_TO_CTYPE(((ctype *)x)[ioff], ctype, value);
#define ANYVAL_TO_CTYPE_OFFSET(x,ioff,datatype,value) \
    PDL_GENERICSWITCH(PDL_TYPELIST2_ALL, datatype, ANYVAL_TO_CTYPE_OFFSET_X, return pdl_make_error(PDL_EUSERERROR, "Not a known data type code=%d", datatype))

#define ANYVAL_ISNAN(x) _anyval_isnan(x)
static inline int _anyval_isnan(PDL_Anyval x) {
#define X(datatype, ctype, ppsym, ...) \
  return PDL_ISNAN_ ## ppsym(x.value.ppsym);
  PDL_GENERICSWITCH(PDL_TYPELIST2_ALL, x.type, X, return -1)
#undef X
}

#define ANYVAL_EQ_ANYVAL(x,y) (_anyval_eq_anyval(x,y))
static inline int _anyval_eq_anyval(PDL_Anyval x, PDL_Anyval y) {
#define X_OUTER(datatype_x, ctype_x, ppsym_x, ...) \
  ctype_x cvalue_x = x.value.ppsym_x; \
  PDL_GENERICSWITCH2(PDL_TYPELIST2_ALL_, y.type, X_INNER, return -1)
#define X_INNER(datatype_y, ctype_y, ppsym_y, ...) \
  return (cvalue_x == y.value.ppsym_y) ? 1 : 0;
  PDL_GENERICSWITCH(PDL_TYPELIST2_ALL, x.type, X_OUTER, return -1)
#undef X_INNER
#undef X_OUTER
}

#define ANYVAL_ISBAD(inany,badval) _anyval_isbad(inany,badval)
static inline int _anyval_isbad(PDL_Anyval inany, PDL_Anyval badval) {
  int isnan_badval = ANYVAL_ISNAN(badval);
  if (isnan_badval == -1) return -1;
  return isnan_badval ? ANYVAL_ISNAN(inany) : ANYVAL_EQ_ANYVAL(inany, badval);
}

#define PDL_ISBAD(inval,badval,ppsym) \
  (PDL_ISNAN_ ## ppsym(badval) ? PDL_ISNAN_ ## ppsym(inval) : inval == badval)

typedef struct badvals {
#define X(symbol, ctype, ppsym, shortctype, ...) ctype shortctype;
PDL_TYPELIST_ALL(X)
#undef X
} badvals;

/*
 * Define the pdl C data structure which maps onto the original PDL
 * perl data structure.
 *
 * Note: pdl.sv is defined as a void pointer to avoid having to
 * include perl.h in C code which just needs the pdl data.
 *
 * We start with the meanings of the pdl.flags bitmapped flagset,
 * continue with a prerequisite "trans" structure that represents
 * transformations between linked PDLs, and finish withthe PD
 * structure itself.
*/

#define PDL_NDIMS      6 /* Number of dims[] to preallocate */
#define PDL_NCHILDREN  8 /* Number of trans_children ptrs to preallocate */
#define PDL_NBROADCASTIDS 4 /* Number of different broadcastids/pdl to preallocate */

/* Constants for pdl.state - not all combinations make sense */

  /* data allocated for this pdl.  this implies that the data               */
  /* is up to date if !PDL_PARENTCHANGED                                    */
#define  PDL_ALLOCATED           0x0001
  /* Parent data has been altered without changing this pdl                 */
#define  PDL_PARENTDATACHANGED   0x0002
  /* Parent dims or incs has been altered without changing this pdl.        */
#define  PDL_PARENTDIMSCHANGED   0x0004
  /* Physical data representation of the parent has changed (e.g.           */
  /* physical transposition), so incs etc. need to be recalculated.         */
#define  PDL_ANYCHANGED          (PDL_PARENTDATACHANGED|PDL_PARENTDIMSCHANGED)
  /* Dataflow tracking flags -- F/B for forward/back.  These get set        */
  /* by transformations when they are set up.                               */
#define  PDL_DATAFLOW_F          0x0010
#define  PDL_DATAFLOW_B          0x0020
#define  PDL_DATAFLOW_ANY        (PDL_DATAFLOW_F|PDL_DATAFLOW_B)
  /* Was this PDL null originally?                                          */
#define  PDL_NOMYDIMS            0x0040
  /* Dims should be received via trans.                                     */
#define  PDL_MYDIMS_TRANS        0x0080
  /* OK to attach a vaffine transformation (i.e. a slice)                   */
#define  PDL_OPT_VAFFTRANSOK     0x0100
#define  PDL_OPT_ANY_OK          (PDL_OPT_VAFFTRANSOK)
  /* This is the hdrcpy flag                                                */
#define  PDL_HDRCPY              0x0200
  /* This is a badval flag for this PDL (hmmm -- there is also a flag       */
  /* in the struct itself -- must be clearer about what this is for. --CED) */
#define  PDL_BADVAL              0x0400
  /* Debugging flag                                                         */
#define  PDL_TRACEDEBUG          0x0800
  /* inplace flag                                                           */
#define  PDL_INPLACE             0x1000
  /* Flag indicating destruction in progress                                */
#define         PDL_DESTROYING          0x2000
  /* If this flag is set, you must not alter the data pointer nor           */
  /* free this ndarray nor use datasv (which should be null).                */
  /* This means e.g. that the ndarray is mmapped from a file                 */
#define         PDL_DONTTOUCHDATA       0x4000
  /* whether the given pdl is getting its dims from the given trans */
#define PDL_DIMS_FROM_TRANS(wtrans,pdl) (((pdl)->state & PDL_MYDIMS_TRANS) \
                && (pdl)->trans_parent == (pdl_trans *)(wtrans))

#define PDL_LIST_FLAGS_PDLSTATE(X) \
 X(PDL_ALLOCATED) \
 X(PDL_PARENTDATACHANGED) \
 X(PDL_PARENTDIMSCHANGED) \
 X(PDL_DATAFLOW_F) \
 X(PDL_DATAFLOW_B) \
 X(PDL_NOMYDIMS) \
 X(PDL_MYDIMS_TRANS) \
 X(PDL_OPT_VAFFTRANSOK) \
 X(PDL_HDRCPY) \
 X(PDL_BADVAL) \
 X(PDL_TRACEDEBUG) \
 X(PDL_INPLACE) \
 X(PDL_DESTROYING) \
 X(PDL_DONTTOUCHDATA)

/**************************************************
 *
 * Transformation structure
 *
 * The structure is general enough to deal with functional transforms
 * (which were originally intended) but only slices and retype transforms
 * were implemented.
 *
 */

/* Transformation flags */
#define         PDL_TRANS_DO_BROADCAST     0x0001
#define         PDL_TRANS_BADPROCESS       0x0002
#define         PDL_TRANS_BADIGNORE        0x0004
#define         PDL_TRANS_NO_PARALLEL      0x0008

#define PDL_LIST_FLAGS_PDLVTABLE(X) \
  X(PDL_TRANS_DO_BROADCAST) \
  X(PDL_TRANS_BADPROCESS) \
  X(PDL_TRANS_BADIGNORE) \
  X(PDL_TRANS_NO_PARALLEL)

/* Transpdl flags */
#define         PDL_TPDL_VAFFINE_OK     0x01

typedef struct pdl_trans pdl_trans;

typedef enum {
  PDL_ENONE = 0, /* usable as boolean */
  PDL_EUSERERROR, /* user error, no need to destroy */
  PDL_EFATAL
} pdl_error_type;
typedef struct {
  pdl_error_type error;
  const char *message; /* if error but this NULL, parsing/alloc error */
  char needs_free;
} pdl_error;

typedef struct pdl_transvtable {
        int flags;
        int iflags; /* flags that are starting point for pdl_trans.flags */
        pdl_datatypes *gentypes; /* ordered list of types handled, ending -1 */
        PDL_Indx nparents;
        PDL_Indx npdls;
        char *per_pdl_flags;
        PDL_Indx *par_realdims; /* quantity of dimensions each par has */
        char **par_names;
        short *par_flags;
        pdl_datatypes *par_types;
        PDL_Indx *par_realdim_ind_start; /* each par, where do its inds start in array above */
        PDL_Indx *par_realdim_ind_ids; /* each realdim, which ind is source */
        PDL_Indx nind_ids;
        PDL_Indx ninds;
        char **ind_names; /* sorted names of "indices", eg for a(m), the "m" */
        pdl_error (*redodims)(pdl_trans *tr); /* Only dims and internal trans (makes phys) */
        pdl_error (*readdata)(pdl_trans *tr); /* Only data, to "data" ptr  */
        pdl_error (*writebackdata)(pdl_trans *tr); /* "data" ptr to parent or granny */
        pdl_error (*freetrans)(pdl_trans *tr, char);
        int structsize;
        char *name;                           /* For debuggers, mostly */
} pdl_transvtable;

/* offset into either par_realdim_ind_ids or inc_sizes */
#define PDL_INC_ID(vtable, i, j) \
  ((vtable)->par_realdim_ind_start[i] + j)
/* which ind_id (named dim) for the i-th pdl (aka param) in a vtable, the j-th dim on that param */
#define PDL_IND_ID(vtable, i, j) \
  ((vtable)->par_realdim_ind_ids[PDL_INC_ID(vtable, i, j)])

#define PDL_PARAM_ISREAL             0x0001
#define PDL_PARAM_ISCOMPLEX          0x0002
#define PDL_PARAM_ISTYPED            0x0004
#define PDL_PARAM_ISTPLUS            0x0008
#define PDL_PARAM_ISCREAT            0x0010
#define PDL_PARAM_ISCREATEALWAYS     0x0020
#define PDL_PARAM_ISOUT              0x0040
#define PDL_PARAM_ISTEMP             0x0080
#define PDL_PARAM_ISWRITE            0x0100
#define PDL_PARAM_ISPHYS             0x0200
#define PDL_PARAM_ISIGNORE           0x0400

#define PDL_LIST_FLAGS_PARAMS(X) \
 X(PDL_PARAM_ISREAL) \
 X(PDL_PARAM_ISCOMPLEX) \
 X(PDL_PARAM_ISTYPED) \
 X(PDL_PARAM_ISTPLUS) \
 X(PDL_PARAM_ISCREAT) \
 X(PDL_PARAM_ISCREATEALWAYS) \
 X(PDL_PARAM_ISOUT) \
 X(PDL_PARAM_ISTEMP) \
 X(PDL_PARAM_ISWRITE) \
 X(PDL_PARAM_ISPHYS) \
 X(PDL_PARAM_ISIGNORE)

/* All trans must start with this */

/* Trans flags */

        /* Reversible transform -- flag indicates data can flow both ways.  */
        /* This is critical in routines that both input from and output to  */
        /* a non-single-valued pdl: updating must occur.  (Note that the    */
        /* transform is not necessarily mathematically reversible)          */
#define  PDL_ITRANS_TWOWAY        0x0001
        /* Whether, if a child is changed, this trans should be destroyed or not */
        /* (flow if set; sever if clear) */
#define  PDL_ITRANS_DO_DATAFLOW_F     0x0002
#define  PDL_ITRANS_DO_DATAFLOW_B     0x0004
#define  PDL_ITRANS_DO_DATAFLOW_ANY   (PDL_ITRANS_DO_DATAFLOW_F|PDL_ITRANS_DO_DATAFLOW_B)

#define  PDL_ITRANS_ISAFFINE          0x1000

#define PDL_LIST_FLAGS_PDLTRANS(X) \
 X(PDL_ITRANS_TWOWAY) \
 X(PDL_ITRANS_DO_DATAFLOW_F) \
 X(PDL_ITRANS_DO_DATAFLOW_B) \
 X(PDL_ITRANS_ISAFFINE)

#define PDL_MAXSPACE 256 /* maximal number of prefix spaces in dump routines */
#define PDL_MAXLIN 60

// These define struct pdl_trans and all derived structures. There are many
// structures that defined in other parts of the code that can be referenced
// like a pdl_trans* because all of these structures have the same pdl_trans
// initial piece. These structures can contain multiple pdl* elements in them.
// Thus pdl_trans itself ends with a flexible pdl*[] array, which can be used to
// reference any number of pdl objects. As a result pdl_trans itself can NOT be
// instantiated

#define PDL_TRANS_START_COMMON                                          \
  unsigned int magicno;                                                 \
  short flags;                                                          \
  pdl_transvtable *vtable;                                              \
  int bvalflag;                                                         \
  pdl_broadcast broadcast;                                              \
  PDL_Indx *ind_sizes;                                                  \
  PDL_Indx *inc_sizes;                                                  \
  char dims_redone;                                                     \
  PDL_Indx *incs; PDL_Indx offs; /* only used for affine */             \
  void *params;                                                         \
  pdl_datatypes __datatype

#define PDL_TRANS_START(np) \
  PDL_TRANS_START_COMMON; \
  /* The pdls involved in the transformation */ \
  pdl *pdls[np]

#define PDL_TRANS_START_FLEXIBLE() \
  PDL_TRANS_START_COMMON; \
  /* The pdls involved in the transformation */ \
  pdl *pdls[]

#define PDL_TR_MAGICNO      0x91827364
#define PDL_TR_CHKMAGIC(it) PDL_CHKMAGIC_GENERAL(it, PDL_TR_MAGICNO, "TRANS")
#define PDL_TR_SETMAGIC(it) (it)->magicno = PDL_TR_MAGICNO

// This is a generic parent of all the trans structures. It is a flexible array
// (can store an arbitrary number of pdl objects). Thus this can NOT be
// instantiated, only "child" structures can
struct pdl_trans {
  PDL_TRANS_START_FLEXIBLE();
} ;

typedef struct pdl_vaffine {
	PDL_TRANS_START(2);
	PDL_Indx ndims;
	pdl *from;
} pdl_vaffine;

#define PDL_VAFFOK(pdl) (pdl->state & PDL_OPT_VAFFTRANSOK)
#define PDL_REPRINCS(pdl) (PDL_VAFFOK(pdl) ? pdl->vafftrans->incs : pdl->dimincs)
#define PDL_REPRINC(pdl,which) (PDL_REPRINCS(pdl)[which])

#define PDL_REPROFFS(pdl) (PDL_VAFFOK(pdl) ? pdl->vafftrans->offs : 0)

#define PDL_REPRP(pdl) (PDL_VAFFOK(pdl) ? pdl->vafftrans->from->data : pdl->data)

#define PDL_TR_VAFFOK(flag) (flag & PDL_TPDL_VAFFINE_OK)
#define PDL_REPRP_TRANS(pdl,flag) ((PDL_VAFFOK(pdl) && \
      PDL_TR_VAFFOK(flag)) ? pdl->vafftrans->from->data : pdl->data)
#define VAFFINE_FLAG_OK(flags,i) ((flags == NULL) ? 1 : PDL_TR_VAFFOK(flags[i]))

typedef struct pdl_trans_children {
        pdl_trans *trans[PDL_NCHILDREN];
        struct pdl_trans_children *next;
} pdl_trans_children;

struct pdl_magic;

/****************************************
 * PDL structure
 * Should be kept under 250 bytes if at all possible, for
 * easier segmentation...
 * See current size (360 bytes at time of writing) with:
      perl -Mblib -MInline=with,PDL \
        -MInline=C,'size_t f() { return sizeof(struct pdl); }' -e 'die f()'
 *
 * The 'sv', 'datasv', and 'hdrsv' fields are all void * to avoid having to
 * load perl.h for C codes that only use PDLs and not the Perl API.
 *
 * Similarly, the 'magic' field is void * to avoid having to typedef pdl_magic
 * here -- it is declared in "pdl_magic.h".
 */

#define PDL_MAGICNO 0x24645399
#define PDL_CHKMAGIC(it) PDL_CHKMAGIC_GENERAL(it,PDL_MAGICNO,"PDL")
#define PDL_SETMAGIC(it) (it)->magicno = PDL_MAGICNO

struct pdl {
   unsigned long magicno; /* Always stores PDL_MAGICNO as a sanity check */
     /* This is first so most pointer accesses to wrong type are caught */
   int state;        /* What's in this pdl */

   pdl_trans *trans_parent; /* Opaque pointer to internals of transformation from
                        parent */

   pdl_vaffine *vafftrans; /* pointer to vaffine transformation
                              a vafftrans is an optimization that is possible
                              for some types of trans (slice etc)
                              - unused for non-affine transformations
                            */

   void*    sv;      /* (optional) pointer back to original sv.
                          ALWAYS check for non-null before use.
                          We cannot inc refcnt on this one or we'd
                          never get destroyed */
   void *datasv;        /* Pointer to SV containing data. We own one inc of refcnt */
   void *data;            /* Pointer to actual data (in SV), or NULL if we have no data      */
   PDL_Anyval badvalue; /* BAD value is stored as a PDL_Anyval for portability */
   int has_badvalue;     /* whether this pdl has non-default badval */
   PDL_Indx nvals; /* Real number of elements (not quite nelem in case of dummy) */
   PDL_Indx nbytes; /* number of bytes allocated in data */
   pdl_datatypes datatype; /* One of the usual suspects (PDL_L, PDL_D, etc.) */
   PDL_Indx   *dims;      /* Array of data dimensions - could point below or to an allocated array */
   PDL_Indx   *dimincs;   /* Array of data default increments, aka strides through memory for each dim (0 for dummies) */
   PDL_Indx    ndims;     /* Number of data dimensions in dims and dimincs */

   PDL_Indx *broadcastids;  /* Starting index of the broadcast index set n */
   PDL_Indx nbroadcastids;

   pdl_trans_children trans_children;

   PDL_Indx   def_dims[PDL_NDIMS];   /* Preallocated space for efficiency */
   PDL_Indx   def_dimincs[PDL_NDIMS];   /* Preallocated space for efficiency */
   PDL_Indx   def_broadcastids[PDL_NBROADCASTIDS];

   struct pdl_magic *magic;

   void *hdrsv; /* "header", settable from Perl */
   PDL_Value value; /* to store at least one value */
};

typedef struct pdl_slice_args {
  PDL_Indx start; /* maps to start index of slice range (inclusive) */
  PDL_Indx end; /* maps to end index of slice range (inclusive) */
  PDL_Indx inc; /* maps to increment of slice range */
  char dummy, squish; /* boolean */
  struct pdl_slice_args *next; /* NULL is last */
} pdl_slice_args;

/*************
 * Some macros for looping over the trans_children of a given PDL
 */
#define PDL_DECL_CHILDLOOP(p) \
                int p##__i; pdl_trans_children *p##__c;
#define PDL_START_CHILDLOOP(p) \
                p##__c = &p->trans_children; \
                do { \
                        for(p##__i=0; p##__i<PDL_NCHILDREN; p##__i++) { \
                                if(p##__c->trans[p##__i]) {
#define PDL_CHILDLOOP_THISCHILD(p) p##__c->trans[p##__i]
#define PDL_END_CHILDLOOP(p) \
                                } \
                        } \
                        if(!p##__c) break; \
                        if(!p##__c->next) break; \
                        p##__c=p##__c->next; \
                } while(1);

#define PDL_USESTRUCTVALUE(it) \
        (it->nbytes <= sizeof(it->value))

#define PDLMAX(a,b) ((a) > (b) ? (a) : (b))
#define PDLMIN(a,b) ((a) < (b) ? (a) : (b))

#define PDL_RETERROR2(rv, expr, iferr) \
  do { rv = expr; if (rv.error) { iferr } } while (0)
#define PDL_RETERROR(rv, expr) PDL_RETERROR2(rv, expr, return rv;)
#define PDL_ACCUMERROR(rv, expr) rv = pdl_error_accumulate(rv, expr)

#define PDL_ENSURE_ALLOCATED(it) \
  if (!(it->state & PDL_ALLOCATED)) { \
    PDL_RETERROR(PDL_err, pdl_allocdata(it)); \
  }

/* for use with PDL_TYPELIST_REAL */
#define PDL_QSORT(symbol, ctype, ppsym, ...) \
  static inline void qsort_ ## ppsym(ctype* xx, PDL_Indx a, PDL_Indx b) { \
     PDL_Indx i,j; \
     ctype t, median; \
     i = a; j = b; \
     median = xx[(i+j) / 2]; \
     do { \
        while (xx[i] < median) \
           i++; \
        while (median < xx[j]) \
           j--; \
        if (i <= j) { \
           t = xx[i]; xx[i] = xx[j]; xx[j] = t; \
           i++; j--; \
        } \
     } while (i <= j); \
     if (a < j) \
        qsort_ ## ppsym(xx,a,j); \
     if (i < b) \
        qsort_ ## ppsym(xx,i,b); \
  }

#define PDL_EXPAND(...) __VA_ARGS__
#define PDL_BROADCASTLOOP_START(funcName, brc, vtable, ptrStep1, ptrStep2, ptrStep3) \
  __brcloopval = PDL->startbroadcastloop(&(brc),(vtable)->funcName, __privtrans, &PDL_err); \
  if (PDL_err.error) return PDL_err; \
  if ( __brcloopval < 0 ) return PDL->make_error_simple(PDL_EFATAL, "Error starting broadcastloop"); \
  if ( __brcloopval ) return PDL_err; \
  do { \
    PDL_Indx *__tdims = PDL->get_broadcastdims(&(brc)); \
    if (!__tdims) return PDL->make_error_simple(PDL_EFATAL, "Error in get_broadcastdims"); \
    register PDL_Indx __tdims0 = __tdims[0]; \
    register PDL_Indx __tdims1 = __tdims[1]; \
    register PDL_Indx *__offsp = PDL->get_threadoffsp(&(brc)); \
    if (!__offsp ) return PDL->make_error_simple(PDL_EFATAL, "Error in get_threadoffsp"); \
    PDL_COMMENT("incs are each pdl's stride, declared at func start") \
    PDL_COMMENT("offs are each pthread's starting offset into each pdl") \
    ptrStep1 \
    for( __tind1 = 0 ; \
      __tind1 < __tdims1 ; \
      __tind1++ \
      PDL_COMMENT("step by tinc1, undoing inner-loop of tinc0*tdims0") \
      PDL_EXPAND ptrStep2 \
    ) \
    { \
      for( __tind0 = 0 ; \
        __tind0 < __tdims0 ; \
        __tind0++ \
        PDL_EXPAND ptrStep3 \
      ) { \
        PDL_COMMENT("This is the tightest loop. Make sure inside is optimal.")
#define PDL_BROADCASTLOOP_END(brc, ptrStep1) \
      } \
    } \
    PDL_COMMENT("undo outer-loop of tinc1*tdims1, and original per-pthread offset") \
    ptrStep1 \
    __brcloopval = PDL->iterbroadcastloop(&(brc),2); \
    if ( __brcloopval < 0 ) return PDL->make_error_simple(PDL_EFATAL, "Error in iterbroadcastloop"); \
  } while(__brcloopval);

/* __PDL_H */
#endif

