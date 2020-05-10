/*
 * Copyright (c) 2000, 2001, 2002, 2003, 2004, 2005, 2008, 2009
 *	Methylamine - Matteo Minotti
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the owner nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE UNIVERSITY AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <types.h>
#include <kern/unistd.h>
#include <clock.h>
#include <copyinout.h>
#include <syscall.h>
#include <lib.h>
#include <proc.h>
#include <thread.h>
#include <addrspace.h>
#include <current.h>
#include <synch.h>
#include "opt-waitpid.h"

void save_status(int status) {
  struct thread *curThread = curthread;
  struct proc *curProc = curproc;

  curThread->t_exitStatus = status;
  curProc->p_exitStatus = status;
}

#ifdef OPT_WAITPID
int sys_waitpid(pid_t pid) {
  /*if (pid_table != NULL) {
    struct proc *p = pid_table[pid];
    return proc_wait(p);
  }*/
  return pid;
}
#endif

void sys__exit(int status) {

  save_status(status);

#ifdef OPT_WAITPID
  struct proc *p = curproc;
  lock_acquire(p->p_exit_lk);
  cv_signal(p->p_exit_cv, p->p_exit_lk);
  proc_remthread(curthread);
  lock_release(p->p_exit_lk);

#else
  // get current process address space, null if no proc
  struct addrspace *as = proc_getas();
  as_destroy(as);
#endif

  thread_exit();
  // thread_exit doesn't return, so if I can read this, there's a problem
  panic("thread_exit returned?!?!\n");
  (void) status;
}

