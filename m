From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:01:07 -0800
Message-ID: <52e2b873.P5SFXytIdhfMX/tv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:07 -0800


The patch titled
     Subject: MAINTAINERS: remove unnecessary EXYNOS DP DRIVER F: pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unnecessary-exynos-dp-driver-f-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: MAINTAINERS: remove unnecessary EXYNOS DP DRIVER F: pattern

Remove unnecessary pattern for Exynos DP header from MAINTAINERS file. 
After f9b1e01 ("video: exynos_dp: remove non-DT support for Exynos Display
Port"), 'exynos_dp.h' has not been used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unnecessary-exynos-dp-driver-f-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unnecessary-exynos-dp-driver-f-pattern
+++ a/MAINTAINERS
@@ -3349,7 +3349,6 @@ M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/exynos/exynos_dp*
-F:	include/video/exynos_dp*
 
 EXYNOS MIPI DISPLAY DRIVERS
 M:	Inki Dae <inki.dae@samsung.com>
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

