From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch removed
 from -mm tree
Date: Fri, 12 Dec 2014 16:42:51 -0800
Message-ID: <548b8b8b.nPnSh/vNcqo1mp2A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbaLMAmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:42:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, michele.curti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch

This patch was dropped because it was folded into mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix

clean up layout

Cc: Michele Curti <michele.curti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix
+++ a/mm/memcontrol.c
@@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(str
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
 }
+
 #if MAX_NUMNODES > 1
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

