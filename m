From: akpm@linux-foundation.org
Subject: +
 procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch added to
 -mm tree
Date: Tue, 26 Apr 2016 17:09:28 -0700
Message-ID: <57200338.c3DuexjFKdzUEHHo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbcD0AJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 20:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jdanis@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix
has been added to the -mm tree.  Its filename is
     procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix

fix spello in comment

Cc: Janis Danisevskis <jdanis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix
+++ a/fs/proc/base.c
@@ -3161,7 +3161,7 @@ int proc_pid_readdir(struct file *file,
  * used for the node /proc/<pid>/task/<tid>/comm.
  * It bypasses generic permission checks in the case where a task of the same
  * task group attempts to access the node.
- * The rational behind this is that glibc and bionic access this node for
+ * The rationale behind this is that glibc and bionic access this node for
  * cross thread naming (pthread_set/getname_np(!self)). However, if
  * PR_SET_DUMPABLE gets set to 0 this node among others becomes uid=0 gid=0,
  * which locks out the cross thread naming implementation.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
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
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

