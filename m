From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:45:43 -0800
Message-ID: <548b8c37.VxF7DtZ8hMHiNy2I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaLMApo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, fengguang.wu@intel.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix

remove now-unused ZS_SIZE_CLASSES

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix
+++ a/mm/zsmalloc.c
@@ -155,8 +155,6 @@
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
-#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
-					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
  * We do not maintain any list for completely empty or full pages
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

