From: akpm@linux-foundation.org
Subject: + maintainers-add-atmel-nand-driver-maintainer-entry.patch added
 to -mm tree
Date: Wed, 01 Oct 2014 14:51:37 -0700
Message-ID: <542c7769.nX8cxOWVJeiHnwwk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaJAVvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh.wu@atmel.com, greg@kroah.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add atmel nand driver maintainer entry
has been added to the -mm tree.  Its filename is
     maintainers-add-atmel-nand-driver-maintainer-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-atmel-nand-driver-maintainer-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-atmel-nand-driver-maintainer-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Wu <josh.wu@atmel.com>
Subject: MAINTAINERS: add atmel nand driver maintainer entry

Add an entry in MAINTAINERS file for ATMEL nand driver.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-atmel-nand-driver-maintainer-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-add-atmel-nand-driver-maintainer-entry
+++ a/MAINTAINERS
@@ -1698,6 +1698,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.co
 S:	Supported
 F:	drivers/net/ethernet/cadence/
 
+ATMEL NAND DRIVER
+M:	Josh Wu <josh.wu@atmel.com>
+L:	linux-mtd@lists.infradead.org
+S:	Supported
+F:	drivers/mtd/nand/atmel_nand*
+
 ATMEL SPI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
_

Patches currently in -mm which might be from josh.wu@atmel.com are

maintainers-add-atmel-nand-driver-maintainer-entry.patch
linux-next.patch

