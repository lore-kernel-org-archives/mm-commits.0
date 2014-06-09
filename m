From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sa1100-make-of_device_id-array-const.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:30:52 -0700
Message-ID: <53960b6c.2+VTgAS01LXKCMCq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaFITaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-sa1100-make-of_device_id-array-const.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:52 -0700


The patch titled
     Subject: drivers/rtc/rtc-sa1100.c: make of_device_id array const
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sa1100-make-of_device_id-array-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-sa1100.c: make of_device_id array const

Make of_device_id array const, because all OF functions handle
it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-make-of_device_id-array-const drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-rtc-sa1100-make-of_device_id-array-const
+++ a/drivers/rtc/rtc-sa1100.c
@@ -338,7 +338,7 @@ static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_o
 			sa1100_rtc_resume);
 
 #ifdef CONFIG_OF
-static struct of_device_id sa1100_rtc_dt_ids[] = {
+static const struct of_device_id sa1100_rtc_dt_ids[] = {
 	{ .compatible = "mrvl,sa1100-rtc", },
 	{ .compatible = "mrvl,mmp-rtc", },
 	{}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

