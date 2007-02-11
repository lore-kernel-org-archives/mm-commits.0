From: akpm@linux-foundation.org
Subject: - m32r-cosmetic-updates-and-trivial-fixes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:44 -0800
Message-ID: <200702112247.l1BMlie6015572@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59651 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbXBKWr4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: cosmetic updates and trivial fixes
has been removed from the -mm tree.  Its filename was
     m32r-cosmetic-updates-and-trivial-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: cosmetic updates and trivial fixes
From: Hirokazu Takata <takata@linux-m32r.org>

Cosmetic updates and trivial fixes of m32r arch-dependent files.
- Remove RCS ID strings and trailing white lines
- Other misc. cosmetic updates

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/head.S                  |    2 --
 arch/m32r/lib/ashxdi3.S                  |    3 ---
 arch/m32r/lib/checksum.S                 |    3 +--
 arch/m32r/lib/delay.c                    |    2 --
 arch/m32r/lib/memcpy.S                   |    2 --
 arch/m32r/lib/memset.S                   |    2 --
 arch/m32r/lib/strlen.S                   |    2 --
 arch/m32r/mm/fault-nommu.c               |    5 +----
 arch/m32r/mm/mmu.S                       |    5 +----
 include/asm-m32r/a.out.h                 |    2 --
 include/asm-m32r/addrspace.h             |    1 -
 include/asm-m32r/bugs.h                  |    2 --
 include/asm-m32r/byteorder.h             |    2 --
 include/asm-m32r/cache.h                 |    2 --
 include/asm-m32r/cacheflush.h            |    1 -
 include/asm-m32r/current.h               |    3 ---
 include/asm-m32r/delay.h                 |    2 --
 include/asm-m32r/dma.h                   |    2 --
 include/asm-m32r/errno.h                 |    3 ---
 include/asm-m32r/ide.h                   |    6 +-----
 include/asm-m32r/ioctls.h                |    5 -----
 include/asm-m32r/ipcbuf.h                |    4 ----
 include/asm-m32r/kmap_types.h            |    4 ----
 include/asm-m32r/m32104ut/m32104ut_pld.h |   11 +++++------
 include/asm-m32r/m32700ut/m32700ut_lan.h |   13 +++++--------
 include/asm-m32r/m32700ut/m32700ut_lcd.h |   13 +++++--------
 include/asm-m32r/m32700ut/m32700ut_pld.h |   13 +++++--------
 include/asm-m32r/mappi2/mappi2_pld.h     |   13 ++++++-------
 include/asm-m32r/mappi3/mappi3_pld.h     |   11 +++++------
 include/asm-m32r/mc146818rtc.h           |    3 ---
 include/asm-m32r/mman.h                  |    2 --
 include/asm-m32r/mmu.h                   |   10 ++++++----
 include/asm-m32r/mmu_context.h           |    9 ++-------
 include/asm-m32r/module.h                |    3 ---
 include/asm-m32r/msgbuf.h                |    4 ----
 include/asm-m32r/namei.h                 |    4 ----
 include/asm-m32r/opsput/opsput_lan.h     |   13 +++++--------
 include/asm-m32r/opsput/opsput_lcd.h     |   13 +++++--------
 include/asm-m32r/opsput/opsput_pld.h     |   13 +++++--------
 include/asm-m32r/page.h                  |    5 -----
 include/asm-m32r/param.h                 |    4 ----
 include/asm-m32r/pci.h                   |    2 --
 include/asm-m32r/pgalloc.h               |    3 ---
 include/asm-m32r/pgtable-2level.h        |    3 ---
 include/asm-m32r/posix_types.h           |    4 ----
 include/asm-m32r/rtc.h                   |    4 ----
 include/asm-m32r/scatterlist.h           |    2 --
 include/asm-m32r/sections.h              |    1 -
 include/asm-m32r/segment.h               |    4 ----
 include/asm-m32r/sembuf.h                |    4 ----
 include/asm-m32r/setup.h                 |    4 ++++
 include/asm-m32r/shmbuf.h                |    4 ----
 include/asm-m32r/shmparam.h              |    2 --
 include/asm-m32r/sigcontext.h            |    3 ---
 include/asm-m32r/siginfo.h               |    2 --
 include/asm-m32r/signal.h                |    4 ----
 include/asm-m32r/smp.h                   |    3 ---
 include/asm-m32r/sockios.h               |    2 --
 include/asm-m32r/spinlock_types.h        |    2 +-
 include/asm-m32r/stat.h                  |    4 ----
 include/asm-m32r/string.h                |    2 --
 include/asm-m32r/syscall.h               |    3 ---
 include/asm-m32r/system.h                |    2 +-
 include/asm-m32r/termbits.h              |    4 +---
 include/asm-m32r/termios.h               |    2 --
 include/asm-m32r/timex.h                 |    3 ---
 include/asm-m32r/tlbflush.h              |    1 -
 include/asm-m32r/types.h                 |    6 +-----
 include/asm-m32r/ucontext.h              |    2 --
 include/asm-m32r/unaligned.h             |    8 +-------
 include/asm-m32r/unistd.h                |    2 --
 include/asm-m32r/user.h                  |    6 ------
 include/asm-m32r/vga.h                   |    4 +---
 include/asm-m32r/xor.h                   |    2 --
 74 files changed, 68 insertions(+), 258 deletions(-)

diff -puN arch/m32r/kernel/head.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/kernel/head.S
--- a/arch/m32r/kernel/head.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/kernel/head.S
@@ -7,8 +7,6 @@
  *                            Hitoshi Yamamoto
  */
 
-/* $Id$ */
-
 #include <linux/init.h>
 __INIT
 __INITDATA
diff -puN arch/m32r/lib/ashxdi3.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/ashxdi3.S
--- a/arch/m32r/lib/ashxdi3.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/ashxdi3.S
@@ -4,8 +4,6 @@
  * Copyright (C) 2001,2002  Hiroyuki Kondo, and Hirokazu Takata
  *
  */
