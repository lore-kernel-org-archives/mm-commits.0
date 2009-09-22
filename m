From: akpm@linux-foundation.org
Subject: [folded] gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:49:16 -0700
Message-ID: <200909222149.n8MLnG9W012076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbZIVVty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-jani.1.nikula@nokia.com, david-b@pacbell.net, dsilvers@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
has been removed from the -mm tree.  Its filename was
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update.patch

This patch was dropped because it was folded into gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update
+++ a/drivers/gpio/gpiolib.c
@@ -520,9 +520,6 @@ int gpio_export_link(struct device *dev,
 	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 
-	BUG_ON(dev == NULL);
-	BUG_ON(name == NULL);
