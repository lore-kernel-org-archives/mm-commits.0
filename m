From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 16:13:59 -0800
Message-ID: <563d4247.i5IqupIDnJvEYGSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbbKGAOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, corbet@lwn.net, linux@rasmusvillemoes.dk, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-documentation-synchronize-%p-formatting-documentation-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch

This patch was dropped because it was folded into lib-documentation-synchronize-%p-formatting-documentation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-documentation-synchronize-%p-formatting-documentation-fix-fix

fix comment

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Martin Kletzander <mkletzan@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation-fix-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation-fix-fix
+++ a/lib/vsprintf.c
@@ -1821,7 +1821,7 @@ qualifier:
  * See pointer() or Documentation/printk-formats.txt for more
  * extensive description.
  *
- * ** Please update the documentation on both places when making changes **
+ * ** Please update the documentation in both places when making changes **
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

