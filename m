From: akpm@linux-foundation.org
Subject: [merged] dio-fix-a-wrong-comment.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:10:24 -0700
Message-ID: <201110282210.p9SMAOpx017053@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1J1WKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: fix a wrong comment
has been removed from the -mm tree.  Its filename was
     dio-fix-a-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: fix a wrong comment

There's nothing on the stack, even before my changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/direct-io.c~dio-fix-a-wrong-comment fs/direct-io.c
--- a/fs/direct-io.c~dio-fix-a-wrong-comment
+++ a/fs/direct-io.c
@@ -39,7 +39,7 @@
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
- * the size of a structure on the stack.
+ * the size of a structure in the slab cache
  */
 #define DIO_PAGES	64
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
brlocks-lglocks-clean-up-code.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

