From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:04 -0700
Message-ID: <5390ca28.N4gk8yOniGvgWSMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaFETvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shhuiw@gmail.com

Subject: [merged] include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch removed from -mm tree
To: shhuiw@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:04 -0700


The patch titled
     Subject: include/linux/bootmem.h: cleanup the comment for BOOTMEM_ flags
has been removed from the -mm tree.  Its filename was
     include-linux-bootmemh-cleanup-the-comment-for-bootmem_-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

