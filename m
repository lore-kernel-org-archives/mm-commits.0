From: akpm@linux-foundation.org
Subject: [merged]
 include-asm-generic-bugh-style-fix-s-while0-while-0.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 14:34:57 -0700
Message-ID: <53446b81.UwS8dK7/hcBi+SkI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, arnd@arndb.de, josh@joshtriplett.org

Subject: [merged] include-asm-generic-bugh-style-fix-s-while0-while-0.patch removed from -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:34:57 -0700


The patch titled
     Subject: include/asm-generic/bug.h: style fix: s/while(0)/while (0)/
has been removed from the -mm tree.  Its filename was
     include-asm-generic-bugh-style-fix-s-while0-while-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: include/asm-generic/bug.h: style fix: s/while(0)/while (0)/

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/bug.h~include-asm-generic-bugh-style-fix-s-while0-while-0 include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~include-asm-generic-bugh-style-fix-s-while0-while-0
+++ a/include/asm-generic/bug.h
@@ -52,7 +52,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
 #endif
 
 /*
@@ -138,11 +138,11 @@ extern void warn_slowpath_null(const cha
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() do {} while (0)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (condition) ; } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

