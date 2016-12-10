/*
 * Discrete_sid.h
 *
 * Code generation for model "Discrete_sf".
 *
 * Model version              : 1.69
 * Simulink Coder version : 8.5 (R2013b) 08-Aug-2013
 * C source code generated on : Thu Apr 24 03:20:16 2014
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 *
 * SOURCES: Discrete_sf.c
 */

/* statically allocated instance data for model: Discrete */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_Discrete_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_Discrete_T));
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 1892397312U);
    ssSetChecksumVal(rts, 1, 909323823U);
    ssSetChecksumVal(rts, 2, 851504131U);
    ssSetChecksumVal(rts, 3, 731764447U);
  }
}
