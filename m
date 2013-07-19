From: akpm@linux-foundation.org
Subject: + lib-genallocc-correct-dev_get_gen_pool-documentation.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 14:43:18 -0700
Message-ID: <51e9b2f6.xEs6ffZm9f3O9GRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3GSVnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 17:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, emilio@elopez.com.ar

Subject: + lib-genallocc-correct-dev_get_gen_pool-documentation.patch added to -mm tree
To: emilio@elopez.com.ar
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 14:43:18 -0700


The patch titled
     Subject: lib/genalloc.c: correct dev_get_gen_pool documentation
has been added to the -mm tree.  Its filename is
     lib-genallocc-correct-dev_get_gen_pool-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-correct-dev_get_gen_pool-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-correct-dev_get_gen_pool-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Emilio López <emilio@elopez.com.ar>
Subject: lib/genalloc.c: correct dev_get_gen_pool documentation

The documentation mentions a "name" parameter, which does not exist.  This
commit removes such mention from the function documentation.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-correct-dev_get_gen_pool-documentation lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-correct-dev_get_gen_pool-documentation
+++ a/lib/genalloc.c
@@ -519,7 +519,6 @@ struct gen_pool *devm_gen_pool_create(st
 /**
  * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
  * @dev: device to retrieve the gen_pool from
- * @name: Optional name for the gen_pool, usually NULL
  *
  * Returns the gen_pool for the device if one is present, or NULL.
  */
_

Patches currently in -mm which might be from emilio@elopez.com.ar are

lib-genallocc-correct-dev_get_gen_pool-documentation.patch

