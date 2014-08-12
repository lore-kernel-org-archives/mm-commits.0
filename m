From: akpm@linux-foundation.org
Subject: [merged] rtc-move-ds2404-entry-where-it-belongs.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:34 -0700
Message-ID: <53ea6d3a.nsiY6h/JZwowvSBh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:38773 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaHLTif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:35 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2665553pab.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, a.zummo@towertech.it, svens@stackframe.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/Kconfig: move DS2404 entry where it belongs
has been removed from the -mm tree.  Its filename was
     rtc-move-ds2404-entry-where-it-belongs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: drivers/rtc/Kconfig: move DS2404 entry where it belongs

Move the DS2404 entry together with the other Dallas entries, and add
Maxim so that it looks nicer (and more correct, too.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-move-ds2404-entry-where-it-belongs drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-move-ds2404-entry-where-it-belongs
+++ a/drivers/rtc/Kconfig
@@ -760,6 +760,15 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
+config RTC_DRV_DS2404
+	tristate "Maxim/Dallas DS2404"
+	help
+	  If you say yes here you get support for the
+	  Dallas DS2404 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds2404.
+
 config RTC_DRV_DA9052
 	tristate "Dialog DA9052/DA9053 RTC"
 	depends on PMIC_DA9052
@@ -873,15 +882,6 @@ config RTC_DRV_V3020
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-v3020.
 
-config RTC_DRV_DS2404
-	tristate "Dallas DS2404"
-	help
-	  If you say yes here you get support for the
-	  Dallas DS2404 RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds2404.
