From: akpm@linux-foundation.org
Subject: + gpio-pca953x-add-support-for-pca9556.patch added to -mm tree
Date: Thu, 11 Jun 2009 15:29:31 -0700
Message-ID: <200906112229.n5BMTVo7007937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758974AbZFKWaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 18:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ncase@xes-inc.com, david-b@pacbell.net


The patch titled
     gpio: pca953x: Add support for PCA9556
has been added to the -mm tree.  Its filename is
     gpio-pca953x-add-support-for-pca9556.patch

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
Subject: gpio: pca953x: Add support for PCA9556
From: Nate Case <ncase@xes-inc.com>

PCA9556 is the software-compatible predecessor to the PCA9557, so add it
to the supported I2C device ID table.

Signed-off-by: Nate Case <ncase@xes-inc.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9556 drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9556
+++ a/drivers/gpio/pca953x.c
@@ -36,6 +36,7 @@ static const struct i2c_device_id pca953
 	{ "pca9539", 16, },
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
+	{ "pca9556", 8, },
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
_

Patches currently in -mm which might be from ncase@xes-inc.com are

gpio-pca953x-get-platform_data-from-openfirmware.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
gpio-pca953x-add-support-for-pca9556.patch