-/* $Id$ */
-
 
 ;
 ;      input   (r0,r1)  src
@@ -293,4 +291,3 @@ __lshrdi3:
 #endif /* not CONFIG_ISA_DUAL_ISSUE */
 
 	.end
-
diff -puN arch/m32r/lib/checksum.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/checksum.S
--- a/arch/m32r/lib/checksum.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/checksum.S
@@ -25,8 +25,6 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  */
-/* $Id$ */
-
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
@@ -319,3 +317,4 @@ ENTRY(csum_partial_copy_generic)
 	nop
 	nop
 
+	.end
diff -puN arch/m32r/lib/delay.c~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/delay.c
--- a/arch/m32r/lib/delay.c~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/delay.c
@@ -5,8 +5,6 @@
  * Copyright (c) 2004  Hirokazu Takata
  */
 
-/* $Id$ */
-
 #include <linux/param.h>
 #ifdef CONFIG_SMP
 #include <linux/sched.h>
diff -puN arch/m32r/lib/memcpy.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/memcpy.S
--- a/arch/m32r/lib/memcpy.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/memcpy.S
@@ -10,8 +10,6 @@
  *        src: r1
  *        n  : r2
  */
-/* $Id$ */
-
 
 	.text
 #include <linux/linkage.h>
diff -puN arch/m32r/lib/memset.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/memset.S
--- a/arch/m32r/lib/memset.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/memset.S
@@ -12,8 +12,6 @@
  *        ret: r0
  *
  */
-/* $Id$ */
-
 
 	.text
 	.global	memset
diff -puN arch/m32r/lib/strlen.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/lib/strlen.S
--- a/arch/m32r/lib/strlen.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/lib/strlen.S
@@ -6,8 +6,6 @@
  *  size_t strlen(const char *s);
  *
  */
-/* $Id$ */
-
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
diff -puN arch/m32r/mm/fault-nommu.c~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/mm/fault-nommu.c
--- a/arch/m32r/mm/fault-nommu.c~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/mm/fault-nommu.c
@@ -7,8 +7,6 @@
  *    Copyright (C) 1995  Linus Torvalds
  */
 
-/* $Id: fault-nommu.c,v 1.1 2004/03/30 06:40:59 sakugawa Exp $ */
-
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -67,7 +65,7 @@ void bust_spinlocks(int yes)
 	 * without oops_in_progress set so that printk will give klogd
 	 * a poke.  Hold onto your hats...
 	 */
-	console_loglevel = 15;		/* NMI oopser may have shut the console up */
+	console_loglevel = 15;	/* NMI oopser may have shut the console up */
 	printk(" ");
 	console_loglevel = loglevel_save;
 }
@@ -161,4 +159,3 @@ void local_flush_tlb_all(void)
 {
 	BUG();
 }
-
diff -puN arch/m32r/mm/mmu.S~m32r-cosmetic-updates-and-trivial-fixes arch/m32r/mm/mmu.S
--- a/arch/m32r/mm/mmu.S~m32r-cosmetic-updates-and-trivial-fixes
+++ a/arch/m32r/mm/mmu.S
@@ -4,8 +4,6 @@
  *  Copyright (C) 2001 by Hiroyuki Kondo
  */
 
-/* $Id: mmu.S,v 1.15 2004/03/16 02:56:27 takata Exp $ */
-
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/smp.h>
@@ -345,5 +343,4 @@ ENTRY(m32r_otlb_entrys)
 
 #endif  /* CONFIG_MMU */
 
-.end
-
+	.end
diff -puN include/asm-m32r/a.out.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/a.out.h
--- a/include/asm-m32r/a.out.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/a.out.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_A_OUT_H
 #define _ASM_M32R_A_OUT_H
 
-/* orig : i386 2.4.18 */
-
 struct exec
 {
   unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
diff -puN include/asm-m32r/addrspace.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/addrspace.h
--- a/include/asm-m32r/addrspace.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/addrspace.h
@@ -1,4 +1,3 @@
-/* $Id$ */
 /*
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
diff -puN include/asm-m32r/bugs.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/bugs.h
--- a/include/asm-m32r/bugs.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/bugs.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_BUGS_H
 #define _ASM_M32R_BUGS_H
 
-/* $Id$ */
-
 /*
  * This is included by init/main.c to check for architecture-dependent bugs.
  *
diff -puN include/asm-m32r/byteorder.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/byteorder.h
--- a/include/asm-m32r/byteorder.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/byteorder.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-/* $Id$ */
-
 #include <asm/types.h>
 
 #if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
diff -puN include/asm-m32r/cache.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/cache.h
--- a/include/asm-m32r/cache.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/cache.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_CACHE_H
 #define _ASM_M32R_CACHE_H
 
-/* $Id$ */
-
 /* L1 cache line size */
 #define L1_CACHE_SHIFT		4
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
diff -puN include/asm-m32r/cacheflush.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/cacheflush.h
--- a/include/asm-m32r/cacheflush.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/cacheflush.h
@@ -67,4 +67,3 @@ do {								\
 	memcpy(dst, src, len)
 
 #endif /* _ASM_M32R_CACHEFLUSH_H */
-
diff -puN include/asm-m32r/current.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/current.h
--- a/include/asm-m32r/current.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/current.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_CURRENT_H
 #define _ASM_M32R_CURRENT_H
 
-/* $Id$ */
-
 #include <linux/thread_info.h>
 
 struct task_struct;
@@ -15,4 +13,3 @@ static __inline__ struct task_struct *ge
 #define current	(get_current())
 
 #endif	/* _ASM_M32R_CURRENT_H */
-
diff -puN include/asm-m32r/delay.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/delay.h
--- a/include/asm-m32r/delay.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/delay.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_DELAY_H
 #define _ASM_M32R_DELAY_H
 
-/* $Id$ */
-
 /*
  * Copyright (C) 1993 Linus Torvalds
  *
diff -puN include/asm-m32r/dma.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/dma.h
--- a/include/asm-m32r/dma.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/dma.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_DMA_H
 #define _ASM_M32R_DMA_H
 
-/* $Id$ */
-
 #include <asm/io.h>
 
 /*
diff -puN include/asm-m32r/errno.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/errno.h
--- a/include/asm-m32r/errno.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/errno.h
@@ -1,9 +1,6 @@
 #ifndef _ASM_M32R_ERRNO_H
 #define _ASM_M32R_ERRNO_H
 
-/* $Id$ */
-
 #include <asm-generic/errno.h>
 
 #endif /* _ASM_M32R_ERRNO_H */
-
diff -puN include/asm-m32r/ide.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/ide.h
--- a/include/asm-m32r/ide.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/ide.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_IDE_H
 #define _ASM_M32R_IDE_H
 
-/* $Id$ */
-
 /*
  *  linux/include/asm-m32r/ide.h
  *
@@ -15,6 +13,7 @@
 
 #ifdef __KERNEL__
 
+#include <asm/m32r.h>
 
 #ifndef MAX_HWIFS
 # ifdef CONFIG_BLK_DEV_IDEPCI
@@ -24,9 +23,6 @@
 # endif
 #endif
 
-#include <asm/m32r.h>
-
-
 #define IDE_ARCH_OBSOLETE_DEFAULTS
 
 static __inline__ int ide_default_irq(unsigned long base)
diff -puN include/asm-m32r/ioctls.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/ioctls.h
--- a/include/asm-m32r/ioctls.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/ioctls.h
@@ -1,10 +1,6 @@
 #ifndef __ARCH_M32R_IOCTLS_H__
 #define __ARCH_M32R_IOCTLS_H__
 
-/* $Id$ */
-
-/* orig : i386 2.5.67 */
-
 #include <asm/ioctl.h>
 
 /* 0x54 is just a magic number to make these relatively unique ('T') */
@@ -85,4 +81,3 @@
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
 #endif /* __ARCH_M32R_IOCTLS_H__ */
-
diff -puN include/asm-m32r/ipcbuf.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/ipcbuf.h
--- a/include/asm-m32r/ipcbuf.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/ipcbuf.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_IPCBUF_H
 #define _ASM_M32R_IPCBUF_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 /*
  * The ipc64_perm structure for m32r architecture.
  * Note extra padding because this structure is passed back and forth
diff -puN include/asm-m32r/kmap_types.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/kmap_types.h
--- a/include/asm-m32r/kmap_types.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/kmap_types.h
@@ -1,9 +1,6 @@
 #ifndef __M32R_KMAP_TYPES_H
 #define __M32R_KMAP_TYPES_H
 
-/* Dummy header just to define km_type. */
-
-
 #ifdef CONFIG_DEBUG_HIGHMEM
 # define D(n) __KM_FENCE_##n ,
 #else
@@ -30,4 +27,3 @@ D(13)	KM_TYPE_NR
 #undef D
 
 #endif /* __M32R_KMAP_TYPES_H */
-
diff -puN include/asm-m32r/m32104ut/m32104ut_pld.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/m32104ut/m32104ut_pld.h
--- a/include/asm-m32r/m32104ut/m32104ut_pld.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/m32104ut/m32104ut_pld.h
@@ -1,3 +1,6 @@
+#ifndef _M32104UT_M32104UT_PLD_H
+#define _M32104UT_M32104UT_PLD_H
+
 /*
  * include/asm-m32r/m32104ut/m32104ut_pld.h
  *
@@ -12,10 +15,6 @@
  * this archive for more details.
  */
 
-#ifndef _M32104UT_M32104UT_PLD_H
-#define _M32104UT_M32104UT_PLD_H
-
-
 #if defined(CONFIG_PLAT_M32104UT)
 #define PLD_PLAT_BASE		0x02c00000
 #else
@@ -35,7 +34,7 @@
 #define __reg8
 #define __reg16
 #define __reg32
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* CFC */
 #define	PLD_CFRSTCR		__reg16(PLD_BASE + 0x0000)
@@ -159,4 +158,4 @@
 #define PLD_SCTXB		__reg16(PLD_BASE + 0x3800c)
 #define PLD_SCRXB		__reg16(PLD_BASE + 0x3800e)
 
-#endif	/* _M32104UT_M32104UT_PLD_H */
+#endif /* _M32104UT_M32104UT_PLD_H */
diff -puN include/asm-m32r/m32700ut/m32700ut_lan.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/m32700ut/m32700ut_lan.h
--- a/include/asm-m32r/m32700ut/m32700ut_lan.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/m32700ut/m32700ut_lan.h
@@ -1,3 +1,6 @@
+#ifndef _M32700UT_M32700UT_LAN_H
+#define _M32700UT_M32700UT_LAN_H
+
 /*
  * include/asm-m32r/m32700ut/m32700ut_lan.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id$
  */
 
-#ifndef _M32700UT_M32700UT_LAN_H
-#define _M32700UT_M32700UT_LAN_H
-
-
 #ifndef __ASSEMBLY__
 /*
  * C functions use non-cache address.
@@ -23,7 +20,7 @@
 #define M32700UT_LAN_BASE	(0x10000000 /* + NONCACHE_OFFSET */)
 #else
 #define M32700UT_LAN_BASE	(0x10000000 + NONCACHE_OFFSET)
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* ICU
  *  ICUISTS:	status register
@@ -103,4 +100,4 @@
 #define PLDI2CSTS_BB		0x00000010
 #define PLDI2CSTS_NOACK		0x00000001	/* 0:ack, 1:noack */
 
-#endif	/* _M32700UT_M32700UT_LAN_H */
+#endif /* _M32700UT_M32700UT_LAN_H */
diff -puN include/asm-m32r/m32700ut/m32700ut_lcd.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/m32700ut/m32700ut_lcd.h
--- a/include/asm-m32r/m32700ut/m32700ut_lcd.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/m32700ut/m32700ut_lcd.h
@@ -1,3 +1,6 @@
+#ifndef _M32700UT_M32700UT_LCD_H
+#define _M32700UT_M32700UT_LCD_H
+
 /*
  * include/asm-m32r/m32700ut/m32700ut_lcd.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id$
  */
 
-#ifndef _M32700UT_M32700UT_LCD_H
-#define _M32700UT_M32700UT_LCD_H
-
-
 #ifndef __ASSEMBLY__
 /*
  * C functions use non-cache address.
@@ -23,7 +20,7 @@
 #define M32700UT_LCD_BASE	(0x10000000 /* + NONCACHE_OFFSET */)
 #else
 #define M32700UT_LCD_BASE	(0x10000000 + NONCACHE_OFFSET)
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /*
  * ICU
@@ -55,4 +52,4 @@
 #define M32700UT_LCD_ICUCR19	__reg16(M32700UT_LCD_BASE + 0x300036)
 #define M32700UT_LCD_ICUCR21	__reg16(M32700UT_LCD_BASE + 0x30003a)
 
-#endif	/* _M32700UT_M32700UT_LCD_H */
+#endif /* _M32700UT_M32700UT_LCD_H */
diff -puN include/asm-m32r/m32700ut/m32700ut_pld.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/m32700ut/m32700ut_pld.h
--- a/include/asm-m32r/m32700ut/m32700ut_pld.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/m32700ut/m32700ut_pld.h
@@ -1,3 +1,6 @@
+#ifndef _M32700UT_M32700UT_PLD_H
+#define _M32700UT_M32700UT_PLD_H
+
 /*
  * include/asm-m32r/m32700ut/m32700ut_pld.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id$
  */
 
-#ifndef _M32700UT_M32700UT_PLD_H
-#define _M32700UT_M32700UT_PLD_H
-
-
 #if defined(CONFIG_PLAT_M32700UT_Alpha)
 #define PLD_PLAT_BASE		0x08c00000
 #elif defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_USRV)
@@ -37,7 +34,7 @@
 #define __reg8
 #define __reg16
 #define __reg32
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* CFC */
 #define	PLD_CFRSTCR		__reg16(PLD_BASE + 0x0000)
@@ -261,4 +258,4 @@
 #define PLD_SCTXB		__reg16(PLD_BASE + 0x3800c)
 #define PLD_SCRXB		__reg16(PLD_BASE + 0x3800e)
 
-#endif	/* _M32700UT_M32700UT_PLD.H */
+#endif /* _M32700UT_M32700UT_PLD.H */
diff -puN include/asm-m32r/mappi2/mappi2_pld.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mappi2/mappi2_pld.h
--- a/include/asm-m32r/mappi2/mappi2_pld.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mappi2/mappi2_pld.h
@@ -1,18 +1,17 @@
+#ifndef _MAPPI2_PLD_H
+#define _MAPPI2_PLD_H
+
 /*
  * include/asm-m32r/mappi2/mappi2_pld.h
  *
  * Definitions for Extended IO Logic on MAPPI2 board.
- *  based on m32700ut_pld.h by
+ *  based on m32700ut_pld.h
  *
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
  */
 
-#ifndef _MAPPI2_PLD_H
-#define _MAPPI2_PLD_H
-
 #ifndef __ASSEMBLY__
 /* FIXME:
  * Some C functions use non-cache address, so can't define non-cache address.
@@ -26,7 +25,7 @@
 #define __reg8
 #define __reg16
 #define __reg32
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* CFC */
 #define	PLD_CFRSTCR		__reg16(PLD_BASE + 0x0000)
@@ -148,4 +147,4 @@
 
 #endif
 
-#endif	/* _MAPPI2_PLD.H */
+#endif /* _MAPPI2_PLD.H */
diff -puN include/asm-m32r/mappi3/mappi3_pld.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mappi3/mappi3_pld.h
--- a/include/asm-m32r/mappi3/mappi3_pld.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mappi3/mappi3_pld.h
@@ -1,3 +1,6 @@
+#ifndef _MAPPI3_PLD_H
+#define _MAPPI3_PLD_H
+
 /*
  * include/asm-m32r/mappi3/mappi3_pld.h
  *
@@ -7,12 +10,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
  */
 
-#ifndef _MAPPI3_PLD_H
-#define _MAPPI3_PLD_H
-
 #ifndef __ASSEMBLY__
 /* FIXME:
  * Some C functions use non-cache address, so can't define non-cache address.
@@ -26,7 +25,7 @@
 #define __reg8
 #define __reg16
 #define __reg32
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* CFC */
 #define	PLD_CFRSTCR		__reg16(PLD_BASE + 0x0000)
@@ -140,4 +139,4 @@
 /* Reset Control */
 #define PLD_REBOOT		__reg16(PLD_BASE + 0x38000)
 
-#endif	/* _MAPPI3_PLD.H */
+#endif /* _MAPPI3_PLD.H */
diff -puN include/asm-m32r/mc146818rtc.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mc146818rtc.h
--- a/include/asm-m32r/mc146818rtc.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mc146818rtc.h
@@ -7,7 +7,6 @@
 #include <asm/io.h>
 
 #ifndef RTC_PORT
-// #define RTC_PORT(x)	(0x70 + (x))
 #define RTC_PORT(x)	((x))
 #define RTC_ALWAYS_BCD	1	/* RTC operates in binary mode */
 #endif
@@ -26,7 +25,5 @@ outb_p((val),RTC_PORT(1)); \
 })
 
 #define RTC_IRQ 8
-#if 0
-#endif
 
 #endif /* _ASM_MC146818RTC_H */
