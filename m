From: akpm@linux-foundation.org
Subject: + slab-maintainer-update.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:02:52 -0700
Message-ID: <53a0acfc.bG5QZJQ1EUVk1R5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965083AbaFQVCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:02:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mpm@selenic.com, iamjoonsoo.kim@lge.com, cl@linux.com, cl@gentwo.org


The patch titled
     Subject: MAINTAINERS: SLAB maintainer update
has been added to the -mm tree.  Its filename is
     slab-maintainer-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-maintainer-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-maintainer-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: MAINTAINERS: SLAB maintainer update

As discussed in various threads on the side:

Remove one inactive maintainer, add two new ones and update my email
address.  Plus add Andrew.  And fix the glob to include files like
mm/slab_common.c

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN CREDITS~slab-maintainer-update CREDITS
--- a/CREDITS~slab-maintainer-update
+++ a/CREDITS
@@ -9,6 +9,10 @@
 			Linus
 ----------
 
+M: Matt Mackal
+E: mpm@selenic.com
+D: SLOB slab allocator
+
 N: Matti Aarnio
 E: mea@nic.funet.fi
 D: Alpha systems hacking, IPv6 and other network related stuff
diff -puN MAINTAINERS~slab-maintainer-update MAINTAINERS
--- a/MAINTAINERS~slab-maintainer-update
+++ a/MAINTAINERS
@@ -8194,13 +8194,15 @@ S:	Maintained
 F:	drivers/usb/misc/sisusbvga/
 
 SLAB ALLOCATOR
-M:	Christoph Lameter <cl@linux-foundation.org>
+M:	Christoph Lameter <cl@linux.com>
 M:	Pekka Enberg <penberg@kernel.org>
-M:	Matt Mackall <mpm@selenic.com>
+M:	David Rientjes <rientjes@google.com>
+M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/sl?b*.h
-F:	mm/sl?b.c
+F:	mm/sl?b*
 
 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
_

Patches currently in -mm which might be from cl@gentwo.org are

slab-maintainer-update.patch
mm-let-mm_find_pmd-fix-buggy-race-with-thp-fault.patch

