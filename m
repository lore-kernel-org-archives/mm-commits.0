From: akpm@linux-foundation.org
Subject: + arch-x86-remove-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:36:00 -0800
Message-ID: <200711060236.lA62a0mW032042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbXKFCic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-x86-remove-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 arch/x86/kernel/time_64.c        |    1 -
 arch/x86/vdso/vclock_gettime.c   |    1 -
 4 files changed, 4 deletions(-)

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
--- a/arch/x86/kernel/time_64.c~arch-x86-remove-duplicate-includes
+++ a/arch/x86/kernel/time_64.c
@@ -41,7 +41,6 @@
 #include <asm/sections.h>
 #include <linux/hpet.h>
 #include <asm/apic.h>
-#include <asm/hpet.h>
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
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

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
