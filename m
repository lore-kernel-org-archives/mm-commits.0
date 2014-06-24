From: akpm@linux-foundation.org
Subject: [merged] slab-maintainer-update.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:19 -0700
Message-ID: <53a9cb3b.eBXz7nQjIjVXWHGz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXTCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, iamjoonsoo.kim@lge.com, mpm@selenic.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: SLAB maintainer update
has been removed from the -mm tree.  Its filename was
     slab-maintainer-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8195,13 +8195,15 @@ S:	Maintained
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

origin.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
linux-next.patch

