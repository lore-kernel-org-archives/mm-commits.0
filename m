From: akpm@linux-foundation.org
Subject: + maintainers-add-zswap-and-zbud-maintainer.patch added to -mm
 tree
Date: Fri, 14 Jun 2013 12:50:53 -0700
Message-ID: <51bb741d.ZrStnR1+uI2z4ena%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3FNTuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jun 2013 15:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com

Subject: + maintainers-add-zswap-and-zbud-maintainer.patch added to -mm tree
To: sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 14 Jun 2013 12:50:53 -0700


The patch titled
     Subject: MAINTAINERS: add zswap and zbud maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-zswap-and-zbud-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -9204,6 +9204,13 @@ F:	Documentation/networking/z8530drv.txt
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
@@ -9226,6 +9233,12 @@ M:	"Maciej W. Rozycki" <macro@linux-mips
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

linux-next.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
zbud-add-to-mm.patch
zbud-add-to-mm-init-under_reclaim.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
maintainers-add-zswap-and-zbud-maintainer.patch

