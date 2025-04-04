/*
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 */

/* clang-format off */

/*	stat3f.c - Implements 64-bit LIB3F stat subprogram.  */

/* must include ent3f.h AFTER io3f.h */
#include <sys/stat.h>
#include "io3f.h"
#include "ent3f.h"
#include "utils3f.h"

int ENT3F(STAT64, stat64)(DCHAR(nm), long long *statb DCLEN(nm))
{
#if defined(TARGET_WIN) || defined(_WIN64)
  /*
   * The __int64_t members in the _stat64 are 8-byte aligned, thus the
   * st_size member is at offset 24. On WIN32, 64-bit ints are 4-byte
   * aligned, so st_size shows up at offset 20!. The correct solution is
   * to use or make default -Mllalign, but that's not in the picture.
   * So, just declare a replacement struct which explicitly pad members
   * the members line up with the _stat64 struct.
   */
  struct {
    int st_dev;       /*  0 */
    short st_ino;     /*  4 */
    short st_mode;    /*  6 */
    short st_nlink;   /*  8 */
    short st_uid;     /* 10 */
    short st_gid;     /* 12 */
    short pad1;       /* 14 */
    int st_rdev;      /* 16 */
    int pad2;         /* 20 */
    __int64 st_size;  /* 24 */
    __int64 st_atime; /* 32 */
    __int64 st_mtime; /* 40 */
    __int64 st_ctime; /* 48 */
  } b;
  struct _stat64 *bp;
  char *p;
  int i;
  void *f;
  bp = (struct _stat64 *)&b;

  p = __fstr2cstr(CADR(nm), CLEN(nm));
  if (i = _stat64(p, bp))
    i = __io_errno();
  __cstr_free(p);
  statb[0] = b.st_dev;
  statb[1] = b.st_ino;
  statb[2] = b.st_mode;
  statb[3] = b.st_nlink;
  statb[4] = b.st_uid;
  statb[5] = b.st_gid;
  statb[6] = b.st_rdev;
  statb[7] = b.st_size;
  statb[8] = b.st_atime;
  statb[9] = b.st_mtime;
  statb[10] = b.st_ctime;
  statb[11] = 0;
  statb[12] = 0;
  return i;
#else
  struct stat b;
  char *p;
  int i;

  p = __fstr2cstr(CADR(nm), CLEN(nm));
  if ((i = stat(p, &b)))
    i = __io_errno();
  __cstr_free(p);
  statb[0] = b.st_dev;
  statb[1] = b.st_ino;
  statb[2] = b.st_mode;
  statb[3] = b.st_nlink;
  statb[4] = b.st_uid;
  statb[5] = b.st_gid;
  statb[6] = b.st_rdev;
  statb[7] = b.st_size;
  statb[8] = b.st_atime;
  statb[9] = b.st_mtime;
  statb[10] = b.st_ctime;
  statb[11] = b.st_blksize;
  statb[12] = b.st_blocks;
  return i;
#endif
}
