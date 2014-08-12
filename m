From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:19 -0700
Message-ID: <53ea6e57.+GrNPIKr/PzFv2aV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:52455 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaHLTnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:20 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1307256qgd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hartleys@visionengravers.com, kernel@wantstofly.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
has been removed from the -mm tree.  Its filename was
     maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER

Commit e55f7cd24676 ("usb: ohci: remove ep93xx bus glue platform driver")
removed the file, remove the section.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver
+++ a/MAINTAINERS
@@ -2325,12 +2325,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/cirrus/ep93xx_eth.c
 
-CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
-M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-usb@vger.kernel.org
-S:	Maintained
-F:	drivers/usb/host/ohci-ep93xx.c
