From: akpm@linux-foundation.org
Subject: [folded-merged]
 fsnotify-rename-event-handling-functions-checkpatch-fixes.patch removed
 from -mm tree
Date: Wed, 06 Aug 2014 15:41:42 -0700
Message-ID: <53e2af26.tIWPodLTWaIc84AL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:61192 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFWln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:41:43 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so838439pab.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:41:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify-rename-event-handling-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fsnotify-rename-event-handling-functions-checkpatch-fixes.patch

This patch was dropped because it was folded into fsnotify-rename-event-handling-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fsnotify-rename-event-handling-functions-checkpatch-fixes

WARNING: line over 80 characters
#121: FILE: fs/notify/notification.c:152:
+ * This will not remove the event, that must be done with fsnotify_remove_first_event()

WARNING: line over 80 characters
#156: FILE: include/linux/fsnotify_backend.h:332:
+extern struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group);

WARNING: line over 80 characters
#159: FILE: include/linux/fsnotify_backend.h:334:
+extern struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group);

total: 0 errors, 3 warnings, 111 lines checked

./patches/fsnotify-rename-event-handling-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/notification.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/notify/notification.c~fsnotify-rename-event-handling-functions-checkpatch-fixes fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-rename-event-handling-functions-checkpatch-fixes
+++ a/fs/notify/notification.c
@@ -149,7 +149,8 @@ struct fsnotify_event *fsnotify_remove_f
 }
 
 /*
- * This will not remove the event, that must be done with fsnotify_remove_first_event()
+ * This will not remove the event, that must be done with
+ * fsnotify_remove_first_event()
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

