From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch removed from -mm tree
Date: Thu, 12 Feb 2015 14:12:25 -0800
Message-ID: <54dd2549.4ghvPxsIzxaKotm9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbbBLWM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andre.przywara@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch

This patch was dropped because it was folded into mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix

fix build with STRICT_MM_TYPECHECKS

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -259,7 +259,7 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 /* represent a notpresent pmd by zero, this is used by pmdp_invalidate */
 static inline pmd_t pmd_mknotpresent(pmd_t pmd)
 {
-	return 0;
+	return __pmd(0);
 }
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
zram-rework-reset-and-destroy-path-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

