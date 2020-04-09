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
  }
  kprintf("sys_read supports only stdin\n");
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
  }
  kprintf("sys_write supports only stdout or stderr\n");
  return -1;
}