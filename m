From: akpm@linux-foundation.org
Subject: - christoph-has-moved.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:57:52 -0700
Message-ID: <200807070257.m672vq1X004397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYGGC6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, cl@linux-foundation.org, mpm@selenic.com, penberg@cs.helsinki.fi, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Christoph has moved
has been removed from the -mm tree.  Its filename was
     christoph-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Christoph has moved
From: Christoph Lameter <clameter@sgi.com>

Remove all clameter@sgi.com addresses from the kernel tree since they will
become invalid on June 27th.  Change my maintainer email address for the
slab allocators to cl@linux-foundation.org (which will be the new email
address for the future).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c  |    4 ++--
 Documentation/vm/slub.txt    |    2 +-
 MAINTAINERS                  |    2 +-
 include/asm-generic/atomic.h |    2 +-
 include/linux/slab.h         |    2 +-
 include/linux/slub_def.h     |    2 +-
 kernel/workqueue.c           |    2 +-
 lib/radix-tree.c             |    2 +-
 mm/allocpercpu.c             |    2 +-
 mm/migrate.c                 |    2 +-
 mm/slub.c                    |    2 +-
 mm/sparse-vmemmap.c          |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

diff -puN Documentation/vm/slabinfo.c~christoph-has-moved Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~christoph-has-moved
+++ a/Documentation/vm/slabinfo.c
@@ -1,7 +1,7 @@
 /*
  * Slabinfo: Tool to get reports about slabs
  *
- * (C) 2007 sgi, Christoph Lameter <clameter@sgi.com>
+ * (C) 2007 sgi, Christoph Lameter
  *
  * Compile by:
  *
@@ -99,7 +99,7 @@ void fatal(const char *x, ...)
 
 void usage(void)
 {
-	printf("slabinfo 5/7/2007. (c) 2007 sgi. clameter@sgi.com\n\n"
+	printf("slabinfo 5/7/2007. (c) 2007 sgi.\n\n"
 		"slabinfo [-ahnpvtsz] [-d debugopts] [slab-regexp]\n"
 		"-a|--aliases           Show aliases\n"
 		"-A|--activity          Most active slabs first\n"
diff -puN Documentation/vm/slub.txt~christoph-has-moved Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~christoph-has-moved
+++ a/Documentation/vm/slub.txt
@@ -266,4 +266,4 @@ of other objects.
 
 	slub_debug=FZ,dentry
 
-Christoph Lameter, <clameter@sgi.com>, May 30, 2007
+Christoph Lameter, May 30, 2007
diff -puN MAINTAINERS~christoph-has-moved MAINTAINERS
--- a/MAINTAINERS~christoph-has-moved
+++ a/MAINTAINERS
@@ -3688,7 +3688,7 @@ S:	Maintained
 
 SLAB ALLOCATOR
 P:	Christoph Lameter
-M:	clameter@sgi.com
+M:	cl@linux-foundation.org
 P:	Pekka Enberg
 M:	penberg@cs.helsinki.fi
 P:	Matt Mackall
diff -puN include/asm-generic/atomic.h~christoph-has-moved include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~christoph-has-moved
+++ a/include/asm-generic/atomic.h
@@ -2,7 +2,7 @@
 #define _ASM_GENERIC_ATOMIC_H
 /*
  * Copyright (C) 2005 Silicon Graphics, Inc.
- *	Christoph Lameter <clameter@sgi.com>
+ *	Christoph Lameter
  *
  * Allows to provide arch independent atomic definitions without the need to
  * edit all arch specific atomic.h files.
diff -puN include/linux/slab.h~christoph-has-moved include/linux/slab.h
--- a/include/linux/slab.h~christoph-has-moved
+++ a/include/linux/slab.h
@@ -1,7 +1,7 @@
 /*
  * Written by Mark Hemment, 1996 (markhe@nextd.demon.co.uk).
  *
- * (C) SGI 2006, Christoph Lameter <clameter@sgi.com>
+ * (C) SGI 2006, Christoph Lameter
  * 	Cleaned up and restructured to ease the addition of alternative
  * 	implementations of SLAB allocators.
  */
