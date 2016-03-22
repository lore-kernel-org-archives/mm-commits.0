From: akpm@linux-foundation.org
Subject: [folded-merged]
 oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch removed from -mm tree
Date: Tue, 22 Mar 2016 15:38:58 -0700
Message-ID: <56f1c982.ZeOBfVA1djuCyH4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbcCVWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 18:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix
has been removed from the -mm tree.  Its filename was
     oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2.patch

This patch was dropped because it was folded into oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix

fix a left over

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space-fix-2
+++ a/mm/oom_kill.c
@@ -550,7 +550,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static void wake_oom_reaper(struct task_struct *mm)
+static void wake_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-report-success-failure-fix-fix.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

