From: akpm@linux-foundation.org
Subject: + drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch added to -mm tree
Date: Wed, 11 Mar 2009 15:18:31 -0700
Message-ID: <200903112218.n2BMIVKZ010511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbZCKWVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 18:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, jic23@cam.ac.uk, khali@linux-fr.org


The patch titled
     drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor fix
has been added to the -mm tree.  Its filename is
     drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-w1-masters-w1-gpioc-fix-read_bit.patch
ds2760_batteryc-fix-division-by-zero.patch
linux-next.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch
w1-coding-style-cleanups-in-w1_ioc.patch

