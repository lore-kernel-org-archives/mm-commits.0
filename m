From: akpm@linux-foundation.org
Subject: - spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:44 -0800
Message-ID: <200702122244.l1CMiiOG013630@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030269AbXBLWox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: documentation does not need to set driver's bus_type field
has been removed from the -mm tree.  Its filename was
     spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: documentation does not need to set driver's bus_type field
From: Ben Dooks <ben@fluff.org>

The spi_register_driver() sets the bus_type field of the spi_driver being
registered, so there is no need to have it set in the driver itself.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-documentation-does-not-need-to-set-drivers-bus_type-field Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-documentation-does-not-need-to-set-drivers-bus_type-field
+++ a/Documentation/spi/spi-summary
@@ -284,7 +284,6 @@ SPI protocol drivers somewhat resemble p
 	static struct spi_driver CHIP_driver = {
 		.driver = {
 			.name		= "CHIP",
-			.bus		= &spi_bus_type,
 			.owner		= THIS_MODULE,
 		},
 
_

Patches currently in -mm which might be from ben@fluff.org are

origin.patch
