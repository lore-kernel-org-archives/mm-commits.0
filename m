From: akpm@linux-foundation.org
Subject: + mm-memoryc-fix-typo-in-comment.patch added to -mm tree
Date: Mon, 24 Sep 2012 17:10:10 -0700
Message-ID: <20120925001011.83CB95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:61865 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2IYAKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 20:10:13 -0400
Received: by eaak14 with SMTP id k14so108889eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 17:10:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     Subject: mm/memory.c: fix typo in comment
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: mm/memory.c: fix typo in comment

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-fix-typo-in-comment mm/memory.c
--- a/mm/memory.c~mm-memoryc-fix-typo-in-comment
+++ a/mm/memory.c
@@ -2148,7 +2148,7 @@ out:
  * @addr: target user address of this page
  * @pfn: source kernel pfn
  *
- * Similar to vm_inert_page, this allows drivers to insert individual pages
+ * Similar to vm_insert_page, this allows drivers to insert individual pages
  * they've allocated into a user vma. Same comments apply.
  *
  * This function should only be called from a vm_ops->fault handler, and
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
mm-memoryc-fix-typo-in-comment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch

