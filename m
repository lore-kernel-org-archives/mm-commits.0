From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch removed from -mm tree
Date: Mon, 09 Apr 2012 14:59:43 -0700
Message-ID: <20120409215944.91AE0A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35017 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2DIV7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Apr 2012 17:59:47 -0400
Received: by eekc41 with SMTP id c41so217777eek.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Apr 2012 14:59:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix
+++ a/kernel/kcmp.c
@@ -5,6 +5,7 @@
 #include <linux/random.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/errno.h>
 #include <linux/cache.h>
 #include <linux/bug.h>
 #include <linux/err.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
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
leds-led-module-for-da9052-53-pmic-v2-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

