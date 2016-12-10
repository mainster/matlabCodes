/*
 * File: ert_main.c
 *
 * Code generated for Simulink model 'spiBitbangSimulink'.
 *
 * Model version                  : 1.15
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Sat Apr 19 21:32:51 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <semaphore.h>
#include <errno.h>
#include <signal.h>
#include <time.h>
#include "spiBitbangSimulink.h"
#include "spiBitbangSimulink_private.h"
#include "rtwtypes.h"

typedef struct {
  int signo;
  sigset_t sigMask;
  double period;
} baseRateInfo_t;

void MW_blockSignal(int sigNo, sigset_t *sigMask);
void MW_setTaskPeriod(double periodInSeconds, int sigNo);
void MW_sigWait(sigset_t *sigMask);
void MW_exitHandler(int sig);
void MW_sem_wait(sem_t *sem);

#define CHECK_STATUS(status, fcn)      if (status != 0) {printf("Call to %s returned error status (%d).\n", fcn, status); perror(fcn); fflush(stdout); exit(EXIT_FAILURE);}

/* Semaphore(s) used for thread synchronization */
sem_t stopSem;
sem_t subrateTaskSem[1];
int taskId[1];
void subrateTask(void *arg)
{
  int tid = *((int *) arg);
  int subRateId;
  subRateId = tid + 1;
  while (1) {
    MW_sem_wait(&subrateTaskSem[tid]);
    switch (subRateId) {
     case 1:
      spiBitbangSimulink_output1();

      /* Get model outputs here */
      spiBitbangSimulink_update1();
      break;

     default:
      break;
    }
  }
}                                      /* subrateTask */

void baseRateTask(void *arg)
{
  baseRateInfo_t info = *((baseRateInfo_t *)arg);
  MW_setTaskPeriod(info.period, info.signo);
  while (rtmGetErrorStatus(spiBitbangSimulink_M) == (NULL) ) {
    /* Wait for the next timer interrupt */
    MW_sigWait(&info.sigMask);
    if (rtmStepTask(spiBitbangSimulink_M, 1)
        ) {
      sem_post(&subrateTaskSem[0]);
    }

    spiBitbangSimulink_output0();

    /* Get model outputs here */
    spiBitbangSimulink_update0();
  }                                    /* while */

  sem_post(&stopSem);
}                                      /* baseRateTask */

void MW_sem_wait(sem_t *sem)
{
  int status;
  while (((status = sem_wait(sem)) == -1) && (errno == EINTR)) {
    /* Restart if interrupted by a signal */
    continue;
  }

  CHECK_STATUS(status, "sem_wait");
}

void MW_exitHandler(int sig)
{
  sem_post(&stopSem);
}

void MW_blockSignal(int sigNo, sigset_t *sigMask)
{
  int ret;
  sigaddset(sigMask, sigNo);
  ret = pthread_sigmask(SIG_BLOCK, sigMask, NULL);
  CHECK_STATUS(ret, "pthread_sigmask");
}

void MW_setTaskPeriod(double periodInSeconds, int sigNo)
{
  timer_t timerId;
  struct sigevent sev;
  struct itimerspec its;
  long stNanoSec;
  int ret;

  /* Create a timer */
  sev.sigev_notify = SIGEV_SIGNAL;
  sev.sigev_signo = sigNo;
  sev.sigev_value.sival_ptr = &timerId;
  ret = timer_create(CLOCK_REALTIME, &sev, &timerId);
  CHECK_STATUS(ret, "timer_create");

  /* Arm real-time scheduling timer */
  stNanoSec = (long)(periodInSeconds * 1e9);
  its.it_value.tv_sec = stNanoSec / 1000000000;
  its.it_value.tv_nsec = stNanoSec % 1000000000;
  its.it_interval.tv_sec = its.it_value.tv_sec;
  its.it_interval.tv_nsec = its.it_value.tv_nsec;
  ret = timer_settime(timerId, 0, &its, NULL);
  CHECK_STATUS(ret, "timer_settime");
}

void MW_sigWait(sigset_t *sigMask)
{
  int ret;
  while (((ret = sigwaitinfo(sigMask, NULL)) == -1) && (errno == EINTR)) {
    /* Restart if interrupted by a signal other than the one we
       are waiting on */
    continue;
  }
}

