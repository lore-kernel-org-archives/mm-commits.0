From: akpm@linux-foundation.org
Subject: [merged] mm-memory-failurec-remove-the-useless-undefs.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:19 -0700
Message-ID: <56e9ba63.PCuXtTaqkICzmTVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124AbcCPT4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove useless "undef"s
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-remove-the-useless-undefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: mm/memory-failure.c: remove useless "undef"s

Remove the useless #undef, since the corresponding #define has already
been removed.

Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-remove-the-useless-undefs mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-remove-the-useless-undefs
+++ a/mm/memory-failure.c
@@ -826,8 +826,6 @@ static struct page_state {
 #undef lru
 #undef swapbacked
 #undef head
-#undef tail
-#undef compound
 #undef slab
 #undef reserved
 
_

Patches currently in -mm which might be from wangxq10@lzu.edu.cn are


