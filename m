From: akpm@linux-foundation.org
Subject: [merged] include-linux-securityh-fix-security_inode_init_security-arg.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:22:11 -0800
Message-ID: <201111172022.pAHKMBKa019127@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33946 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:22:14 -0500
Received: by mail-ey0-f202.google.com with SMTP id 5so48436eyg.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:22:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/security.h: fix security_inode_init_security() arg
has been removed from the -mm tree.  Its filename was
     include-linux-securityh-fix-security_inode_init_security-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/security.h: fix security_inode_init_security() arg

Make the security_inode_init_security() initxattrs arg const, to match the
non-stubbed version of that function.

Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/security.h~include-linux-securityh-fix-security_inode_init_security-arg include/linux/security.h
--- a/include/linux/security.h~include-linux-securityh-fix-security_inode_init_security-arg
+++ a/include/linux/security.h
@@ -2044,7 +2044,7 @@ static inline void security_inode_free(s
 static inline int security_inode_init_security(struct inode *inode,
 						struct inode *dir,
 						const struct qstr *qstr,
-						initxattrs initxattrs,
+						const initxattrs initxattrs,
 						void *fs_data)
 {
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
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

