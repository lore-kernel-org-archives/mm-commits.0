From: akpm@linux-foundation.org
Subject: - x86_64-fix-wrong-comment-regarding-set_fixmap.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:25 -0700
Message-ID: <200707192010.l6JKAPfj020671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbXGSUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix wrong comment regarding set_fixmap()
has been removed from the -mm tree.  Its filename was
     x86_64-fix-wrong-comment-regarding-set_fixmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix wrong comment regarding set_fixmap()
From: Jiri Kosina <jkosina@suse.cz>

The function name is set_fixmap(), not fixmap_set() as stated in the comment.

Also fix a typo, punctuation and lower/uppercase a bit.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/fixmap.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-x86_64/fixmap.h~x86_64-fix-wrong-comment-regarding-set_fixmap include/asm-x86_64/fixmap.h
--- a/include/asm-x86_64/fixmap.h~x86_64-fix-wrong-comment-regarding-set_fixmap
+++ a/include/asm-x86_64/fixmap.h
@@ -22,9 +22,9 @@
  * compile time, but to set the physical address only
  * in the boot process.
  *
- * these 'compile-time allocated' memory buffers are
- * fixed-size 4k pages. (or larger if used with an increment
- * highger than 1) use fixmap_set(idx,phys) to associate
+ * These 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages (or larger if used with an increment
+ * higher than 1). Use set_fixmap(idx,phys) to associate
  * physical memory with fixmap indices.
  *
  * TLB entries of such buffers will not be flushed across
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-hid.patch
adbhid-produce-all-capslock-key-events.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-ipwireless_cs.patch
