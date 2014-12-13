From: akpm@linux-foundation.org
Subject: [folded-merged]
 zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch removed from
 -mm tree
Date: Fri, 12 Dec 2014 16:44:44 -0800
Message-ID: <548b8bfc.QsSqxdwNJZJoNEkM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaLMAop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch

This patch was dropped because it was folded into zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2

squash bogus gcc warning

Cc: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2 mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2
+++ a/mm/zsmalloc.c
@@ -896,7 +896,7 @@ static void zs_unregister_cpu_notifier(v
 
 static int zs_register_cpu_notifier(void)
 {
-	int cpu, ret;
+	int cpu, uninitialized_var(ret);
 
 	cpu_notifier_register_begin();
 
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
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

