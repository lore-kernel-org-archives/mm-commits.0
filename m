From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 18 Oct 2012 12:05:24 -0700
Message-ID: <20121018190525.081C75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63172 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2JRTF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 15:05:27 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so551371wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 12:05:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry.S           |    3 ---
 drivers/pinctrl/pinctrl-nomadik.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN arch/frv/kernel/entry.S~linux-next-git-rejects arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~linux-next-git-rejects
+++ a/arch/frv/kernel/entry.S
@@ -869,14 +869,11 @@ ret_from_kernel_thread:
 	call		schedule_tail
 	calll.p		@(gr21,gr0)
 	or		gr20,gr20,gr8
-<<<<<<< HEAD
 	bra		sys_exit
 
 	.globl		ret_from_kernel_execve
 ret_from_kernel_execve:
 	ori		gr28,0,sp
-=======
->>>>>>> linux-next/akpm-base
 	bra		__syscall_exit
 
 ###################################################################################################
diff -puN drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects drivers/pinctrl/pinctrl-nomadik.c
--- a/drivers/pinctrl/pinctrl-nomadik.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-nomadik.c
@@ -44,10 +44,7 @@ static inline u32 prcmu_read(unsigned in
 static inline void prcmu_write(unsigned int reg, u32 value) {}
 static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value) {}
 #endif
-<<<<<<< HEAD
-=======
 #include <linux/platform_data/pinctrl-nomadik.h>
->>>>>>> linux-next/akpm-base
 
 #include <asm/mach/irq.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pidns-remove-recursion-from-free_pid_ns-v5-fix.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

