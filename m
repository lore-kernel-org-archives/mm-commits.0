From: akpm@linux-foundation.org
Subject: - gpio-pca953x-driver-handles-pca9554-too.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:28 -0700
Message-ID: <200805270727.m4R7RSUC014770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284AbYE0Hef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x driver handles pca9554 too
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-driver-handles-pca9554-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
gpio-sysfs-interface.patch

