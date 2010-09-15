From: akpm@linux-foundation.org
Subject: + drivers-pnp-isapnp-procc-fix-build.patch added to -mm tree
Date: Wed, 15 Sep 2010 15:19:11 -0700
Message-ID: <201009152250.o8FMo02v019962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab0IOWuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 18:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, geert@linux-m68k.org, perex@perex.cz, sfr@canb.auug.org.au


The patch titled
     drivers/pnp/isapnp/proc.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-pnp-isapnp-procc-fix-build.patch

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
Subject: drivers/pnp/isapnp/proc.c: fix build
From: Andrew Morton <akpm@linux-foundation.org>

Everyone busy busy typing, not enough time to compile...

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/isapnp/proc.c~drivers-pnp-isapnp-procc-fix-build drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~drivers-pnp-isapnp-procc-fix-build
+++ a/drivers/pnp/isapnp/proc.c
@@ -45,7 +45,7 @@ static loff_t isapnp_proc_bus_lseek(stru
 		new = 256 + off;
 		break;
 	}
-	if (new < 0 || new > 256) {
+	if (new < 0 || new > 256)
 		new = -EINVAL;
 	else
 		file->f_pos = new;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
drivers-pnp-isapnp-procc-fix-build.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
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
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
mmc_test-move-files-from-sysfs-to-debugfs-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
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

