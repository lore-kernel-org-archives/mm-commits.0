From: akpm@linux-foundation.org
Subject: [merged] mm-zbud-fix-some-trivial-typos-in-comments.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:41 -0700
Message-ID: <5232196d.uKOrSwKXSnulUthS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3ILTnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, wujianguo@huawei.com

Subject: [merged] mm-zbud-fix-some-trivial-typos-in-comments.patch removed from -mm tree
To: wujianguo@huawei.com,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:41 -0700


The patch titled
     Subject: mm/zbud: fix some trivial typos in comments
has been removed from the -mm tree.  Its filename was
     mm-zbud-fix-some-trivial-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/zbud: fix some trivial typos in comments

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zbud.c~mm-zbud-fix-some-trivial-typos-in-comments mm/zbud.c
--- a/mm/zbud.c~mm-zbud-fix-some-trivial-typos-in-comments
+++ a/mm/zbud.c
@@ -16,7 +16,7 @@
  *
  * zbud works by storing compressed pages, or "zpages", together in pairs in a
  * single memory page called a "zbud page".  The first buddy is "left
- * justifed" at the beginning of the zbud page, and the last buddy is "right
+ * justified" at the beginning of the zbud page, and the last buddy is "right
  * justified" at the end of the zbud page.  The benefit is that if either
  * buddy is freed, the freed buddy space, coalesced with whatever slack space
  * that existed between the buddies, results in the largest possible free region
@@ -243,7 +243,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp should not set __GFP_HIGHMEM as highmem pages cannot be used
  * as zbud pool pages.
  *
- * Return: 0 if success and handle is set, otherwise -EINVAL is the size or
+ * Return: 0 if success and handle is set, otherwise -EINVAL if the size or
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch

