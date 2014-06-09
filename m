From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-hym8563-make-of_device_id-array-const.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:27 -0700
Message-ID: <53960b17.aCMvHhpYAz8Wz8RH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaFIT32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, heiko@sntech.de, jg1.han@samsung.com

Subject: [merged] rtc-rtc-hym8563-make-of_device_id-array-const.patch removed from -mm tree
To: jg1.han@samsung.com,heiko@sntech.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:27 -0700


The patch titled
     Subject: rtc: rtc-hym8563: make of_device_id array const
has been removed from the -mm tree.  Its filename was
     rtc-rtc-hym8563-make-of_device_id-array-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-hym8563: make of_device_id array const

Make of_device_id array const, because all OF functions handle it as
const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Heiko Stbner <heiko@sntech.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-hym8563.c~rtc-rtc-hym8563-make-of_device_id-array-const drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~rtc-rtc-hym8563-make-of_device_id-array-const
+++ a/drivers/rtc/rtc-hym8563.c
@@ -585,7 +585,7 @@ static const struct i2c_device_id hym856
 };
 MODULE_DEVICE_TABLE(i2c, hym8563_id);
 
-static struct of_device_id hym8563_dt_idtable[] = {
+static const struct of_device_id hym8563_dt_idtable[] = {
 	{ .compatible = "haoyu,hym8563" },
 	{},
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

