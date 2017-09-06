From: akpm@linux-foundation.org
Subject: [folded-merged]
 zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch removed from -mm tree
Date: Wed, 06 Sep 2017 16:03:29 -0700
Message-ID: <59b07ec1.tClP8L5ALjQq7jf5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdIFXDb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch

This patch was dropped because it was folded into zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix

remove newline, per Minchan

Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix
+++ a/mm/zsmalloc.c
@@ -2055,7 +2055,6 @@ unpin_objects:
 		}
 	}
 	kunmap_atomic(s_addr);
