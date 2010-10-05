From: akpm@linux-foundation.org
Subject: + vfs-allow-mnt_want_write-to-sleep-fix.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:56 -0700
Message-ID: <201010051942.o95JguxG015713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab0JETnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     vfs-allow-mnt_want_write-to-sleep-fix
has been added to the -mm tree.  Its filename is
     vfs-allow-mnt_want_write-to-sleep-fix.patch

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
Subject: vfs-allow-mnt_want_write-to-sleep-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix tpyo

Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~vfs-allow-mnt_want_write-to-sleep-fix include/linux/fs.h
--- a/include/linux/fs.h~vfs-allow-mnt_want_write-to-sleep-fix
+++ a/include/linux/fs.h
@@ -1380,7 +1380,7 @@ struct super_block {
 	struct mutex s_vfs_rename_mutex;	/* Kludge */
 
 	/*
-	 * Wait queue for remouting read-only
+	 * Wait queue for remounting read-only
 	 */
 	wait_queue_head_t s_wait_remount_readonly;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-thresholds-with-use_hierarchy-==-1-fix.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-mips-include-asm-fcntlh-needs-typesh.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
serial8250-ratelimit-too-much-work-error-fix.patch
serial8250-ratelimit-too-much-work-error-fix-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch
m68k-__pa-cast-arg-to-long.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix.patch
vcs-add-poll-fasync-support-fix-fix.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

