From: akpm@linux-foundation.org
Subject: + fix-typo-in-prefetchh.patch added to -mm tree
Date: Wed, 06 Jun 2007 18:43:56 -0700
Message-ID: <200706070143.l571huhe018067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935132AbXFGBoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 21:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com


The patch titled
     fix typo in prefetch.h
has been added to the -mm tree.  Its filename is
     fix-typo-in-prefetchh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix typo in prefetch.h
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prefetch.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/prefetch.h~fix-typo-in-prefetchh include/linux/prefetch.h
--- a/include/linux/prefetch.h~fix-typo-in-prefetchh
+++ a/include/linux/prefetch.h
@@ -27,7 +27,7 @@
 	
 	prefetch(x)  	- prefetches the cacheline at "x" for read
 	prefetchw(x)	- prefetches the cacheline at "x" for write
-	spin_lock_prefetch(x) - prefectches the spinlock *x for taking
+	spin_lock_prefetch(x) - prefetches the spinlock *x for taking
 	
 	there is also PREFETCH_STRIDE which is the architecure-prefered 
 	"lookahead" size for prefetching streamed operations.
_

Patches currently in -mm which might be from davej@redhat.com are

document-acked-by.patch
yet-another-uniwill-laptop-with-alc861-codec.patch
git-cpufreq.patch
i386-remove-support-for-the-rise-cpu.patch
fix-up-codingstyle-in-isofs.patch
undeprecate-raw-driver.patch
fix-typo-in-prefetchh.patch
