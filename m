From: akpm@linux-foundation.org
Subject: [merged] mm-kconfig-fix-url-for-zsmalloc-benchmark.patch removed
 from -mm tree
Date: Tue, 11 Mar 2014 11:25:06 -0700
Message-ID: <531f5502.zi8FiZJV43rzmuH5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaCKSZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, ben@decadent.org.uk

Subject: [merged] mm-kconfig-fix-url-for-zsmalloc-benchmark.patch removed from -mm tree
To: ben@decadent.org.uk,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:06 -0700


The patch titled
     Subject: mm/Kconfig: fix URL for zsmalloc benchmark
has been removed from the -mm tree.  Its filename was
     mm-kconfig-fix-url-for-zsmalloc-benchmark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: mm/Kconfig: fix URL for zsmalloc benchmark

The help text for CONFIG_PGTABLE_MAPPING has an incorrect URL.
While we're at it, remove the unnecessary footnote notation.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~mm-kconfig-fix-url-for-zsmalloc-benchmark mm/Kconfig
--- a/mm/Kconfig~mm-kconfig-fix-url-for-zsmalloc-benchmark
+++ a/mm/Kconfig
@@ -575,5 +575,5 @@ config PGTABLE_MAPPING
 	  then you should select this. This causes zsmalloc to use page table
 	  mapping rather than copying for object mapping.
 
-	  You can check speed with zsmalloc benchmark[1].
-	  [1] https://github.com/spartacus06/zsmalloc
+	  You can check speed with zsmalloc benchmark:
+	  https://github.com/spartacus06/zsmapbench
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch

