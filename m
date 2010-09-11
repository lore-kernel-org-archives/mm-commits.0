From: akpm@linux-foundation.org
Subject: + efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:16:03 -0700
Message-ID: <201009110016.o8B0G4Fx011308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKAQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lmacken@redhat.com, pjones@redhat.com


The patch titled
     efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch

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
Subject: efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that '=' (ctx:VxW)
#64: FILE: drivers/video/efifb.c:85:
+	[M_MINI_3_1]= { "mini31", 0x40010000, 1024 * 4, 1024, 768 },
 	            ^

ERROR: spaces required around that '=' (ctx:VxW)
#65: FILE: drivers/video/efifb.c:86:
+	[M_MINI_4_1]= { "mini41", 0xc0010000, 2048 * 4, 1920, 1200 },
 	            ^

total: 2 errors, 0 warnings, 94 lines checked

./patches/efifb-support-the-efi-framebuffer-on-more-apple-hardware.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Luke Macken <lmacken@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/efifb.c~efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes drivers/video/efifb.c
--- a/drivers/video/efifb.c~efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes
+++ a/drivers/video/efifb.c
@@ -82,8 +82,8 @@ static struct efifb_dmi_info {
 	[M_I24_10_1] = { "imac10", 0xc0010000, 2048 * 4, 1920, 1080 },
 	[M_I27_11_1] = { "imac11", 0xc0010000, 2560 * 4, 2560, 1440 },
 	[M_MINI]= { "mini", 0x80000000, 2048 * 4, 1024, 768 },
-	[M_MINI_3_1]= { "mini31", 0x40010000, 1024 * 4, 1024, 768 },
-	[M_MINI_4_1]= { "mini41", 0xc0010000, 2048 * 4, 1920, 1200 },
+	[M_MINI_3_1] = { "mini31", 0x40010000, 1024 * 4, 1024, 768 },
+	[M_MINI_4_1] = { "mini41", 0xc0010000, 2048 * 4, 1920, 1200 },
 	[M_MB] = { "macbook", 0x80000000, 2048 * 4, 1280, 800 },
 	[M_MB_5_1] = { "macbook51", 0x80010000, 2048 * 4, 1280, 800 },
 	[M_MB_6_1] = { "macbook61", 0x80010000, 2048 * 4, 1280, 800 },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
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

