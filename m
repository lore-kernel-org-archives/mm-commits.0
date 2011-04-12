From: akpm@linux-foundation.org
Subject: + include-linux-genalloch-add-multiple-inclusion-guards.patch added to -mm tree
Date: Tue, 12 Apr 2011 15:38:06 -0700
Message-ID: <201104122238.p3CMc617006968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab1DLWil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 18:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: plagnioj@jcrosoft.com, jes@wildopensource.com, nicolas.ferre@atmel.com, patrice.vilchez@atmel.com


The patch titled
     include/linux/genalloc.h: add multiple-inclusion guards
has been added to the -mm tree.  Its filename is
     include-linux-genalloch-add-multiple-inclusion-guards.patch

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

linux-next.patch
bluetooth-fix-build-warnings-on-defconfigs.patch
include-linux-genalloch-add-multiple-inclusion-guards.patch
lib-genallocc-add-support-for-specifying-the-physical-address.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch

