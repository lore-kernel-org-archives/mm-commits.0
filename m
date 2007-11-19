From: akpm@linux-foundation.org
Subject: - arch-x86-remove-duplicate-includes.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:37 -0800
Message-ID: <200711192316.lAJNGb3o001784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbXKSX1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:27:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-x86-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/x86: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hpet.c           |    1 -
 arch/x86/kernel/pci-calgary_64.c |    1 -
 arch/x86/vdso/vclock_gettime.c   |    1 -
 3 files changed, 3 deletions(-)

diff -puN arch/x86/kernel/hpet.c~arch-x86-remove-duplicate-includes arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~arch-x86-remove-duplicate-includes
+++ a/arch/x86/kernel/hpet.c
@@ -6,7 +6,6 @@
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
-#include <linux/delay.h>
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
diff -puN arch/x86/kernel/pci-calgary_64.c~arch-x86-remove-duplicate-includes arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~arch-x86-remove-duplicate-includes
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -30,7 +30,6 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
diff -puN arch/x86/kernel/time_64.c~arch-x86-remove-duplicate-includes arch/x86/kernel/time_64.c
diff -puN arch/x86/vdso/vclock_gettime.c~arch-x86-remove-duplicate-includes arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~arch-x86-remove-duplicate-includes
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -19,7 +19,6 @@
 #include <asm/hpet.h>
 #include <asm/unistd.h>
 #include <asm/io.h>
-#include <asm/vgtod.h>
 #include "vextern.h"
 
 #define gtod vdso_vsyscall_gtod_data
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-arm-removed-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
git-mips.patch
arch-parisc-remove-duplicate-includes.patch
git-x86.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
