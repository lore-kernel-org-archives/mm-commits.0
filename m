From: akpm@linux-foundation.org
Subject: [folded-merged]
 fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 19 May 2016 16:35:16 -0700
Message-ID: <573e4db4.ZMQ7K+81YyBaIbEF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbcESXfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch

This patch was dropped because it was folded into fsnotify-avoid-spurious-emfile-errors-from-inotify_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes

WARNING: line over 80 characters
#44: FILE: fs/notify/fsnotify.h:61:
+/* wait for fsnotify_mark_srcu period to end and free all marks in destroy_list */

total: 0 errors, 1 warnings, 168 lines checked

./patches/fsnotify-avoid-spurious-emfile-errors-from-inotify_init.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/notify/fsnotify.h~fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes
+++ a/fs/notify/fsnotify.h
@@ -58,7 +58,9 @@ static inline void fsnotify_clear_marks_
 }
 /* prepare for freeing all marks associated with given group */
 extern void fsnotify_detach_group_marks(struct fsnotify_group *group);
-/* wait for fsnotify_mark_srcu period to end and free all marks in destroy_list */
+/*
+ * wait for fsnotify_mark_srcu period to end and free all marks in destroy_list
+ */
 extern void fsnotify_mark_destroy_list(void);
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsnotify-avoid-spurious-emfile-errors-from-inotify_init.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

