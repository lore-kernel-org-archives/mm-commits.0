From: akpm@linux-foundation.org
Subject: + arm26-remove-broken-and-unused-macro.patch added to -mm tree
Date: Tue, 29 May 2007 12:46:54 -0700
Message-ID: <200705291946.l4TJksUD009942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760AbXE2TrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, spyro@f2s.com


The patch titled
     arm26: remove broken and unused macro
has been added to the -mm tree.  Its filename is
     arm26-remove-broken-and-unused-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm26: remove broken and unused macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/mm/init.c |    3 ---
 1 files changed, 3 deletions(-)

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

arm26-remove-broken-and-unused-macro.patch
