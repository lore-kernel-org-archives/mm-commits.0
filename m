From: akpm@linux-foundation.org
Subject: + idr-remove-unused-prototype-of-idr_free.patch added to -mm tree
Date: Fri, 31 Jan 2014 13:55:56 -0800
Message-ID: <52ec1bec.jpHbz57uK04fB2ck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaAaVz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:55:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, vdavydov@parallels.com

Subject: + idr-remove-unused-prototype-of-idr_free.patch added to -mm tree
To: vdavydov@parallels.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:55:56 -0800


The patch titled
     Subject: idr: remove unused prototype of idr_free()
has been added to the -mm tree.  Its filename is
     idr-remove-unused-prototype-of-idr_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-remove-unused-prototype-of-idr_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-remove-unused-prototype-of-idr_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: idr: remove unused prototype of idr_free()

There is no such function. Remove the redundant prototype.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/idr.h~idr-remove-unused-prototype-of-idr_free include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-unused-prototype-of-idr_free
+++ a/include/linux/idr.h
@@ -82,7 +82,6 @@ int idr_for_each(struct idr *idp,
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
-void idr_free(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
idr-remove-unused-prototype-of-idr_free.patch
linux-next.patch

