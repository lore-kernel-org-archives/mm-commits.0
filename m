From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch removed from -mm tree
Date: Mon, 09 Apr 2012 14:59:49 -0700
Message-ID: <20120409215949.A0546A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61632 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2DIV7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Apr 2012 17:59:50 -0400
Received: by qabg24 with SMTP id g24so323155qab.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Apr 2012 14:59:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2 kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2
+++ a/kernel/kcmp.c
@@ -151,7 +151,7 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t
 			       task2->sysvsem.undo_list,
 			       KCMP_SYSVSEM);
 #else
-		ret = -EOPNOTSUP;
+		ret = -EOPNOTSUPP;
 #endif
 		break;
 	default:
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
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

