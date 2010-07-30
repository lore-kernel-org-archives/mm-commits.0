From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes.patch added to -mm tree
Date: Fri, 30 Jul 2010 15:39:35 -0700
Message-ID: <201007302239.o6UMdZBJ005156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910Ab0G3WkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 18:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, maximlevitsky@gmail.com


The patch titled
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#124: FILE: drivers/mmc/core/core.c:1373:
+EXPORT_SYMBOL(mmc_resume_host);

total: 0 errors, 1 warnings, 128 lines checked

./patches/mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes
+++ a/drivers/mmc/core/core.c
@@ -1369,7 +1369,6 @@ int mmc_pm_notify(struct notifier_block 
 
 	return 0;
 }
-
 EXPORT_SYMBOL(mmc_resume_host);
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-checkpatch-fixes.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

