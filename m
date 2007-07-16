From: akpm@linux-foundation.org
Subject: - fix-typo-in-prefetchh.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:15 -0700
Message-ID: <200707162056.l6GKuFhB002080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760662AbXGPVFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix typo in prefetch.h
has been removed from the -mm tree.  Its filename was
     fix-typo-in-prefetchh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
i386-remove-support-for-the-rise-cpu.patch
slow-down-printk-during-boot.patch
