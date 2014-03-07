From: akpm@linux-foundation.org
Subject: + mm-kconfig-fix-url-for-zsmalloc-benchmark.patch added to -mm
 tree
Date: Fri, 07 Mar 2014 14:54:01 -0800
Message-ID: <531a4e09.uv3KGyZMSXbXfu9j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGWyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2014 17:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, ben@decadent.org.uk

Subject: + mm-kconfig-fix-url-for-zsmalloc-benchmark.patch added to -mm tree
To: ben@decadent.org.uk,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 14:54:01 -0800


The patch titled
     Subject: mm/Kconfig: fix URL for zsmalloc benchmark
has been added to the -mm tree.  Its filename is
     mm-kconfig-fix-url-for-zsmalloc-benchmark.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kconfig-fix-url-for-zsmalloc-benchmark.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kconfig-fix-url-for-zsmalloc-benchmark.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -576,5 +576,5 @@ config PGTABLE_MAPPING
 	  then you should select this. This causes zsmalloc to use page table
 	  mapping rather than copying for object mapping.
 
-	  You can check speed with zsmalloc benchmark[1].
-	  [1] https://github.com/spartacus06/zsmalloc
+	  You can check speed with zsmalloc benchmark:
+	  https://github.com/spartacus06/zsmapbench
_

Patches currently in -mm which might be from ben@decadent.org.uk are

mm-kconfig-fix-url-for-zsmalloc-benchmark.patch
linux-next.patch

