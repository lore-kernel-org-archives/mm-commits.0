From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 03 Apr 2012 12:55:46 -0700
Message-ID: <20120403195549.5F779A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42962 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2DCTzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 15:55:52 -0400
Received: by qabg24 with SMTP id g24so42643qab.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 12:55:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                               |    3 ---
 arch/arm/mach-tegra/include/mach/debug-macro.S |    4 ----
 drivers/input/tablet/wacom_sys.c               |    3 ---
 3 files changed, 10 deletions(-)

diff -puN arch/arm/Kconfig~linux-next-git-rejects arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-next-git-rejects
+++ a/arch/arm/Kconfig
@@ -34,10 +34,7 @@ config ARM
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
-<<<<<<< HEAD
-=======
 	select IRQ_DOMAIN
->>>>>>> linux-next/akpm-end
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff -puN arch/arm/mach-tegra/include/mach/debug-macro.S~linux-next-git-rejects arch/arm/mach-tegra/include/mach/debug-macro.S
--- a/arch/arm/mach-tegra/include/mach/debug-macro.S~linux-next-git-rejects
+++ a/arch/arm/mach-tegra/include/mach/debug-macro.S
@@ -25,10 +25,6 @@
  */
 
 #include <linux/serial_reg.h>
-<<<<<<< HEAD
-
-=======
->>>>>>> linux-next/akpm-end
 #include <mach/iomap.h>
 #include <mach/irammap.h>
 
diff -puN drivers/input/tablet/wacom_sys.c~linux-next-git-rejects drivers/input/tablet/wacom_sys.c
--- a/drivers/input/tablet/wacom_sys.c~linux-next-git-rejects
+++ a/drivers/input/tablet/wacom_sys.c
@@ -1002,11 +1002,8 @@ static int wacom_probe(struct usb_interf
 		return -EINVAL;
 
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
-<<<<<<< HEAD
 	if (!wacom)
 		return -ENOMEM;
-=======
->>>>>>> linux-next/akpm-end
 
 	wacom_wac = &wacom->wacom_wac;
 	wacom_wac->features = *((struct wacom_features *)id->driver_info);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
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

