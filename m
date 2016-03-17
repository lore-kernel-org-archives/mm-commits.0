From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:58:08 -0700
Message-ID: <56eb1a60.Ly5T4M70eDqTxJfI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQU6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix
has been removed from the -mm tree.  Its filename was
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch

This patch was dropped because it was folded into mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix

tweak Kconfig text, per Vlastimil

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix
+++ a/mm/Kconfig.debug
@@ -86,10 +86,9 @@ config DEBUG_PAGE_REF
 	depends on DEBUG_KERNEL
 	depends on TRACEPOINTS
 	---help---
-	  This is the feature to add tracepoint for tracking down page reference
-	  manipulation. This tracking is useful to diagnosis functional failure
-	  due to migration failure caused by page reference mismatch. Be
-	  careful to turn on this feature because it could bloat some kernel
-	  text. In my configuration, it bloats 30 KB. Although kernel text will
-	  be bloated, there would be no runtime performance overhead if
-	  tracepoint isn't enabled thanks to jump label.
+	  This is a feature to add tracepoint for tracking down page reference
+	  manipulation. This tracking is useful to diagnose functional failure
+	  due to migration failures caused by page reference mismatches.  Be
+	  careful when enabling this feature because it adds about 30 KB to the
+	  kernel code.  However the runtime performance overhead is virtually
+	  nil until the tracepoints are actually enabled.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sscanf-implement-basic-character-sets-fix.patch