diff -puN include/asm-m32r/mman.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mman.h
--- a/include/asm-m32r/mman.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mman.h
@@ -3,8 +3,6 @@
 
 #include <asm-generic/mman.h>
 
-/* orig : i386 2.6.0-test6 */
-
 #define MAP_GROWSDOWN	0x0100		/* stack-like segment */
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
diff -puN include/asm-m32r/mmu.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mmu.h
--- a/include/asm-m32r/mmu.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mmu.h
@@ -1,13 +1,14 @@
 #ifndef _ASM_M32R_MMU_H
 #define _ASM_M32R_MMU_H
 
-
 #if !defined(CONFIG_MMU)
+
 typedef struct {
 	struct vm_list_struct	*vmlist;
 	unsigned long		end_brk;
 } mm_context_t;
-#else
+
+#else /* CONFIG_MMU */
 
 /* Default "unsigned long" context */
 #ifndef CONFIG_SMP
@@ -16,5 +17,6 @@ typedef unsigned long mm_context_t;
 typedef unsigned long mm_context_t[NR_CPUS];
 #endif
 
-#endif  /* CONFIG_MMU */
-#endif  /* _ASM_M32R_MMU_H */
+#endif /* CONFIG_MMU */
+
+#endif /* _ASM_M32R_MMU_H */
diff -puN include/asm-m32r/mmu_context.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/mmu_context.h
--- a/include/asm-m32r/mmu_context.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/mmu_context.h
@@ -1,9 +1,7 @@
 #ifndef _ASM_M32R_MMU_CONTEXT_H
 #define _ASM_M32R_MMU_CONTEXT_H
-
 #ifdef __KERNEL__
 
-
 #include <asm/m32r.h>
 
 #define MMU_CONTEXT_ASID_MASK      (0x000000FF)
@@ -11,7 +9,6 @@
 #define MMU_CONTEXT_FIRST_VERSION  (0x00000100)
 #define NO_CONTEXT                 (0x00000000)
 
-
 #ifndef __ASSEMBLY__
 
 #include <asm/atomic.h>
@@ -147,7 +144,7 @@ static inline void switch_mm(struct mm_s
 #define activate_mm(prev, next)	\
 	switch_mm((prev), (next), NULL)
 
-#else
+#else /* not CONFIG_MMU */
 #define get_mmu_context(mm)             do { } while (0)
 #define init_new_context(tsk,mm)        (0)
 #define destroy_context(mm)             do { } while (0)
@@ -158,11 +155,9 @@ static inline void switch_mm(struct mm_s
 #define deactivate_mm(mm,tsk)           do { } while (0)
 #define activate_mm(prev,next)          do { } while (0)
 #define enter_lazy_tlb(mm,tsk)          do { } while (0)
-#endif /* CONFIG_MMU */
-
+#endif /* not CONFIG_MMU */
 
 #endif /* not __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_M32R_MMU_CONTEXT_H */
diff -puN include/asm-m32r/module.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/module.h
--- a/include/asm-m32r/module.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/module.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_MODULE_H
 #define _ASM_M32R_MODULE_H
 
-/* $Id$ */
-
 struct mod_arch_specific { };
 
 #define Elf_Shdr	Elf32_Shdr
@@ -10,4 +8,3 @@ struct mod_arch_specific { };
 #define Elf_Ehdr	Elf32_Ehdr
 
 #endif /* _ASM_M32R_MODULE_H */
-
diff -puN include/asm-m32r/msgbuf.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/msgbuf.h
--- a/include/asm-m32r/msgbuf.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/msgbuf.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_MSGBUF_H
 #define _ASM_M32R_MSGBUF_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 /*
  * The msqid64_ds structure for m32r architecture.
  * Note extra padding because this structure is passed back and forth
diff -puN include/asm-m32r/namei.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/namei.h
--- a/include/asm-m32r/namei.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/namei.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_NAMEI_H
 #define _ASM_M32R_NAMEI_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 /*
  * linux/include/asm-m32r/namei.h
  *
diff -puN include/asm-m32r/opsput/opsput_lan.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/opsput/opsput_lan.h
--- a/include/asm-m32r/opsput/opsput_lan.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/opsput/opsput_lan.h
@@ -1,3 +1,6 @@
+#ifndef _OPSPUT_OPSPUT_LAN_H
+#define _OPSPUT_OPSPUT_LAN_H
+
 /*
  * include/asm-m32r/opsput/opsput_lan.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id: opsput_lan.h,v 1.1 2004/07/27 06:54:20 sakugawa Exp $
  */
 
-#ifndef _OPSPUT_OPSPUT_LAN_H
-#define _OPSPUT_OPSPUT_LAN_H
-
-
 #ifndef __ASSEMBLY__
 /*
  * C functions use non-cache address.
@@ -23,7 +20,7 @@
 #define OPSPUT_LAN_BASE	(0x10000000 /* + NONCACHE_OFFSET */)
 #else
 #define OPSPUT_LAN_BASE	(0x10000000 + NONCACHE_OFFSET)
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* ICU
  *  ICUISTS:	status register
@@ -52,4 +49,4 @@
 #define OPSPUT_LAN_ICUCR1	__reg16(OPSPUT_LAN_BASE + 0xc0010)
 #define OPSPUT_LAN_ICUCR3	__reg16(OPSPUT_LAN_BASE + 0xc0014)
 
-#endif	/* _OPSPUT_OPSPUT_LAN_H */
+#endif /* _OPSPUT_OPSPUT_LAN_H */
diff -puN include/asm-m32r/opsput/opsput_lcd.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/opsput/opsput_lcd.h
--- a/include/asm-m32r/opsput/opsput_lcd.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/opsput/opsput_lcd.h
@@ -1,3 +1,6 @@
+#ifndef _OPSPUT_OPSPUT_LCD_H
+#define _OPSPUT_OPSPUT_LCD_H
+
 /*
  * include/asm-m32r/opsput/opsput_lcd.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id: opsput_lcd.h,v 1.1 2004/07/27 06:54:20 sakugawa Exp $
  */
 
-#ifndef _OPSPUT_OPSPUT_LCD_H
-#define _OPSPUT_OPSPUT_LCD_H
-
-
 #ifndef __ASSEMBLY__
 /*
  * C functions use non-cache address.
@@ -23,7 +20,7 @@
 #define OPSPUT_LCD_BASE	(0x10000000 /* + NONCACHE_OFFSET */)
 #else
 #define OPSPUT_LCD_BASE	(0x10000000 + NONCACHE_OFFSET)
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /*
  * ICU
@@ -55,4 +52,4 @@
 #define OPSPUT_LCD_ICUCR19	__reg16(OPSPUT_LCD_BASE + 0x300036)
 #define OPSPUT_LCD_ICUCR21	__reg16(OPSPUT_LCD_BASE + 0x30003a)
 
-#endif	/* _OPSPUT_OPSPUT_LCD_H */
+#endif /* _OPSPUT_OPSPUT_LCD_H */
diff -puN include/asm-m32r/opsput/opsput_pld.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/opsput/opsput_pld.h
--- a/include/asm-m32r/opsput/opsput_pld.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/opsput/opsput_pld.h
@@ -1,3 +1,6 @@
+#ifndef _OPSPUT_OPSPUT_PLD_H
+#define _OPSPUT_OPSPUT_PLD_H
+
 /*
  * include/asm-m32r/opsput/opsput_pld.h
  *
@@ -8,14 +11,8 @@
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file "COPYING" in the main directory of
  * this archive for more details.
- *
- * $Id: opsput_pld.h,v 1.1 2004/07/27 06:54:20 sakugawa Exp $
  */
 
