From: akpm@linux-foundation.org
Subject: [merged] rtc-isl12057-make-of_device_id-array-const.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:32 -0700
Message-ID: <53960b1c.1+37sXOrrJTy5dEf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFIT3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-isl12057-make-of_device_id-array-const.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:32 -0700


The patch titled
     Subject: rtc: isl12057: make of_device_id array const
has been removed from the -mm tree.  Its filename was
     rtc-isl12057-make-of_device_id-array-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: isl12057: make of_device_id array const

Make of_device_id array const, because all OF functions handle it as
const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-isl12057-make-of_device_id-array-const drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-isl12057-make-of_device_id-array-const
+++ a/drivers/rtc/rtc-isl12057.c
@@ -278,7 +278,7 @@ static int isl12057_probe(struct i2c_cli
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id isl12057_dt_match[] = {
+static const struct of_device_id isl12057_dt_match[] = {
 	{ .compatible = "isl,isl12057" },
 	{ },
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

