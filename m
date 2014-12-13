From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch removed from
 -mm tree
Date: Fri, 12 Dec 2014 16:47:53 -0800
Message-ID: <548b8cb9.IEIZTvFUtg0hoywK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaLMAry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-msg-increase-msgmni-remove-scaling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes

WARNING: 'dependant' may be misspelled - perhaps 'dependent'?
#134: FILE: include/uapi/linux/msg.h:66:
+ * size. The optimal value is application dependant.

total: 0 errors, 1 warnings, 378 lines checked

./patches/ipc-msg-increase-msgmni-remove-scaling.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/msg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/msg.h~ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes include/uapi/linux/msg.h
--- a/include/uapi/linux/msg.h~ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes
+++ a/include/uapi/linux/msg.h
@@ -63,7 +63,7 @@ struct msginfo {
  * MSGMNB is the default size of a new message queue. Non-root tasks can
  * decrease the size with msgctl(IPC_SET), root tasks
  * (actually: CAP_SYS_RESOURCE) can both increase and decrease the queue
- * size. The optimal value is application dependant.
+ * size. The optimal value is application dependent.
  * 16384 is used because it was always used (since 0.99.10)
  *
  * MAXMAX is the maximum size of an individual message, it's a global
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
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-msg-increase-msgmni-remove-scaling.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

