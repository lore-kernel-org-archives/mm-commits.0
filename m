From: akpm@linux-foundation.org
Subject: + x86_64-fix-wrong-comment-regarding-set_fixmap.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:53:38 -0700
Message-ID: <200707052053.l65KrcMj018725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762777AbXGEUxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, ak@suse.de


The patch titled
     x86_64: fix wrong comment regarding set_fixmap()
has been added to the -mm tree.  Its filename is
     x86_64-fix-wrong-comment-regarding-set_fixmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-hid.patch
irtouchsystems-support-for-usbtouchscreen.patch
git-ipwireless_cs.patch
x86_64-fix-wrong-comment-regarding-set_fixmap.patch
pie-randomization.patch
kernel-printkc-document-possible-deadlock-against-scheduler.patch
