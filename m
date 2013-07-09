From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-zswap-and-zbud-maintainer.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:49 -0700
Message-ID: <51dc9a95.g+uNox9RFNmAOgkE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3GIXTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com

Subject: [merged] maintainers-add-zswap-and-zbud-maintainer.patch removed from -mm tree
To: sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:49 -0700


The patch titled
     Subject: MAINTAINERS: add zswap and zbud maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-zswap-and-zbud-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: MAINTAINERS: add zswap and zbud maintainer

Add maintainer information for zswap and zbud into the MAINTAINERS file.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN MAINTAINERS~maintainers-add-zswap-and-zbud-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-zswap-and-zbud-maintainer
+++ a/MAINTAINERS
@@ -9263,6 +9263,13 @@ F:	Documentation/networking/z8530drv.txt
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
+ZBUD COMPRESSED PAGE ALLOCATOR
+M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zbud.c
+F:	include/linux/zbud.h
+
 ZD1211RW WIRELESS DRIVER
 M:	Daniel Drake <dsd@gentoo.org>
 M:	Ulrich Kunitz <kune@deine-taler.de>
@@ -9285,6 +9292,12 @@ M:	"Maciej W. Rozycki" <macro@linux-mips
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
+ZSWAP COMPRESSED SWAP CACHING
+M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zswap.c
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zbud-add-to-mm-init-under_reclaim.patch
zswap-add-to-mm.patch
zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch
zswap-add-documentation.patch

