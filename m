From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 17 Oct 2012 14:16:49 -0700
Message-ID: <20121017211650.0870F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45941 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2JQVQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 17:16:51 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so900090vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 14:16:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
pidns-remove-recursion-from-free_pid_ns-v5-fix.patch
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
linux-next-git-rejects.patch