int main(int argc, char **argv)
{
  int i;
  pthread_t subRateThread[1];
  uid_t euid;
  struct sched_param sp;
  int ret;
  baseRateInfo_t info;
  pthread_attr_t attr;
  pthread_t baseRateThread;
  size_t stackSize;
  unsigned long cpuMask = 0x1;
  unsigned int len = sizeof(cpuMask);
  printf("**starting the model**\n");
  fflush(stdout);
  rtmSetErrorStatus(spiBitbangSimulink_M, 0);

  /* Unused arguments */
  (void)(argc);
  (void)(argv);

  /* All threads created by this process must run on a single CPU */
  ret = sched_setaffinity(0, len, (cpu_set_t *) &cpuMask);
  CHECK_STATUS(ret, "sched_setaffinity");

#if !defined (_POSIX_THREAD_PRIORITY_SCHEDULING)

  printf("Priority scheduling is NOT supported by your system.\n");
  printf("The generated code will not run correctly because your\n");
  printf("model contains multiple rates and uses multi-tasking\n");
  printf("code generation mode. You can only run the generated code\n");
  printf("in single-tasking mode in your system. Open\n");
  printf("Simulation -> Configuration Parameters -> Solver dialog\n");
  printf("and set \"Tasking mode for periodic sample times\" parameter to SingleTasking.\n");
  printf("Re-build the Simulink model with the new settings and try executing the generated code again.\n");
  fflush(stdout);
  exit(EXIT_FAILURE);

#endif

  /* Need root privileges for real-time scheduling */
  euid = geteuid();
  if (euid != 0) {
    printf("You must have root privileges to run the generated code because\n");
    printf("generated code requires SCHED_FIFO scheduling class to run correctly.\n");
    printf("Try running the executable with the following command: sudo ./<executable name>\n");
    fflush(stdout);
    exit(EXIT_FAILURE);
  }

  /* Set scheduling policy of the main thread to SCHED_FIFO */
  sp.sched_priority = sched_get_priority_max(SCHED_FIFO);
  ret = sched_setscheduler(0, SCHED_FIFO, &sp);
  CHECK_STATUS(ret, "sched_setscheduler");

  /* Initialize semaphore used for thread synchronization */
  ret = sem_init(&stopSem, 0, 0);
  CHECK_STATUS(ret, "sem_init:stopSem");

  /* Create threads executing the Simulink model */
  pthread_attr_init(&attr);
  ret = pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
  CHECK_STATUS(ret, "pthread_attr_setinheritsched");
  ret = pthread_attr_setschedpolicy(&attr, SCHED_FIFO);
  CHECK_STATUS(ret, "pthread_attr_setschedpolicy");
  ret = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
  CHECK_STATUS(ret, "pthread_attr_setdetachstate");

  /* PTHREAD_STACK_MIN is the minimum stack size required to start a thread */
  stackSize = 64000 + PTHREAD_STACK_MIN;
  ret = pthread_attr_setstacksize(&attr, stackSize);
  CHECK_STATUS(ret, "pthread_attr_setstacksize");

  /* Block signal used for timer notification */
  info.period = 1.0000000000000001E-7;
  info.signo = SIGRTMIN;
  sigemptyset(&info.sigMask);
  MW_blockSignal(info.signo, &info.sigMask);
  signal(SIGTERM, MW_exitHandler);     /* kill */
  signal(SIGHUP, MW_exitHandler);      /* kill -HUP */
  signal(SIGINT, MW_exitHandler);      /* Interrupt from keyboard */
  signal(SIGQUIT, MW_exitHandler);     /* Quit from keyboard */
  spiBitbangSimulink_initialize();
  for (i = 0; i < (1); i++) {
    taskId[i] = i;
    ret = sem_init(&subrateTaskSem[i], 0, 0);
    CHECK_STATUS(ret, "sem_init");
    sp.sched_priority = 40 - 1;
    ret = pthread_attr_setschedparam(&attr, &sp);
    CHECK_STATUS(ret, "pthread_attr_setschedparam");
    ret = pthread_create(&subRateThread[i], &attr, (void *) subrateTask, (void *)
                         &taskId[i]);
    CHECK_STATUS(ret,"pthread_create");
  }

  /* Create base rate task */
  sp.sched_priority = 40;
  ret = pthread_attr_setschedparam(&attr, &sp);
  CHECK_STATUS(ret, "pthread_attr_setschedparam");
  ret = pthread_create(&baseRateThread, &attr, (void *) baseRateTask, (void *)
                       &info);
  CHECK_STATUS(ret, "pthread_create");
  pthread_attr_destroy(&attr);

  /* Wait for a stopping condition. */
  MW_sem_wait(&stopSem);

  /* Received stop signal */
  printf("**stopping the model**\n");
  if (rtmGetErrorStatus(spiBitbangSimulink_M) != NULL) {
    printf("\n**%s**\n", rtmGetErrorStatus(spiBitbangSimulink_M));
  }

  /* Disable rt_OneStep() here */

  /* Terminate model */
  spiBitbangSimulink_terminate();
  return 0;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
