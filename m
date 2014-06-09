From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1742-make-of_device_id-array-const.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:22 -0700
Message-ID: <53960b12.JjQCEYzuREoor4Es%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaFIT3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-ds1742-make-of_device_id-array-const.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:22 -0700


The patch titled
     Subject: rtc: rtc-ds1742: make of_device_id array const
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1742-make-of_device_id-array-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1742: make of_device_id array const

Make of_device_id array const, because all OF functions handle it as
const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-make-of_device_id-array-const drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-make-of_device_id-array-const
+++ a/drivers/rtc/rtc-ds1742.c
@@ -219,7 +219,7 @@ static int ds1742_rtc_remove(struct plat
 	return 0;
 }
 
-static struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
+static const struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
 	{ .compatible = "maxim,ds1742", },
 	{ }
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

