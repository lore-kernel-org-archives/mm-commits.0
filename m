From: akpm@linux-foundation.org
Subject: + mm-page_allocc-remove-unused-marco-long_align.patch added to
 -mm tree
Date: Mon, 07 Oct 2013 16:54:37 -0700
Message-ID: <525349bd.SJLT0reqa6srzXPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3JGXyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-page_allocc-remove-unused-marco-long_align.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:54:37 -0700


The patch titled
     Subject: mm/page_alloc.c: remove unused marco LONG_ALIGN
has been added to the -mm tree.  Its filename is
     mm-page_allocc-remove-unused-marco-long_align.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-remove-unused-marco-long_align.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-remove-unused-marco-long_align.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/page_alloc.c: remove unused marco LONG_ALIGN

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-remove-unused-marco-long_align mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-remove-unused-marco-long_align
+++ a/mm/page_alloc.c
@@ -3881,8 +3881,6 @@ static inline unsigned long wait_table_b
 	return ffz(~size);
 }
 
-#define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
