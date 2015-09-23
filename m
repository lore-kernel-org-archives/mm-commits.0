From: akpm@linux-foundation.org
Subject: + zsmalloc-add-comments-for-inuse-to-zspage.patch added to -mm
 tree
Date: Wed, 23 Sep 2015 14:53:10 -0700
Message-ID: <56031f46.Sso3v1Nk/xNfu2xv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbbIWVxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 17:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: add comments for ->inuse to zspage
has been added to the -mm tree.  Its filename is
     zsmalloc-add-comments-for-inuse-to-zspage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-add-comments-for-inuse-to-zspage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-add-comments-for-inuse-to-zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: zsmalloc: add comments for ->inuse to zspage

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-comments-for-inuse-to-zspage
+++ a/mm/zsmalloc.c
@@ -38,6 +38,7 @@
  *	page->lru: links together first pages of various zspages.
  *		Basically forming list of zspages in a fullness group.
  *	page->mapping: class index and fullness group of the zspage
+ *	page->inuse: the pages number that is used in this zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are

zsmalloc-add-comments-for-inuse-to-zspage.patch

