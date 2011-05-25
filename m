From: akpm@linux-foundation.org
Subject: [merged] include-linux-genalloch-add-multiple-inclusion-guards.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:15 -0700
Message-ID: <201105252030.p4PKUcwo014982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab1EYUtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: plagnioj@jcrosoft.com, jes@wildopensource.com, nicolas.ferre@atmel.com, patrice.vilchez@atmel.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/genalloc.h: add multiple-inclusion guards
has been removed from the -mm tree.  Its filename was
     include-linux-genalloch-add-multiple-inclusion-guards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/genalloc.h: add multiple-inclusion guards
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Cc: Jes Sorensen <jes@wildopensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/genalloc.h~include-linux-genalloch-add-multiple-inclusion-guards include/linux/genalloc.h
--- a/include/linux/genalloc.h~include-linux-genalloch-add-multiple-inclusion-guards
+++ a/include/linux/genalloc.h
@@ -9,6 +9,8 @@
  */
 
 
+#ifndef __GENALLOC_H__
+#define __GENALLOC_H__
 /*
  *  General purpose special memory pool descriptor.
  */
@@ -34,3 +36,4 @@ extern int gen_pool_add(struct gen_pool 
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
+#endif /* __GENALLOC_H__ */
_

Patches currently in -mm which might be from plagnioj@jcrosoft.com are

origin.patch
linux-next.patch

