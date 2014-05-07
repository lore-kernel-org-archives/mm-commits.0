From: akpm@linux-foundation.org
Subject: + rtc-isl12057-make-of_device_id-array-const.patch added to -mm
 tree
Date: Wed, 07 May 2014 13:16:46 -0700
Message-ID: <536a94ae.qe9d/taiJ4OfwplM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEGUQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 16:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-isl12057-make-of_device_id-array-const.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 13:16:46 -0700


The patch titled
     Subject: rtc: isl12057: make of_device_id array const
has been added to the -mm tree.  Its filename is
     rtc-isl12057-make-of_device_id-array-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-isl12057-make-of_device_id-array-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-isl12057-make-of_device_id-array-const.patch

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
linux-next.patch

