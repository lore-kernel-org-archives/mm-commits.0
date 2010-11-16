From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:51 -0800
Message-ID: <201011161934.oAGJY3Gb003167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab0KPTeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/s6e63m0.c: set permissions on gamma_table file to 0444
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/s6e63m0.c: set permissions on gamma_table file to 0444
From: Axel Lin <axel.lin@gmail.com>

gamma_table is not writable, so set permissions to 0444.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444 drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444
+++ a/drivers/video/backlight/s6e63m0.c
@@ -729,7 +729,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_
 
 	return strlen(buf);
 }
-static DEVICE_ATTR(gamma_table, 0644,
+static DEVICE_ATTR(gamma_table, 0444,
 		s6e63m0_sysfs_show_gamma_table, NULL);
 
 static int __init s6e63m0_probe(struct spi_device *spi)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

