From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-atmel-nand-driver-maintainer-entry.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:17 -0700
Message-ID: <543d6925.x8UexbyfCsVRCKLd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaJNSTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh.wu@atmel.com, greg@kroah.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add atmel nand driver maintainer entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-atmel-nand-driver-maintainer-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1738,6 +1738,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.co
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

origin.patch
linux-next.patch

