From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 18 Dec 2017 11:58:07 -0800
Message-ID: <20171218195807.Q_PuGq2Zz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758334AbdLRT6J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 14:58:09 -0500
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

 drivers/base/power/main.c |    3 ---
 include/linux/pm.h        |    3 ---
 2 files changed, 6 deletions(-)

diff -puN drivers/base/power/main.c~linux-next-git-rejects drivers/base/power/main.c
--- a/drivers/base/power/main.c~linux-next-git-rejects
+++ a/drivers/base/power/main.c
@@ -541,8 +541,6 @@ void dev_pm_skip_next_resume_phases(stru
 }
 
 /**
-<<<<<<< HEAD
-=======
  * dev_pm_may_skip_resume - System-wide device resume optimization check.
  * @dev: Target device.
  *
@@ -555,7 +553,6 @@ bool dev_pm_may_skip_resume(struct devic
 }
 
 /**
->>>>>>> linux-next/akpm-base
  * device_resume_noirq - Execute a "noirq resume" callback for given device.
  * @dev: Device to handle.
  * @state: PM transition of the system being carried out.
diff -puN include/linux/pm.h~linux-next-git-rejects include/linux/pm.h
--- a/include/linux/pm.h~linux-next-git-rejects
+++ a/include/linux/pm.h
@@ -773,10 +773,7 @@ extern int pm_generic_poweroff(struct de
 extern void pm_generic_complete(struct device *dev);
 
 extern void dev_pm_skip_next_resume_phases(struct device *dev);
-<<<<<<< HEAD
-=======
 extern bool dev_pm_may_skip_resume(struct device *dev);
->>>>>>> linux-next/akpm-base
 extern bool dev_pm_smart_suspend_and_suspended(struct device *dev);
 
 #else /* !CONFIG_PM_SLEEP */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