-#ifndef _OPSPUT_OPSPUT_PLD_H
-#define _OPSPUT_OPSPUT_PLD_H
-
-
 #define PLD_PLAT_BASE		0x1cc00000
 
 #ifndef __ASSEMBLY__
@@ -31,7 +28,7 @@
 #define __reg8
 #define __reg16
 #define __reg32
-#endif	/* __ASSEMBLY__ */
+#endif /* __ASSEMBLY__ */
 
 /* CFC */
 #define	PLD_CFRSTCR		__reg16(PLD_BASE + 0x0000)
@@ -255,4 +252,4 @@
 #define PLD_SCTXB		__reg16(PLD_BASE + 0x3800c)
 #define PLD_SCRXB		__reg16(PLD_BASE + 0x3800e)
 
-#endif	/* _OPSPUT_OPSPUT_PLD.H */
+#endif /* _OPSPUT_OPSPUT_PLD.H */
diff -puN include/asm-m32r/page.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/page.h
--- a/include/asm-m32r/page.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/page.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_M32R_PAGE_H
 #define _ASM_M32R_PAGE_H
 
-
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
@@ -57,9 +56,6 @@ typedef struct { unsigned long pgprot; }
  * and CONFIG_HIGHMEM64G options in the kernel configuration.
  */
 
-
-/* This handles the memory map.. */
-
 #define __MEMORY_START  CONFIG_MEMORY_START
 #define __MEMORY_SIZE   CONFIG_MEMORY_SIZE
 
@@ -92,4 +88,3 @@ typedef struct { unsigned long pgprot; }
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_M32R_PAGE_H */
-
diff -puN include/asm-m32r/param.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/param.h
--- a/include/asm-m32r/param.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/param.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_PARAM_H
 #define _ASM_M32R_PARAM_H
 
-/* $Id$ */
-
-/* orig : i386 2.5.67 */
-
 #ifdef __KERNEL__
 # define HZ		100		/* Internal kernel timer frequency */
 # define USER_HZ	100		/* .. some user interfaces are in "ticks" */
diff -puN include/asm-m32r/pci.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/pci.h
--- a/include/asm-m32r/pci.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/pci.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_PCI_H
 #define _ASM_M32R_PCI_H
 
-/* $Id$ */
-
 #include <asm-generic/pci.h>
 
 #define PCI_DMA_BUS_IS_PHYS	(1)
diff -puN include/asm-m32r/pgalloc.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/pgalloc.h
--- a/include/asm-m32r/pgalloc.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/pgalloc.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_PGALLOC_H
 #define _ASM_M32R_PGALLOC_H
 
-/* $Id$ */
-
 #include <linux/mm.h>
 
 #include <asm/io.h>
