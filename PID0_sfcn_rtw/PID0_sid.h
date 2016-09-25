/*
 * PID0_sid.h
 *
 * Code generation for model "PID0_sf".
 *
 * Model version              : 1.32
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Jul 20 07:34:52 2014
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 *
 * SOURCES: PID0_sf.c
 */

/* statically allocated instance data for model: PID0 */
{
  {
    /* Local SimStruct for the generated S-Function */
    static LocalS slS;
    LocalS *lS = &slS;
    ssSetUserData(rts, lS);

    /* block I/O */
    {
      static B_PID0_T sfcnB;
      void *b = (real_T *) &sfcnB;
      ssSetLocalBlockIO(rts, b);
      (void) memset(b, 0,
                    sizeof(B_PID0_T));
    }

    /* model checksums */
    ssSetChecksumVal(rts, 0, 105880331U);
    ssSetChecksumVal(rts, 1, 3332762590U);
    ssSetChecksumVal(rts, 2, 1607264141U);
    ssSetChecksumVal(rts, 3, 793156340U);
  }
}
