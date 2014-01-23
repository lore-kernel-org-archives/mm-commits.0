From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:22:04 -0800
Message-ID: <52e1a41c.IRA0vqUlUcyzT6s1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWXWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com, fengguang.wu@intel.com, joe@perches.com

Subject: [folded-merged] printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch removed from -mm tree
To: joe@perches.com,fengguang.wu@intel.com,james.hogan@imgtec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:22:04 -0800


The patch titled
     Subject: printk-cache-mark-printk_once-test-variable-__read_mostly-fix
has been removed from the -mm tree.  Its filename was
     printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch

This patch was dropped because it was folded into printk-cache-mark-printk_once-test-variable-__read_mostly.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk-cache-mark-printk_once-test-variable-__read_mostly-fix

fix ia64 build

Cc: James Hogan <james.hogan@imgtec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/processor.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly-fix arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly-fix
+++ a/arch/ia64/include/asm/processor.h
@@ -71,6 +71,7 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
maintainers-describe-differences-between-f-and-n-patterns.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-only-flag-fsf-address-not-gnuorg-url.patch
checkpatch-add-dt-compatible-string-documentation-checks.patch
checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch

