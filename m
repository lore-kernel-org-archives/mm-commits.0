From: akpm@linux-foundation.org
Subject: + mm-fix-the-comment-in-zlc_setup.patch added to -mm tree
Date: Mon, 04 Nov 2013 13:42:14 -0800
Message-ID: <527814b6.7A7iV2s86PtPgADq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDVmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: + mm-fix-the-comment-in-zlc_setup.patch added to -mm tree
To: wuzhy@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:42:14 -0800


The patch titled
     Subject: mm/page_alloc.c: fix comment in zlc_setup()
has been added to the -mm tree.  Its filename is
     mm-fix-the-comment-in-zlc_setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-comment-in-zlc_setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-comment-in-zlc_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: fix comment in zlc_setup()

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-the-comment-in-zlc_setup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-the-comment-in-zlc_setup
+++ a/mm/page_alloc.c
@@ -1705,7 +1705,7 @@ bool zone_watermark_ok_safe(struct zone
  * comments in mmzone.h.  Reduces cache footprint of zonelist scans
  * that have to skip over a lot of full or unallowed zones.
  *
- * If the zonelist cache is present in the passed in zonelist, then
+ * If the zonelist cache is present in the passed zonelist, then
  * returns a pointer to the allowed node mask (either the current
  * tasks mems_allowed, or node_states[N_MEMORY].)
  *
_

Patches currently in -mm which might be from wuzhy@linux.vnet.ibm.com are

mm-fix-the-incorrect-function-name-in-alloc_low_pages.patch
mm-fix-the-comment-in-zlc_setup.patch
linux-next.patch