diff -puN include/linux/slub_def.h~christoph-has-moved include/linux/slub_def.h
--- a/include/linux/slub_def.h~christoph-has-moved
+++ a/include/linux/slub_def.h
@@ -4,7 +4,7 @@
 /*
  * SLUB : A Slab allocator without object queues.
  *
- * (C) 2007 SGI, Christoph Lameter <clameter@sgi.com>
+ * (C) 2007 SGI, Christoph Lameter
  */
 #include <linux/types.h>
 #include <linux/gfp.h>
diff -puN kernel/workqueue.c~christoph-has-moved kernel/workqueue.c
--- a/kernel/workqueue.c~christoph-has-moved
+++ a/kernel/workqueue.c
@@ -13,7 +13,7 @@
  *   Kai Petzke <wpp@marie.physik.tu-berlin.de>
  *   Theodore Ts'o <tytso@mit.edu>
  *
- * Made to use alloc_percpu by Christoph Lameter <clameter@sgi.com>.
+ * Made to use alloc_percpu by Christoph Lameter.
  */
 
 #include <linux/module.h>
diff -puN lib/radix-tree.c~christoph-has-moved lib/radix-tree.c
--- a/lib/radix-tree.c~christoph-has-moved
+++ a/lib/radix-tree.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2001 Momchil Velikov
  * Portions Copyright (C) 2001 Christoph Hellwig
- * Copyright (C) 2005 SGI, Christoph Lameter <clameter@sgi.com>
+ * Copyright (C) 2005 SGI, Christoph Lameter
  * Copyright (C) 2006 Nick Piggin
  *
  * This program is free software; you can redistribute it and/or
diff -puN mm/allocpercpu.c~christoph-has-moved mm/allocpercpu.c
--- a/mm/allocpercpu.c~christoph-has-moved
+++ a/mm/allocpercpu.c
@@ -1,7 +1,7 @@
 /*
  * linux/mm/allocpercpu.c
  *
- * Separated from slab.c August 11, 2006 Christoph Lameter <clameter@sgi.com>
+ * Separated from slab.c August 11, 2006 Christoph Lameter
  */
 #include <linux/mm.h>
 #include <linux/module.h>
diff -puN mm/migrate.c~christoph-has-moved mm/migrate.c
--- a/mm/migrate.c~christoph-has-moved
+++ a/mm/migrate.c
@@ -9,7 +9,7 @@
  * IWAMOTO Toshihiro <iwamoto@valinux.co.jp>
  * Hirokazu Takahashi <taka@valinux.co.jp>
  * Dave Hansen <haveblue@us.ibm.com>
- * Christoph Lameter <clameter@sgi.com>
+ * Christoph Lameter
  */
 
 #include <linux/migrate.h>
diff -puN mm/slub.c~christoph-has-moved mm/slub.c
--- a/mm/slub.c~christoph-has-moved
+++ a/mm/slub.c
@@ -5,7 +5,7 @@
  * The allocator synchronizes using per slab locks and only
  * uses a centralized lock to manage a pool of partial slabs.
  *
- * (C) 2007 SGI, Christoph Lameter <clameter@sgi.com>
+ * (C) 2007 SGI, Christoph Lameter
  */
 
 #include <linux/mm.h>
diff -puN mm/sparse-vmemmap.c~christoph-has-moved mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~christoph-has-moved
+++ a/mm/sparse-vmemmap.c
@@ -1,7 +1,7 @@
 /*
  * Virtual Memory Map support
  *
- * (C) 2007 sgi. Christoph Lameter <clameter@sgi.com>.
+ * (C) 2007 sgi. Christoph Lameter.
  *
  * Virtual memory maps allow VM primitives pfn_to_page, page_to_pfn,
  * virt_to_page, page_address() to be implemented as a base offset
_

Patches currently in -mm which might be from clameter@sgi.com are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
git-unionfs.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
memcg-better-migration-handling.patch
mm-speculative-page-references-hugh-fix3.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
mm-allocpercpuc-make-4-functions-static.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

