From: akpm@linux-foundation.org
Subject: + vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
 added to -mm tree
Date: Wed, 11 May 2016 11:50:25 -0700
Message-ID: <57337ef1.Co4uehh0m5wYRe7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbcEKSu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2016 14:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix
has been added to the -mm tree.  Its filename is
     vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch

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
Subject: vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix

fix indentation, per Michal

Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix mm/vmstat.c
--- a/mm/vmstat.c~vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix
+++ a/mm/vmstat.c
@@ -1498,7 +1498,7 @@ static void vmstat_shepherd(struct work_
 		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
 		if (!delayed_work_pending(dw) && need_update(cpu))
-				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
+			queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
 	}
 	put_online_cpus();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
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
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

