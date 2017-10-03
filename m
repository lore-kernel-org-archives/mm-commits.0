From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
 removed from -mm tree
Date: Tue, 03 Oct 2017 16:08:46 -0700
Message-ID: <59d4187e.lGPtK6WS6iBwCneY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdJCXIs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes

WARNING: line over 80 characters
#79: FILE: mm/oom_kill.c:501:
+	 * what they do is basically undeterministic. So let's have a short sleep

total: 0 errors, 1 warnings, 39 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes
+++ a/mm/oom_kill.c
@@ -498,8 +498,8 @@ static bool __oom_reap_task_mm(struct ta
 	/*
 	 * If the mm has notifiers then we would need to invalidate them around
 	 * unmap_page_range and that is risky because notifiers can sleep and
-	 * what they do is basically undeterministic. So let's have a short sleep
-	 * to give the oom victim some more time.
+	 * what they do is basically undeterministic.  So let's have a short
+	 * sleep to give the oom victim some more time.
 	 * TODO: we really want to get rid of this ugly hack and make sure that
 	 * notifiers cannot block for unbounded amount of time and add
 	 * mmu_notifier_invalidate_range_{start,end} around unmap_page_range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

