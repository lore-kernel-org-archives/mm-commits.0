From: akpm@linux-foundation.org
Subject: [alternative-merged] m32r-mark-pmd-folded.patch removed from -mm
 tree
Date: Thu, 26 Feb 2015 12:31:52 -0800
Message-ID: <54ef82b8.aFzLII4Jsf1bAqfx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbbBZUbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 15:31:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: mark PMD folded
has been removed from the -mm tree.  Its filename was
     m32r-mark-pmd-folded.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: m32r: mark PMD folded

Core mm expects __PAGETABLE_{PUD,PMD}_FOLDED to be defined if these page
table levels folded.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/pgtable-2level.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/include/asm/pgtable-2level.h~m32r-mark-pmd-folded arch/m32r/include/asm/pgtable-2level.h
--- a/arch/m32r/include/asm/pgtable-2level.h~m32r-mark-pmd-folded
+++ a/arch/m32r/include/asm/pgtable-2level.h
@@ -13,6 +13,7 @@
  * the M32R is two-level, so we don't really have any
  * PMD directory physically.
  */
+#define __PAGETABLE_PMD_FOLDED
 #define PMD_SHIFT	22
 #define PTRS_PER_PMD	1
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-missing-__pagetable_pudpmd_folded-defines.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
mn10300-mark-pud-and-pmd-folded.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

