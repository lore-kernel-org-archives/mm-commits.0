From: akpm@linux-foundation.org
Subject: + spi-fix-spelling-of-automatically-in-documentation.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:28:40 -0700
Message-ID: <200908132128.n7DLSeAe009609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbZHMV2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net


The patch titled
     spi: fix spelling of `automatically' in documentation
has been added to the -mm tree.  Its filename is
     spi-fix-spelling-of-automatically-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
spi-fix-spelling-of-automatically-in-documentation.patch
spi_s3c24xx-fix-clock-rate-calculation.patch
spi_s3c24xx-fix-transfer-setup-code.patch
spi_s3c24xx-fix-header-includes.patch
spi_s3c24xx-use-resource_size-to-get-resource-size.patch
spi_s3c24xx-use-dev_pm_ops.patch
spi_s3c24xx-cache-device-setup-data.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch

