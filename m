From: akpm@linux-foundation.org
Subject: - apple-smc-driver-hardware-monitoring-and-control-fix-names.patch removed from -mm tree
Date: Mon, 07 May 2007 21:48:26 -0700
Message-ID: <200705080448.l484mQwP013744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967755AbXEHEsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 00:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, dtor@mail.ru, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     Apple SMC driver: fix temperature attribute file names.
has been removed from the -mm tree.  Its filename was
     apple-smc-driver-hardware-monitoring-and-control-fix-names.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: Apple SMC driver: fix temperature attribute file names.
From: Jean Delvare <khali@linux-fr.org>

These attribute names don't follow the standard, there's an extra "_"
which shouldn't be there.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   48 ++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-fix-names drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~apple-smc-driver-hardware-monitoring-and-control-fix-names
+++ a/drivers/hwmon/applesmc.c
@@ -1010,44 +1010,44 @@ static const struct attribute_group fan_
 /*
  * Temperature sensors sysfs entries.
  */
-static SENSOR_DEVICE_ATTR(temp_1_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp_2_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp_3_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp_4_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp_5_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 4);
-static SENSOR_DEVICE_ATTR(temp_6_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 5);
-static SENSOR_DEVICE_ATTR(temp_7_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp7_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 6);
-static SENSOR_DEVICE_ATTR(temp_8_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 7);
-static SENSOR_DEVICE_ATTR(temp_9_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp9_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 8);
-static SENSOR_DEVICE_ATTR(temp_10_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp10_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 9);
-static SENSOR_DEVICE_ATTR(temp_11_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp11_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 10);
-static SENSOR_DEVICE_ATTR(temp_12_input, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp12_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 11);
 
 static struct attribute *temperature_attributes[] = {
-	&sensor_dev_attr_temp_1_input.dev_attr.attr,
-	&sensor_dev_attr_temp_2_input.dev_attr.attr,
-	&sensor_dev_attr_temp_3_input.dev_attr.attr,
-	&sensor_dev_attr_temp_4_input.dev_attr.attr,
-	&sensor_dev_attr_temp_5_input.dev_attr.attr,
-	&sensor_dev_attr_temp_6_input.dev_attr.attr,
-	&sensor_dev_attr_temp_7_input.dev_attr.attr,
-	&sensor_dev_attr_temp_8_input.dev_attr.attr,
-	&sensor_dev_attr_temp_9_input.dev_attr.attr,
-	&sensor_dev_attr_temp_10_input.dev_attr.attr,
-	&sensor_dev_attr_temp_11_input.dev_attr.attr,
-	&sensor_dev_attr_temp_12_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp4_input.dev_attr.attr,
+	&sensor_dev_attr_temp5_input.dev_attr.attr,
+	&sensor_dev_attr_temp6_input.dev_attr.attr,
+	&sensor_dev_attr_temp7_input.dev_attr.attr,
+	&sensor_dev_attr_temp8_input.dev_attr.attr,
+	&sensor_dev_attr_temp9_input.dev_attr.attr,
+	&sensor_dev_attr_temp10_input.dev_attr.attr,
+	&sensor_dev_attr_temp11_input.dev_attr.attr,
+	&sensor_dev_attr_temp12_input.dev_attr.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix-names.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
