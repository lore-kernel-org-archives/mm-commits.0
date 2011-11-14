From: akpm@linux-foundation.org
Subject: + workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch added to -mm tree
Date: Mon, 14 Nov 2011 14:13:25 -0800
Message-ID: <201111142213.pAEMDPKg020701@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:41153 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1KNWN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 17:13:28 -0500
Received: by ggnp4 with SMTP id p4so87685ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 14:13:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org


The patch titled
     Subject: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix
has been added to the -mm tree.  Its filename is
     workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix
+++ a/include/linux/workqueue.h
@@ -298,8 +298,7 @@ extern struct workqueue_struct *system_f
 
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
-		      struct lock_class_key *key, const char *lock_name, ...)
-	__attribute__((format (printf, 1, 6)));
+	struct lock_class_key *key, const char *lock_name, ...) __printf(1, 6);
 
 /**
  * alloc_workqueue - allocate a workqueue
_
Subject: Subject: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