@@ -74,4 +72,3 @@ static __inline__ void pte_free(struct p
 #define check_pgt_cache()	do { } while (0)
 
 #endif /* _ASM_M32R_PGALLOC_H */
-
diff -puN include/asm-m32r/pgtable-2level.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/pgtable-2level.h
--- a/include/asm-m32r/pgtable-2level.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/pgtable-2level.h
@@ -1,9 +1,7 @@
 #ifndef _ASM_M32R_PGTABLE_2LEVEL_H
 #define _ASM_M32R_PGTABLE_2LEVEL_H
-
 #ifdef __KERNEL__
 
-
 /*
  * traditional M32R two-level paging structure:
  */
@@ -77,5 +75,4 @@ static inline pmd_t *pmd_offset(pgd_t * 
 #define pgoff_to_pte(off)	((pte_t) { (((off) & 0xef) << 2) | (((off) >> 7) << 10) | _PAGE_FILE })
 
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_M32R_PGTABLE_2LEVEL_H */
diff -puN include/asm-m32r/posix_types.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/posix_types.h
--- a/include/asm-m32r/posix_types.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/posix_types.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_POSIX_TYPES_H
 #define _ASM_M32R_POSIX_TYPES_H
 
-/* $Id$ */
-
-/* orig : i386, sh 2.4.18 */
-
 /*
  * This file is generally used by user-level software, so you need to
  * be a little careful about namespace pollution etc.  Also, we cannot
diff -puN include/asm-m32r/rtc.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/rtc.h
--- a/include/asm-m32r/rtc.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/rtc.h
@@ -1,10 +1,6 @@
-/* $Id: rtc.h,v 1.1.1.1 2004/03/25 04:29:22 hitoshiy Exp $ */
-
 #ifndef __RTC_H__
 #define __RTC_H__
 
-
-
    /* Dallas DS1302 clock/calendar register numbers. */
 #  define RTC_SECONDS      0
 #  define RTC_MINUTES      1
diff -puN include/asm-m32r/scatterlist.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/scatterlist.h
--- a/include/asm-m32r/scatterlist.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/scatterlist.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_SCATTERLIST_H
 #define _ASM_M32R_SCATTERLIST_H
 
-/* $Id$ */
-
 struct scatterlist {
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
diff -puN include/asm-m32r/sections.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/sections.h
--- a/include/asm-m32r/sections.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/sections.h
@@ -5,4 +5,3 @@
 #include <asm-generic/sections.h>
 
 #endif	/* _M32R_SECTIONS_H */
-
diff -puN include/asm-m32r/segment.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/segment.h
--- a/include/asm-m32r/segment.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/segment.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_SEGMENT_H
 #define _ASM_M32R_SEGMENT_H
 
-/* $Id$ */
-
-/* orig : i386 (2.4.18) */
-
 #define __KERNEL_CS	0x10
 #define __KERNEL_DS	0x18
 
diff -puN include/asm-m32r/sembuf.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/sembuf.h
--- a/include/asm-m32r/sembuf.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/sembuf.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_SEMBUF_H
 #define _ASM_M32R_SEMBUF_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 /*
  * The semid64_ds structure for m32r architecture.
  * Note extra padding because this structure is passed back and forth
diff -puN include/asm-m32r/setup.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/setup.h
--- a/include/asm-m32r/setup.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/setup.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_M32R_SETUP_H
+#define _ASM_M32R_SETUP_H
+
 /*
  * This is set up by the setup-routine at boot-time
  */
@@ -32,3 +35,4 @@ extern unsigned long memory_end;
 
 #endif  /*  __KERNEL__  */
 
+#endif /* _ASM_M32R_SETUP_H */
diff -puN include/asm-m32r/shmbuf.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/shmbuf.h
--- a/include/asm-m32r/shmbuf.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/shmbuf.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_SHMBUF_H
 #define _ASM_M32R_SHMBUF_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 /*
  * The shmid64_ds structure for M32R architecture.
  * Note extra padding because this structure is passed back and forth
diff -puN include/asm-m32r/shmparam.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/shmparam.h
--- a/include/asm-m32r/shmparam.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/shmparam.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_SHMPARAM_H
 #define _ASM_M32R_SHMPARAM_H
 
-/* $Id$ */
-
 #define	SHMLBA PAGE_SIZE		 /* attach addr a multiple of this */
 
 #endif /* _ASM_M32R_SHMPARAM_H */
diff -puN include/asm-m32r/sigcontext.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/sigcontext.h
--- a/include/asm-m32r/sigcontext.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/sigcontext.h
@@ -1,9 +1,6 @@
 #ifndef _ASM_M32R_SIGCONTEXT_H
 #define _ASM_M32R_SIGCONTEXT_H
 
-/* $Id$ */
-
-
 struct sigcontext {
 	/* CPU registers */
 	/* Saved main processor registers. */
diff -puN include/asm-m32r/siginfo.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/siginfo.h
--- a/include/asm-m32r/siginfo.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/siginfo.h
@@ -1,8 +1,6 @@
 #ifndef _M32R_SIGINFO_H
 #define _M32R_SIGINFO_H
 
-/* $Id$ */
-
 #include <asm-generic/siginfo.h>
 
 #endif /* _M32R_SIGINFO_H */
diff -puN include/asm-m32r/signal.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/signal.h
--- a/include/asm-m32r/signal.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/signal.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_SIGNAL_H
 #define _ASM_M32R_SIGNAL_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/compiler.h>
diff -puN include/asm-m32r/smp.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/smp.h
--- a/include/asm-m32r/smp.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/smp.h
@@ -1,9 +1,6 @@
 #ifndef _ASM_M32R_SMP_H
 #define _ASM_M32R_SMP_H
 
-/* $Id$ */
-
-
 #ifdef CONFIG_SMP
 #ifndef __ASSEMBLY__
 
diff -puN include/asm-m32r/sockios.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/sockios.h
--- a/include/asm-m32r/sockios.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/sockios.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_SOCKIOS_H
 #define _ASM_M32R_SOCKIOS_H
 
-/* $Id$ */
-
 /* Socket-level I/O control calls. */
 #define FIOSETOWN 	0x8901
 #define SIOCSPGRP	0x8902
diff -puN include/asm-m32r/spinlock_types.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/spinlock_types.h
--- a/include/asm-m32r/spinlock_types.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/spinlock_types.h
@@ -20,4 +20,4 @@ typedef struct {
 
 #define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
-#endif
+#endif /* _ASM_M32R_SPINLOCK_TYPES_H */
diff -puN include/asm-m32r/stat.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/stat.h
--- a/include/asm-m32r/stat.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/stat.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_STAT_H
 #define _ASM_M32R_STAT_H
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 #include <asm/byteorder.h>
 
 struct __old_kernel_stat {
diff -puN include/asm-m32r/string.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/string.h
--- a/include/asm-m32r/string.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/string.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_STRING_H
 #define _ASM_M32R_STRING_H
 
-/* $Id$ */
-
 #define  __HAVE_ARCH_STRLEN
 extern size_t strlen(const char * s);
 
diff -puN include/asm-m32r/syscall.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/syscall.h
--- a/include/asm-m32r/syscall.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/syscall.h
@@ -1,11 +1,8 @@
 #ifndef _ASM_M32R_SYSCALL_H
 #define _ASM_M32R_SYSCALL_H
 
-/* $Id$ */
-
 /* Definitions for the system call vector.  */
 #define SYSCALL_VECTOR          "2"
 #define SYSCALL_VECTOR_ADDRESS  "0xa0"
 
 #endif /* _ASM_M32R_SYSCALL_H */
-
diff -puN include/asm-m32r/system.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/system.h
--- a/include/asm-m32r/system.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/system.h
@@ -339,4 +339,4 @@ __cmpxchg(volatile void *ptr, unsigned l
 
 #define arch_align_stack(x) (x)
 
-#endif  /* _ASM_M32R_SYSTEM_H */
+#endif /* _ASM_M32R_SYSTEM_H */
diff -puN include/asm-m32r/termbits.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/termbits.h
--- a/include/asm-m32r/termbits.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/termbits.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_TERMBITS_H
 #define _ASM_M32R_TERMBITS_H
 
-/* $Id$ */
-
 #include <linux/posix_types.h>
 
 typedef unsigned char	cc_t;
@@ -184,4 +182,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif  /* _ASM_M32R_TERMBITS_H */
+#endif /* _ASM_M32R_TERMBITS_H */
diff -puN include/asm-m32r/termios.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/termios.h
--- a/include/asm-m32r/termios.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/termios.h
@@ -1,8 +1,6 @@
 #ifndef _M32R_TERMIOS_H
 #define _M32R_TERMIOS_H
 
-/* orig : i386 2.6.0-test5 */
-
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
 
diff -puN include/asm-m32r/timex.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/timex.h
--- a/include/asm-m32r/timex.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/timex.h
@@ -1,15 +1,12 @@
 #ifndef _ASM_M32R_TIMEX_H
 #define _ASM_M32R_TIMEX_H
 
-/* $Id$ */
-
 /*
  * linux/include/asm-m32r/timex.h
  *
  * m32r architecture timex specifications
  */
 
-
 #define CLOCK_TICK_RATE	(CONFIG_BUS_CLOCK / CONFIG_TIMER_DIVIDE)
 #define CLOCK_TICK_FACTOR	20	/* Factor of both 1000000 and CLOCK_TICK_RATE */
 
diff -puN include/asm-m32r/tlbflush.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/tlbflush.h
--- a/include/asm-m32r/tlbflush.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/tlbflush.h
@@ -98,4 +98,3 @@ static __inline__ void __flush_tlb_all(v
 extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
 
 #endif	/* _ASM_M32R_TLBFLUSH_H */
-
diff -puN include/asm-m32r/types.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/types.h
--- a/include/asm-m32r/types.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/types.h
@@ -3,10 +3,6 @@
 
 #ifndef __ASSEMBLY__
 
-/* $Id$ */
-
-/* orig : i386 2.4.18 */
-
 typedef unsigned short umode_t;
 
 /*
@@ -59,4 +55,4 @@ typedef u64 dma64_addr_t;
 
 #endif /* __KERNEL__ */
 
-#endif  /* _ASM_M32R_TYPES_H */
+#endif /* _ASM_M32R_TYPES_H */
diff -puN include/asm-m32r/ucontext.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/ucontext.h
--- a/include/asm-m32r/ucontext.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/ucontext.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_UCONTEXT_H
 #define _ASM_M32R_UCONTEXT_H
 
-/* orig : i386 2.4.18 */
-
 struct ucontext {
 	unsigned long	  uc_flags;
 	struct ucontext  *uc_link;
diff -puN include/asm-m32r/unaligned.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/unaligned.h
--- a/include/asm-m32r/unaligned.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/unaligned.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-/* $Id$ */
-
-/* orig : generic 2.4.18 */
-
 /*
  * For the benefit of those who are trying to port Linux to another
  * architecture, here are some C-language equivalents.
@@ -12,7 +8,6 @@
 
 #include <asm/string.h>
 
-
 #define get_unaligned(ptr) \
   ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
 
@@ -21,5 +16,4 @@
      memmove((ptr), &__tmp, sizeof(*(ptr)));		\
      (void)0; })
 
-
-#endif  /* _ASM_M32R_UNALIGNED_H */
+#endif /* _ASM_M32R_UNALIGNED_H */
diff -puN include/asm-m32r/unistd.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/unistd.h
--- a/include/asm-m32r/unistd.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/unistd.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_UNISTD_H
 #define _ASM_M32R_UNISTD_H
 
-/* $Id$ */
-
 /*
  * This file contains the system call numbers.
  */
diff -puN include/asm-m32r/user.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/user.h
--- a/include/asm-m32r/user.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/user.h
@@ -1,12 +1,6 @@
 #ifndef _ASM_M32R_USER_H
 #define _ASM_M32R_USER_H
 
-/* $Id$ */
-
-/* orig : sh 2.4.18
- * mod  : remove fpu registers
- */
-
 #include <linux/types.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
diff -puN include/asm-m32r/vga.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/vga.h
--- a/include/asm-m32r/vga.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/vga.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_VGA_H
 #define _ASM_M32R_VGA_H
 
-/* $Id$ */
-
 /*
  *	Access to VGA videoram
  *
@@ -19,4 +17,4 @@
 #define vga_readb(x) (*(x))
 #define vga_writeb(x,y) (*(y) = (x))
 
-#endif  /* _ASM_M32R_VGA_H */
+#endif /* _ASM_M32R_VGA_H */
diff -puN include/asm-m32r/xor.h~m32r-cosmetic-updates-and-trivial-fixes include/asm-m32r/xor.h
--- a/include/asm-m32r/xor.h~m32r-cosmetic-updates-and-trivial-fixes
+++ a/include/asm-m32r/xor.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_M32R_XOR_H
 #define _ASM_M32R_XOR_H
 
-/* $Id$ */
-
 #include <asm-generic/xor.h>
 
 #endif  /* _ASM_M32R_XOR_H */
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-m32r.patch
