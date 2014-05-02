From: akpm@linux-foundation.org
Subject: + maintainers-zswap-zbud-change-maintainer-email-address.patch
 added to -mm tree
Date: Fri, 02 May 2014 15:54:41 -0700
Message-ID: <53642231.DS4ZfVgrAbl/C+lm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEBWyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net

Subject: + maintainers-zswap-zbud-change-maintainer-email-address.patch added to -mm tree
To: sjennings@variantweb.net
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:54:41 -0700


The patch titled
     Subject: MAINTAINERS: zswap/zbud: change maintainer email address
has been added to the -mm tree.  Its filename is
     maintainers-zswap-zbud-change-maintainer-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-zswap-zbud-change-maintainer-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-zswap-zbud-change-maintainer-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -9958,7 +9958,7 @@ F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
 ZBUD COMPRESSED PAGE ALLOCATOR
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zbud.c
@@ -10003,7 +10003,7 @@ F:	mm/zsmalloc.c
 F:	include/linux/zsmalloc.h
 
 ZSWAP COMPRESSED SWAP CACHING
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
_

Patches currently in -mm which might be from sjennings@variantweb.net are

maintainers-zswap-zbud-change-maintainer-email-address.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch

