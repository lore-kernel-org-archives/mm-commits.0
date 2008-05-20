From: akpm@linux-foundation.org
Subject: + gpio-pca953x-driver-handles-pca9554-too.patch added to -mm tree
Date: Tue, 20 May 2008 00:18:39 -0700
Message-ID: <200805200718.m4K7IdYM010602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYETHSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpio: pca953x driver handles pca9554 too
has been added to the -mm tree.  Its filename is
     gpio-pca953x-driver-handles-pca9554-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x driver handles pca9554 too
From: David Brownell <david-b@pacbell.net>

Teach drivers/gpio/pca953x.c about PCA9554, another compatible chip.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-driver-handles-pca9554-too drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-driver-handles-pca9554-too
+++ a/drivers/gpio/pca953x.c
@@ -30,6 +30,7 @@ static const struct i2c_device_id pca953
 	{ "pca9537", 4, },
 	{ "pca9538", 8, },
 	{ "pca9539", 16, },
+	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
 	/* REVISIT several pca955x parts should work here too */
_

Patches currently in -mm which might be from david-b@pacbell.net are

linux-next.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
rndis_host-increase-delay-in-command-response-loop.patch
net-usb-add-support-for-apple-usb-ethernet-adapter.patch
rndis-switch-to-seq_files.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-file-storagec-use-unaligned-access-helpers.patch
gpio-pca953x-driver-handles-pca9554-too.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-m41t80-century-bit-support.patch
gpio-sysfs-interface.patch

