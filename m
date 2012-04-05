From: akpm@linux-foundation.org
Subject: [folded] simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 05 Apr 2012 14:18:11 -0700
Message-ID: <20120405211811.4B670A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35787 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2DEVSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 17:18:12 -0400
Received: by vbnl22 with SMTP id l22so217259vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 14:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sboyd@codeaurora.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: simple_open-automatically-convert-to-simple_open-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch

This patch was dropped because it was folded into simple_open-automatically-convert-to-simple_open.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: simple_open-automatically-convert-to-simple_open-checkpatch-fixes

Cc: Al Viro <viro@zeniv.linux.org.uk>

WARNING: please, no space before tabs
#1565: FILE: drivers/net/wireless/iwlwifi/iwl-debugfs.c:91:
+^I.open = simple_open,                    ^I^I^I\$

WARNING: please, no space before tabs
#1574: FILE: drivers/net/wireless/iwlwifi/iwl-debugfs.c:99:
+^I.open = simple_open,                    ^I^I^I\$

WARNING: please, no space before tabs
#1583: FILE: drivers/net/wireless/iwlwifi/iwl-debugfs.c:110:
+^I.open = simple_open,                            ^I^I\$

total: 0 errors, 3 warnings, 2133 lines checked

./patches/simple_open-automatically-convert-to-simple_open.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-debugfs.c~simple_open-automatically-convert-to-simple_open-checkpatch-fixes drivers/net/wireless/iwlwifi/iwl-debugfs.c
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c~simple_open-automatically-convert-to-simple_open-checkpatch-fixes
+++ a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -88,7 +88,7 @@ static ssize_t iwl_dbgfs_##name##_write(
 	DEBUGFS_READ_FUNC(name);                                        \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.read = iwl_dbgfs_##name##_read,                       		\
-	.open = simple_open,                    			\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -96,7 +96,7 @@ static const struct file_operations iwl_
 	DEBUGFS_WRITE_FUNC(name);                                       \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
-	.open = simple_open,                    			\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
@@ -107,7 +107,7 @@ static const struct file_operations iwl_
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
 	.write = iwl_dbgfs_##name##_write,                              \
 	.read = iwl_dbgfs_##name##_read,                                \
-	.open = simple_open,                            		\
+	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

