From: akpm@linux-foundation.org
Subject: - cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:17 -0700
Message-ID: <200707230935.l6N9ZHYQ016472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbXGWJpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     make cpuidle_replace_governor() static
has been removed from the -mm tree.  Its filename was
     cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make cpuidle_replace_governor() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governor.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governor.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix drivers/cpuidle/governor.c
--- a/drivers/cpuidle/governor.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix
+++ a/drivers/cpuidle/governor.c
@@ -147,7 +147,7 @@ EXPORT_SYMBOL_GPL(cpuidle_register_gover
  * @exclude_rating: the rating that will be skipped while looking for
  * new governor.
  */
-struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
+static struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
 {
 	struct cpuidle_governor *gov;
 	struct cpuidle_governor *ret_gov = NULL;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
