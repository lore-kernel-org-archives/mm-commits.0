From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 19 Feb 2015 10:48:49 -0800
Message-ID: <54e63011.8aG6t9rjHwAUPw93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbBSSsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Feb 2015 13:48:50 -0500
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

 drivers/watchdog/Makefile |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/watchdog/Makefile~linux-next-git-rejects drivers/watchdog/Makefile
--- a/drivers/watchdog/Makefile~linux-next-git-rejects
+++ a/drivers/watchdog/Makefile
@@ -144,10 +144,7 @@ octeon-wdt-y := octeon-wdt-main.o octeon
 obj-$(CONFIG_LANTIQ_WDT) += lantiq_wdt.o
 obj-$(CONFIG_RALINK_WDT) += rt2880_wdt.o
 obj-$(CONFIG_IMGPDC_WDT) += imgpdc_wdt.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_MT7621_WDT) += mt7621_wdt.o
->>>>>>> linux-next/akpm-base
 
 # PARISC Architecture
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
linux-next-fixup.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

