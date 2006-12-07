From: akpm@osdl.org
Subject: - maintainers-update-the-i2c-and-hwmon-subsystems-info.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:08 -0800
Message-ID: <200612072315.kB7NF8xN030709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163888AbWLGXPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Update the i2c and hwmon subsystems info
has been removed from the -mm tree.  Its filename was
     maintainers-update-the-i2c-and-hwmon-subsystems-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: Update the i2c and hwmon subsystems info
From: Jean Delvare <khali@linux-fr.org>

The i2c and hwmon trees have moved to a new location.

The lm-sensors project moved to a new home as well.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-the-i2c-and-hwmon-subsystems-info MAINTAINERS
--- a/MAINTAINERS~maintainers-update-the-i2c-and-hwmon-subsystems-info
+++ a/MAINTAINERS
@@ -1214,7 +1214,8 @@ HARDWARE MONITORING
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
-W:	http://www.lm-sensors.nu/
+W:	http://www.lm-sensors.org/
+T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-hwmon/
 S:	Maintained
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
@@ -1340,8 +1341,7 @@ I2C SUBSYSTEM
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
-W:	http://www.lm-sensors.nu/
-T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
 S:	Maintained
 
 I2O
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-alsa.patch
pci-fix-multiple-problems-with-via-hardware.patch

