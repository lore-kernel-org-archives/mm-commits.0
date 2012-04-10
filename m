From: akpm@linux-foundation.org
Subject: [folded] c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch removed from -mm tree
Date: Tue, 10 Apr 2012 11:32:21 -0700
Message-ID: <20120410183221.58A63A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36621 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2DJScW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 14:32:22 -0400
Received: by yhgm50 with SMTP id m50so14307yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 11:32:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avagin@openvz.org, gorcunov@openvz.org, oleg@redhat.com, palves@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c-r-prctl-add-ability-to-get-clear_tid_address-fix
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

This patch was dropped because it was folded into c-r-prctl-add-ability-to-get-clear_tid_address.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: c-r-prctl-add-ability-to-get-clear_tid_address-fix

fix prctl numbering

Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address-fix include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address-fix
+++ a/include/linux/prctl.h
@@ -130,6 +130,6 @@
 #define PR_SET_CHILD_SUBREAPER 36
 #define PR_GET_CHILD_SUBREAPER 37
 
-#define PR_GET_TID_ADDRESS		36
+#define PR_GET_TID_ADDRESS     38
 
 #endif /* _LINUX_PRCTL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

