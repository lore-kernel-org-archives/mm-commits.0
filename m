From: akpm@linux-foundation.org
Subject: - make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:11 -0700
Message-ID: <200707192008.l6JK8BR7020434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760919AbXGSUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     make arch/i386/kernel/setup.c:remapped_pgdat_init() static
has been removed from the -mm tree.  Its filename was
     make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make arch/i386/kernel/setup.c:remapped_pgdat_init() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/setup.c~make-arch-i386-kernel-setupcremapped_pgdat_init-static arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~make-arch-i386-kernel-setupcremapped_pgdat_init-static
+++ a/arch/i386/kernel/setup.c
@@ -466,7 +466,7 @@ void __init setup_bootmem_allocator(void
  *
  * This should all compile down to nothing when NUMA is off.
  */
-void __init remapped_pgdat_init(void)
+static void __init remapped_pgdat_init(void)
 {
 	int nid;
 
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
