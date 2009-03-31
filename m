From: akpm@linux-foundation.org
Subject: [folded] drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:03:44 -0700
Message-ID: <200903312203.n2VM3i1U016531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758511AbZCaWHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, jic23@cam.ac.uk, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor fix
has been removed from the -mm tree.  Its filename was
     drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch

This patch was dropped because it was folded into drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor fix
From: Daniel Mack <daniel@caiaq.de>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/Kconfig~drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix
+++ a/drivers/misc/Kconfig
@@ -225,7 +225,7 @@ config DELL_LAPTOP
 
 config ISL29003
 	tristate "Intersil ISL29003 ambient light sensor"
-	depends on I2C
+	depends on I2C && SYSFS
 	help
 	  If you say yes here you get support for the Intersil ISL29003
 	  ambient light sensor.
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch
hp_accel-add-two-more-axis-information.patch
lis3-reorder-functions-to-make-forward-decl-obsolete.patch
lis3-solve-dependency-between-core-and-acpi.patch
lis3-spi-transport-layer.patch
linux-next.patch
w1-coding-style-cleanups-in-w1_ioc.patch

