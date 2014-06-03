From: akpm@linux-foundation.org
Subject: + rtc-rtc-sa1100-make-of_device_id-array-const.patch added to -mm tree
Date: Tue, 03 Jun 2014 14:39:29 -0700
Message-ID: <538e4091.KVUbXljU2m26sY9B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076AbaFCVja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2014 17:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-sa1100-make-of_device_id-array-const.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 03 Jun 2014 14:39:29 -0700


The patch titled
     Subject: drivers/rtc/rtc-sa1100.c: make of_device_id array const
has been added to the -mm tree.  Its filename is
     rtc-rtc-sa1100-make-of_device_id-array-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-sa1100-make-of_device_id-array-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-sa1100-make-of_device_id-array-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-m41t80-remove-drv_version-macro.patch
rtc-m41t80-clean-up-error-paths.patch
rtc-m41t80-propagate-error-value-from-smbus-functions.patch
rtc-m41t80-add-support-for-microcrystal-rv4162.patch
drivers-rtc-rtc-88pm860xc-use-of_get_child_by_name.patch
drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch
rtc-rtc-ds1742-make-of_device_id-array-const.patch
rtc-rtc-hym8563-make-of_device_id-array-const.patch
rtc-isl12057-make-of_device_id-array-const.patch
rtc-rtc-mv-make-of_device_id-array-const.patch
rtc-rtc-palmas-make-of_device_id-array-const.patch
drivers-rtc-add-support-for-maxim-dallas-rtc-ds1343-and-ds1344.patch
drivers-rtc-add-support-for-microchip-mcp795.patch
rtc-rtc-sa1100-make-of_device_id-array-const.patch
rtc-rtc-pxa-make-of_device_id-array-const.patch
linux-next.patch

