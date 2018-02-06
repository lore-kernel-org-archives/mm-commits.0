From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
 removed from -mm tree
Date: Tue, 06 Feb 2018 15:23:49 -0800
Message-ID: <5a7a3905.ykS1OxIPf3B+nCfK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753673AbeBFXXu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:23:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch

This patch was dropped because it was folded into kasan-clean-up-kasan_shadow_scale_shift-usage.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes

WARNING: please, no space before tabs
#52: FILE: arch/arm64/include/asm/kasan.h:30:
+ * ^I^I^I^I(1ULL << (64 - KASAN_SHADOW_SCALE_SHIFT))$

total: 0 errors, 1 warnings, 83 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/kasan-clean-up-kasan_shadow_scale_shift-usage.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes arch/arm64/include/asm/kasan.h
--- a/arch/arm64/include/asm/kasan.h~kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes
+++ a/arch/arm64/include/asm/kasan.h
@@ -27,7 +27,7 @@
  * [KASAN_SHADOW_OFFSET, KASAN_SHADOW_END) cover all 64-bits of virtual
  * addresses. So KASAN_SHADOW_OFFSET should satisfy the following equation:
  *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END -
- * 				(1ULL << (64 - KASAN_SHADOW_SCALE_SHIFT))
+ *				(1ULL << (64 - KASAN_SHADOW_SCALE_SHIFT))
  */
 #define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << \
 					(64 - KASAN_SHADOW_SCALE_SHIFT)))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-clean-up-kasan_shadow_scale_shift-usage.patch
lib-ubsanc-s-missaligned-misaligned.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch

