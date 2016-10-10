From: akpm@linux-foundation.org
Subject: [merged] mm-page_isolation-fix-typo-paes-pages.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:46:04 -0700
Message-ID: <57fc1a2c.aYwz8AjewUALLbwq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbcJJWqE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix typo: "paes" -> "pages"
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-fix-typo-paes-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/page_isolation: fix typo: "paes" -> "pages"

Fix typo in comment.

Link: http://lkml.kernel.org/r/1474788764-5774-1-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_isolation.c~mm-page_isolation-fix-typo-paes-pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-fix-typo-paes-pages
+++ a/mm/page_isolation.c
@@ -55,7 +55,7 @@ static int set_migratetype_isolate(struc
 		ret = 0;
 
 	/*
-	 * immobile means "not-on-lru" paes. If immobile is larger than
+	 * immobile means "not-on-lru" pages. If immobile is larger than
 	 * removable-by-driver pages reported by notifier, we'll fail.
 	 */
 
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are


