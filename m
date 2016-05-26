From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch removed from -mm tree
Date: Thu, 26 May 2016 15:13:47 -0700
Message-ID: <5747751b.fOtIQqewvwdiCehX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbcEZWNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, minchan@kernel.org, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch

This patch was dropped because it was folded into mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix

fix typo, per Minchan

Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix
+++ a/include/linux/sched.h
@@ -2745,7 +2745,7 @@ static inline bool mmget_not_zero(struct
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
 #ifdef CONFIG_MMU
-/* same as above but performs the slow path from the async kontext. Can
+/* same as above but performs the slow path from the async context. Can
  * be called from the atomic context as well
  */
 extern void mmput_async(struct mm_struct *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

