From: akpm@linux-foundation.org
Subject: + dio-fix-a-wrong-comment.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:47:33 -0700
Message-ID: <201108302347.p7UNlXKe026207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1H3XsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: fix a wrong comment
has been added to the -mm tree.  Its filename is
     dio-fix-a-wrong-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: fix a wrong comment
From: Andi Kleen <ak@linux.intel.com>

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

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch

