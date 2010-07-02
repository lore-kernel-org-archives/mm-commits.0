From: akpm@linux-foundation.org
Subject: + hwmon-update-maintainers-for-smm665-driver.patch added to -mm tree
Date: Fri, 02 Jul 2010 15:21:42 -0700
Message-ID: <201007022221.o62MLgVu030152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab0GBWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 18:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guenter.roeck@ericsson.com, broonie@opensource.wolfsonmicro.com, hdegoede@redhat.com, khali@linux-fr.org, sameo@linux.intel.com


The patch titled
     hwmon: update MAINTAINERS for smm665 driver
has been added to the -mm tree.  Its filename is
     hwmon-update-maintainers-for-smm665-driver.patch

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
Subject: hwmon: update MAINTAINERS for smm665 driver
From: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~hwmon-update-maintainers-for-smm665-driver MAINTAINERS
--- a/MAINTAINERS~hwmon-update-maintainers-for-smm665-driver
+++ a/MAINTAINERS
@@ -5254,6 +5254,13 @@ S:	Supported
 F:	Documentation/hwmon/emc2103
 F:	drivers/hwmon/emc2103.c
 
+SMM665 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/smm665
+F:	drivers/hwmon/smm665.c
+
 SMSC47B397 HARDWARE MONITOR DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	lm-sensors@lm-sensors.org
_

Patches currently in -mm which might be from guenter.roeck@ericsson.com are

linux-next.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch
hwmon-update-maintainers-for-smm665-driver.patch

