From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-zswap-zbud-change-maintainer-email-address.patch removed from
 -mm tree
Date: Wed, 07 May 2014 12:05:05 -0700
Message-ID: <536a83e1.XpMFdZ+rfOohwl66%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaEGTFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net

Subject: [merged] maintainers-zswap-zbud-change-maintainer-email-address.patch removed from -mm tree
To: sjennings@variantweb.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:05 -0700


The patch titled
     Subject: MAINTAINERS: zswap/zbud: change maintainer email address
has been removed from the -mm tree.  Its filename was
     maintainers-zswap-zbud-change-maintainer-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Seth Jennings <sjennings@variantweb.net>
Subject: MAINTAINERS: zswap/zbud: change maintainer email address

sjenning@linux.vnet.ibm.com is no longer a viable entity.

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-zswap-zbud-change-maintainer-email-address MAINTAINERS
--- a/MAINTAINERS~maintainers-zswap-zbud-change-maintainer-email-address
+++ a/MAINTAINERS
@@ -9959,7 +9959,7 @@ F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
 ZBUD COMPRESSED PAGE ALLOCATOR
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zbud.c
@@ -10004,7 +10004,7 @@ F:	mm/zsmalloc.c
 F:	include/linux/zsmalloc.h
 
 ZSWAP COMPRESSED SWAP CACHING
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
_

Patches currently in -mm which might be from sjennings@variantweb.net are

origin.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch

