From: akpm@osdl.org
Subject: + spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:13:16 -0800
Message-ID: <200701240013.l0O0DGDH003402@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43111 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXAXANV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: documentation does not need to set driver's bus_type field
has been added to the -mm tree.  Its filename is
     spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: documentation does not need to set driver's bus_type field
From: Ben Dooks <ben@fluff.org>

The spi_register_driver() sets the bus_type field of the spi_driver being
registered, so there is no need to have it set in the driver itself.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/spi/spi-summary |    1 -
 1 files changed, 1 deletion(-)

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

spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
