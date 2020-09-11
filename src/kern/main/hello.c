//
// Created by methylamine on 02/04/20.
//

#include <hello.h>
#include <types.h>
#include <lib.h>
#include <mainbus.h>

void hello(void) {
  int ramSize = 0;
  ramSize = mainbus_ramsize() / (K*K);

  kprintf("********************************************\n");
  kprintf("        Hello OS161, I'm Methylamine        \n");
  kprintf("      System has %dMB of RAM - [%dKB]\n", ramSize, ramSize * K);
  kprintf("********************************************\n");
}