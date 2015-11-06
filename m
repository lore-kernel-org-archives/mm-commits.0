From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-various-fixes-in-documentation-checkpatch-fixes.patch removed from
 -mm tree
Date: Thu, 05 Nov 2015 18:31:55 -0800
Message-ID: <563c111b.OFE4X7CtsbfwwbyL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-various-fixes-in-documentation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kasan-various-fixes-in-documentation-checkpatch-fixes.patch

This patch was dropped because it was folded into kasan-various-fixes-in-documentation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-various-fixes-in-documentation-checkpatch-fixes

WARNING: 'happend' may be misspelled - perhaps 'happened'?
#79: FILE: Documentation/kasan.txt:121:
+The header of the report discribe what kind of bug happend and what kind of

total: 0 errors, 1 warnings, 82 lines checked

./patches/kasan-various-fixes-in-documentation.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kasan.txt~kasan-various-fixes-in-documentation-checkpatch-fixes Documentation/kasan.txt
--- a/Documentation/kasan.txt~kasan-various-fixes-in-documentation-checkpatch-fixes
+++ a/Documentation/kasan.txt
@@ -118,7 +118,7 @@ Memory state around the buggy address:
  ffff8800693bc800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================
 
-The header of the report discribe what kind of bug happend and what kind of
+The header of the report discribe what kind of bug happened and what kind of
 access caused it. It's followed by the description of the accessed slub object
 (see 'SLUB Debug output' section in Documentation/vm/slub.txt for details) and
 the description of the accessed memory page.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures.patch
kasan-various-fixes-in-documentation.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

