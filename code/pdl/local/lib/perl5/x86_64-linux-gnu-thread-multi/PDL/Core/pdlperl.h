#line 14 "pdlperl.h.PL"
/*
 * THIS FILE IS GENERATED FROM pdlperl.h.PL! Do NOT edit!
 */

#ifndef __PDLPERL_H
#define __PDLPERL_H

#define PDL_XS_SCALAR(type, val) \
  PDL_Anyval av; \
  ANYVAL_FROM_CTYPE(av,type,val); \
  pdl *b = pdl_scalar(av); \
  if (!b) XSRETURN_UNDEF; \
  SV *b_SV = sv_newmortal(); \
  pdl_SetSV_PDL(b_SV, b); \
  EXTEND(SP, 1); \
  ST(0) = b_SV; \
  XSRETURN(1);

#define PDL_MAKE_PERL_COMPLEX(output,r,i) { \
        dSP; int count; double rval = r, ival = i; SV *ret; \
        ENTER; SAVETMPS; PUSHMARK(sp); \
        perl_require_pv("PDL/Complex/Overloads.pm"); \
        mXPUSHn(rval); \
        mXPUSHn(ival); \
        PUTBACK; \
        count = perl_call_pv("PDL::Complex::Overloads::cplx", G_SCALAR); \
        SPAGAIN; \
        if (count != 1) croak("Failed to create PDL::Complex::Overloads object (%.9g, %.9g)", rval, ival); \
        ret = POPs; \
        SvREFCNT_inc(ret); \
        output = ret; \
        PUTBACK; FREETMPS; LEAVE; \
}

/***************
 * So many ways to be undefined...
 */
#define PDL_SV_IS_UNDEF(sv)  ( (!(sv) || ((sv)==&PL_sv_undef)) || !(SvNIOK(sv) || (SvTYPE(sv)==SVt_PVMG) || SvPOK(sv) || SvROK(sv)))

#define ANYVAL_FROM_SV(outany,insv,use_undefval,forced_type) do { \
    SV *sv2 = insv; \
    if (PDL_SV_IS_UNDEF(sv2)) { \
        if (!use_undefval) { \
            outany.type = forced_type >=0 ? forced_type : -1; \
            outany.value.B = 0; \
            break; \
        } \
        sv2 = get_sv("PDL::undefval",1); \
        if(SvIV(get_sv("PDL::debug",1))) \
            fprintf(stderr,"Warning: SvPDLV converted undef to $PDL::undefval (%g).\n",SvNV(sv2)); \
        if (PDL_SV_IS_UNDEF(sv2)) { \
            outany.type = forced_type >=0 ? forced_type : PDL_B; \
            outany.value.B = 0; \
            break; \
        } \
    } \
    if (sv_derived_from(sv2, "PDL")) { \
        pdl *it = PDL_CORE_(SvPDLV)(sv2); \
        outany = PDL_CORE_(at0)(it); \
        if (outany.type < 0) croak("Position out of range"); \
    } else if (!SvIOK(sv2)) { /* Perl Double (e.g. 2.0) */ \
        NV tmp_NV = SvNV(sv2); \
        int datatype = forced_type >=0 ? forced_type : _pdl_whichdatatype_double(tmp_NV); \
        ANYVAL_FROM_CTYPE(outany, datatype, tmp_NV); \
    } else { /* Perl Int (e.g. 2) */ \
        IV tmp_IV = SvIV(sv2); \
        int datatype = forced_type >=0 ? forced_type : _pdl_whichdatatype(tmp_IV); \
        ANYVAL_FROM_CTYPE(outany, datatype, tmp_IV); \
    } \
} while (0)

#define ANYVAL_TO_SV(outsv,inany) do { switch (inany.type) { \
case PDL_SB: outsv = newSViv( (IV)(inany.value.A) ); break; \
case PDL_B: outsv = newSViv( (IV)(inany.value.B) ); break; \
case PDL_S: outsv = newSViv( (IV)(inany.value.S) ); break; \
case PDL_US: outsv = newSViv( (IV)(inany.value.U) ); break; \
case PDL_L: outsv = newSViv( (IV)(inany.value.L) ); break; \
case PDL_UL: outsv = newSViv( (IV)(inany.value.K) ); break; \
case PDL_IND: outsv = newSViv( (IV)(inany.value.N) ); break; \
case PDL_ULL: outsv = newSViv( (IV)(inany.value.P) ); break; \
case PDL_LL: outsv = newSViv( (IV)(inany.value.Q) ); break; \
case PDL_F: outsv = newSVnv( (NV)(inany.value.F) ); break; \
case PDL_D: outsv = newSVnv( (NV)(inany.value.D) ); break; \
case PDL_LD: outsv = newSVnv( (NV)(inany.value.E) ); break; \
case PDL_CF: PDL_MAKE_PERL_COMPLEX(outsv, crealf(inany.value.G), cimagf(inany.value.G)); break; \
case PDL_CD: PDL_MAKE_PERL_COMPLEX(outsv, creal(inany.value.C), cimag(inany.value.C)); break; \
case PDL_CLD: PDL_MAKE_PERL_COMPLEX(outsv, creall(inany.value.H), cimagl(inany.value.H)); break; \
   default:      outsv = &PL_sv_undef; \
  } \
 } while (0)
#line 106 "pdlperl.h.PL"
/* Check minimum datatype required to represent number */
#define PDL_TESTTYPE(sym, ctype, v) {ctype foo = v; if (v == foo) return sym;}
static inline int _pdl_whichdatatype (IV iv) {
#define X(sym, ctype, ...) \
  PDL_TESTTYPE(sym, ctype, iv)
   PDL_TYPELIST_ALL(X)
#undef X
        croak("Something's gone wrong: %lld cannot be converted by whichdatatype", (long long)iv);
}
/* Check minimum, at least double, datatype required to represent number */
static inline int _pdl_whichdatatype_double (NV nv) {
        PDL_TESTTYPE(PDL_D,PDL_Double, nv)
        PDL_TESTTYPE(PDL_D,PDL_LDouble, nv)
#undef PDL_TESTTYPE
        /* Default return type PDL_Double */
        return PDL_D;
}

/* __PDLPERL_H */
#endif
