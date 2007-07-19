From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-i8253c-should-include-asm-timerh.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:13 -0700
Message-ID: <200707192008.l6JK8DA6020437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759447AbXGSUPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/i8253.c should #include <asm/timer.h>
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-i8253c-should-include-asm-timerh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/i386/kernel/i8253.c should #include <asm/timer.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for its
global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/kernel/i8253.c~arch-i386-kernel-i8253c-should-include-asm-timerh arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~arch-i386-kernel-i8253c-should-include-asm-timerh
+++ a/arch/i386/kernel/i8253.c
@@ -13,6 +13,7 @@
 #include <asm/delay.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
+#include <asm/timer.h>
 
 #include "io_ports.h"
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
