From: akpm@linux-foundation.org
Subject: +
 include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch added
 to -mm tree
Date: Wed, 30 Apr 2014 14:07:06 -0700
Message-ID: <536165fa.4wOWuWsRcNCI9iK/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946053AbaD3VHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shhuiw@gmail.com

Subject: + include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch added to -mm tree
To: shhuiw@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:07:06 -0700


The patch titled
     Subject: include/linux/bootmem.h: cleanup the comment for BOOTMEM_ flags
has been added to the -mm tree.  Its filename is
     include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: include/linux/bootmem.h: cleanup the comment for BOOTMEM_ flags

Use BOOTMEM_DEFAULT instead of 0 in the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags include/linux/bootmem.h
--- a/include/linux/bootmem.h~include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags
+++ a/include/linux/bootmem.h
@@ -58,9 +58,9 @@ extern void free_bootmem_late(unsigned l
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
  * the architecture-specific code should honor this).
  *
- * If flags is 0, then the return value is always 0 (success). If
- * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
- * memory already was reserved.
+ * If flags is BOOTMEM_DEFAULT, then the return value is always 0 (success).
+ * If flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the memory
+ * already was reserved.
  */
 #define BOOTMEM_DEFAULT		0
 #define BOOTMEM_EXCLUSIVE	(1<<0)
_

Patches currently in -mm which might be from shhuiw@gmail.com are

include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch

