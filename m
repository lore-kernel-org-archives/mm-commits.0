From: akpm@linux-foundation.org
Subject: [merged] spi-fix-spelling-of-automatically-in-documentation.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:14 -0700
Message-ID: <200909231958.n8NJwEAI008541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbZIWT6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix spelling of `automatically' in documentation
has been removed from the -mm tree.  Its filename was
     spi-fix-spelling-of-automatically-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix spelling of `automatically' in documentation
From: Ben Dooks <ben@simtec.co.uk>

Fix spelling of `automatically' in Documentation/spi/spi-summary.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-fix-spelling-of-automatically-in-documentation Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-fix-spelling-of-automatically-in-documentation
+++ a/Documentation/spi/spi-summary
@@ -350,7 +350,7 @@ SPI protocol drivers somewhat resemble p
 		.resume		= CHIP_resume,
 	};
 
-The driver core will autmatically attempt to bind this driver to any SPI
+The driver core will automatically attempt to bind this driver to any SPI
 device whose board_info gave a modalias of "CHIP".  Your probe() code
 might look like this unless you're creating a device which is managing
 a bus (appearing under /sys/class/spi_master).
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

