//
// Created by methylamine on 02/04/20.
//

#include <hello.h>
#include <types.h>
#include <lib.h>
#include <mainbus.h>

void hello(void) {
  int ramSize = 0;
  ramSize = mainbus_ramsize() / K;

  kprintf("****************************\n");
  kprintf("Hello OS161, I'm Methylamine\n");
  kprintf("System has %d KB of RAM\n", ramSize);
  kprintf("****************************\n");
}