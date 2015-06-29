From: akpm@linux-foundation.org
Subject: [merged] linux-slabh-fix-three-off-by-one-typos-in-comment.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:17 -0700
Message-ID: <5591ac7d.hqe70lKtQEDX+NVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbF2UhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/slab.h: fix three off-by-one typos in comment
has been removed from the -mm tree.  Its filename was
     linux-slabh-fix-three-off-by-one-typos-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: linux/slab.h: fix three off-by-one typos in comment

The first is a keyboard-off-by-one, the other two the ordinary mathy kind.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~linux-slabh-fix-three-off-by-one-typos-in-comment include/linux/slab.h
--- a/include/linux/slab.h~linux-slabh-fix-three-off-by-one-typos-in-comment
+++ a/include/linux/slab.h
@@ -262,8 +262,8 @@ extern struct kmem_cache *kmalloc_dma_ca
  * belongs to.
  * 0 = zero alloc
  * 1 =  65 .. 96 bytes
- * 2 = 120 .. 192 bytes
- * n = 2^(n-1) .. 2^n -1
+ * 2 = 129 .. 192 bytes
+ * n = 2^(n-1)+1 .. 2^n
  */
 static __always_inline int kmalloc_index(size_t size)
 {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

