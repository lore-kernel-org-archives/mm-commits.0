From: akpm@linux-foundation.org
Subject: + fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch added to -mm tree
Date: Tue, 03 Apr 2012 14:28:06 -0700
Message-ID: <20120403221218.96F891E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44838 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2DCWMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 18:12:20 -0400
Received: by qabg24 with SMTP id g24so61409qab.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 15:12:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix
has been added to the -mm tree.  Its filename is
     fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed-fix.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
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

