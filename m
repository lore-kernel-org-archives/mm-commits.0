From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 23 May 2016 13:03:06 -0700
Message-ID: <574361fa.moWSwfsFp22H8jta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbcEWUDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:03:07 -0400
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

 arch/powerpc/include/asm/book3s/64/pgtable.h |    4 ----
 drivers/iommu/arm-smmu.c                     |    3 ---
 2 files changed, 7 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~linux-next-git-rejects arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~linux-next-git-rejects
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -835,10 +835,6 @@ static inline int has_transparent_hugepa
 		return radix__has_transparent_hugepage();
 	return hash__has_transparent_hugepage();
 }
-<<<<<<< HEAD
-#define has_transparent_hugepage has_transparent_hugepage
-=======
->>>>>>> linux-next/akpm-base
 
 static inline unsigned long
 pmd_hugepage_update(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp,
diff -puN drivers/iommu/arm-smmu.c~linux-next-git-rejects drivers/iommu/arm-smmu.c
--- a/drivers/iommu/arm-smmu.c~linux-next-git-rejects
+++ a/drivers/iommu/arm-smmu.c
@@ -397,15 +397,12 @@ struct arm_smmu_domain {
 	struct iommu_domain		domain;
 };
 
-<<<<<<< HEAD
-=======
 struct arm_smmu_phandle_args {
 	struct device_node *np;
 	int args_count;
 	uint32_t args[MAX_MASTER_STREAMIDS];
 };
 
->>>>>>> linux-next/akpm-base
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
 static LIST_HEAD(arm_smmu_devices);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

