From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 13 Jan 2017 13:32:01 -0800
Message-ID: <58794751.dWpqKq1nO8wXePvq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 16:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.h          |    3 ---
 drivers/md/raid5-cache.c |    4 ----
 2 files changed, 7 deletions(-)

diff -puN drivers/md/md.h~linux-next-git-rejects drivers/md/md.h
--- a/drivers/md/md.h~linux-next-git-rejects
+++ a/drivers/md/md.h
@@ -710,9 +710,6 @@ static inline void mddev_clear_unsupport
 {
 	mddev->flags &= ~unsupported_flags;
 }
-<<<<<<< HEAD
-=======
 
 extern void md_writesame_setup(struct mddev *mddev, struct bio *bio);
->>>>>>> linux-next/akpm-base
 #endif /* _MD_MD_H */
diff -puN drivers/md/raid5-cache.c~linux-next-git-rejects drivers/md/raid5-cache.c
--- a/drivers/md/raid5-cache.c~linux-next-git-rejects
+++ a/drivers/md/raid5-cache.c
@@ -2499,11 +2499,7 @@ void r5c_finish_stripe_write_out(struct
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
 
-<<<<<<< HEAD
-	spin_lock_irq(&conf->log->stripe_in_journal_lock);
-=======
 	spin_lock_irq(&log->stripe_in_journal_lock);
->>>>>>> linux-next/akpm-base
 	list_del_init(&sh->r5c);
 	spin_unlock_irq(&log->stripe_in_journal_lock);
 	sh->log_start = MaxSector;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

