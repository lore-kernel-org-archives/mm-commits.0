From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-cmos-remove-superfluous-name-cast.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:02:44 -0800
Message-ID: <52e2b8d4.ottJM+w8Ec+/fSxX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaAXTCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, geert@linux-m68k.org

Subject: [merged] rtc-rtc-cmos-remove-superfluous-name-cast.patch removed from -mm tree
To: geert@linux-m68k.org,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:44 -0800


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: remove superfluous name cast
has been removed from the -mm tree.  Its filename was
     rtc-rtc-cmos-remove-superfluous-name-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/rtc/rtc-cmos.c: remove superfluous name cast

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-remove-superfluous-name-cast drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-remove-superfluous-name-cast
+++ a/drivers/rtc/rtc-cmos.c
@@ -1175,7 +1175,7 @@ static struct platform_driver cmos_platf
 	.remove		= __exit_p(cmos_platform_remove),
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
-		.name		= (char *) driver_name,
+		.name		= driver_name,
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

