From: akpm@linux-foundation.org
Subject: - arm26-remove-broken-and-unused-macro.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:49 -0700
Message-ID: <200707162050.l6GKon4D001336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758710AbXGPVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     arm26: remove broken and unused macro
has been removed from the -mm tree.  Its filename was
     arm26-remove-broken-and-unused-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm26: remove broken and unused macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arm26/mm/init.c~arm26-remove-broken-and-unused-macro arch/arm26/mm/init.c
--- a/arch/arm26/mm/init.c~arm26-remove-broken-and-unused-macro
+++ a/arch/arm26/mm/init.c
@@ -33,9 +33,6 @@
 
 #include <asm/map.h>
 
-
-#define TABLE_SIZE	PTRS_PER_PTE * sizeof(pte_t))
-
 struct mmu_gather mmu_gathers[NR_CPUS];
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
powerpc-tlb_32c-build-fix.patch
mtd-add-module-license-to-mtdbdi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
driver-edac-i5000-define-typo.patch
