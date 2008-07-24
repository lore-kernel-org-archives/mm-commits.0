From: akpm@linux-foundation.org
Subject: - bootmem-clean-up-bootmemc-file-header.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:48 -0700
Message-ID: <200807242323.m6ONNmGM010716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbYGXXYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     bootmem: clean up bootmem.c file header
has been removed from the -mm tree.  Its filename was
     bootmem-clean-up-bootmemc-file-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: clean up bootmem.c file header
From: Johannes Weiner <hannes@saeurebad.de>

Change the description, move a misplaced comment about the allocator
itself and add me to the list of copyright holders.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN mm/bootmem.c~bootmem-clean-up-bootmemc-file-header mm/bootmem.c
--- a/mm/bootmem.c~bootmem-clean-up-bootmemc-file-header
+++ a/mm/bootmem.c
@@ -1,12 +1,12 @@
 /*
- *  linux/mm/bootmem.c
+ *  bootmem - A boot-time physical memory allocator and configurator
  *
  *  Copyright (C) 1999 Ingo Molnar
- *  Discontiguous memory support, Kanoj Sarcar, SGI, Nov 1999
+ *                1999 Kanoj Sarcar, SGI
+ *                2008 Johannes Weiner
  *
- *  simple boot-time physical memory area allocator and
- *  free memory collector. It's used to deal with reserved
- *  system memory and memory holes as well.
+ * Access to this subsystem has to be serialized externally (which is true
+ * for the boot process anyway).
  */
 #include <linux/init.h>
 #include <linux/pfn.h>
@@ -19,10 +19,6 @@
 
 #include "internal.h"
 
-/*
- * Access to this subsystem has to be serialized externally. (this is
- * true for the boot process anyway)
- */
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

