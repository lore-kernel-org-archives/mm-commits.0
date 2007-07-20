From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-xen-xen-event-channels.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:41:47 -0700
Message-ID: <200707201941.l6KJfl7L012970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763797AbXGTTmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     arch/i386/xen/events.c should #include <asm/xen/hypervisor.h>
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-xen-xen-event-channels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/i386/xen/events.c should #include <asm/xen/hypervisor.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/events.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/xen/events.c~fix-x86_64-mm-xen-xen-event-channels arch/i386/xen/events.c
--- a/arch/i386/xen/events.c~fix-x86_64-mm-xen-xen-event-channels
+++ a/arch/i386/xen/events.c
@@ -31,6 +31,7 @@
 #include <asm/irq.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/events.h>
 #include <xen/interface/xen.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-intel_cacheinfocfind_num_cache_leaves-should.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
spicscan_boardinfo-mustnt-be-__init_or_module.patch
ext2-reservations.patch
rivafb_setup-must-be-__devinit.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
