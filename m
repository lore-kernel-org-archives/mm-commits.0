From: akpm@linux-foundation.org
Subject: [folded] fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch removed from -mm tree
Date: Thu, 05 Apr 2012 14:17:38 -0700
Message-ID: <20120405211739.2F7C2A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57076 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2DEVRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 17:17:42 -0400
Received: by faaa19 with SMTP id a19so94617faa.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 14:17:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix
has been removed from the -mm tree.  Its filename was
     fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch

This patch was dropped because it was folded into fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix
+++ a/fs/xattr.c
@@ -19,8 +19,9 @@
 #include <linux/export.h>
 #include <linux/fsnotify.h>
 #include <linux/audit.h>
-#include <asm/uaccess.h>
+#include <linux/vmalloc.h>
 
+#include <asm/uaccess.h>
 
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
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

