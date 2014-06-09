From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mv-make-of_device_id-array-const.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:29:37 -0700
Message-ID: <53960b21.57ddoOMwIHssaNMP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFIT3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-mv-make-of_device_id-array-const.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:37 -0700


The patch titled
     Subject: rtc: rtc-mv: make of_device_id array const
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mv-make-of_device_id-array-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mv: make of_device_id array const

Make of_device_id array const, because all OF functions handle it as
const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mv.c~rtc-rtc-mv-make-of_device_id-array-const drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-rtc-mv-make-of_device_id-array-const
+++ a/drivers/rtc/rtc-mv.c
@@ -319,7 +319,7 @@ static int __exit mv_rtc_remove(struct p
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id rtc_mv_of_match_table[] = {
+static const struct of_device_id rtc_mv_of_match_table[] = {
 	{ .compatible = "marvell,orion-rtc", },
 	{}
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

