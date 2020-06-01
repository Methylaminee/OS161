/**
 *	@author:Methylamine - Matteo Minotti
 *
 */

#include <types.h>
#include <kern/unistd.h>
#include <clock.h>
#include <copyinout.h>
#include <syscall.h>
#include <lib.h>
#include <proc.h>
#include <current.h>
#include <limits.h>
#include <vfs.h>
#include <vnode.h>
#include <uio.h>

int sys_open(const char *filename, int flags, mode_t mode) {
  struct vnode *v;
  int result;

  struct proc *current = curproc;

  if (current->fd_count >= OPEN_MAX) {
    /* ho già aperto troppi file */
    return -1;
  }

  /* Open the file. */
  result = vfs_open((char*)filename, flags, mode, &v);
  if (result) {
    return -1;
  }

  if (current->open_files == NULL) {
    current->open_files = kmalloc(sizeof(v) * OPEN_MAX);
  }

  current->open_files[current->fd_count] = v;
  kprintf("Opening fd n.%d... (%p)\n", current->fd_count, v);
  return current->fd_count++;
}

void sys_close(int fd) {
  struct vnode *vn = curproc->open_files[fd];
  kprintf("Closing fd n.%d... (%p)\n", fd, vn);
  VOP_DECREF(vn);
  curproc->open_files[fd] = NULL;
}

/**
 * Read syscall
 * @param fd:      file descriptor which has been obtained to open (int value, if 0 => standard input)
 * @param buf:
 * @param count:
 */
int sys_read(int fd, userptr_t buf, size_t size) {
  int i;
  char *bp = (char *) buf;

  if (fd == STDIN_FILENO) {
    for (i=0; i < (int)size; i++) {
      bp[i] = getch();
      if (bp[i] < 0) {
        return i;
      }
    }
    return size;
  } else {
    struct proc *current = curproc;
    struct vnode *v = current->open_files[fd];

    struct iovec iov;
    struct uio u;
    int result;

    kprintf("Reading fd n.%d... (%p)\n", fd, v);
    uio_kinit(&iov, &u, buf, size, 0, UIO_READ);

    result = VOP_READ(v, &u);
    return result;
  }
  return -1;
}

/**
 * Write syscall
 * @param fd:      file descriptor which has been obtained to open (int value, if 0,1,2 => standard input, output, error)
 * @param buf:     it points to a char array, it is the content to be written to the file pointed by fd
 * @param nbytes:  number of bytes to be written from the char array into file pointed by fd
 *
 * @return number of bytes successfully written on file, -1 if error
 */
int sys_write(int fd, userptr_t buf, size_t nbytes) {
  int i;
  char *bp = (char *) buf;

  if (fd == STDOUT_FILENO || fd == STDERR_FILENO) {
    for (i=0; i < (int)nbytes; i++) {
      putch(bp[i]);
    }
    return nbytes;
  } else {
    struct proc *current = curproc;
    struct vnode *v = current->open_files[fd];

    struct iovec iov;
    struct uio u;
    int result;

    kprintf("Writing fd n.%d... (%p)\n", fd, v);
    uio_kinit(&iov, &u, buf, nbytes, 0, UIO_WRITE);

    result = VOP_WRITE(v, &u);
    return result;
  }
  return -1;
}