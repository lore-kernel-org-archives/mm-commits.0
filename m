From: akpm@linux-foundation.org
Subject: [merged] lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:46 -0700
Message-ID: <5535518e.dYMjwMW/6H0GSKpd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbDTTOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@arm.linux.org.uk, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig: fix up HAVE_ARCH_BITREVERSE help text
has been removed from the -mm tree.  Its filename was
     lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/Kconfig: fix up HAVE_ARCH_BITREVERSE help text

Cc: Yalin Wang <yalin.wang@sonymobile.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/Kconfig~lib-kconfig-fix-up-have_arch_bitreverse-help-text lib/Kconfig
--- a/lib/Kconfig~lib-kconfig-fix-up-have_arch_bitreverse-help-text
+++ a/lib/Kconfig
@@ -18,9 +18,8 @@ config HAVE_ARCH_BITREVERSE
 	default n
 	depends on BITREVERSE
 	help
-	  This option provides an config for the architecture which have instruction
-	  can do bitreverse operation, we use the hardware instruction if the architecture
-	  have this capability.
+	  This option enables the use of hardware bit-reversal instructions on
+	  architectures which support such operations.
 
 config RATIONAL
 	bool
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

