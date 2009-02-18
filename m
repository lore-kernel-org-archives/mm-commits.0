From: akpm@linux-foundation.org
Subject: [merged] mfd-pcf50633-terminate-i2c_device_id-list.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:13:53 -0800
Message-ID: <200902181013.n1IADrnR005927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbZBRKOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, balajirrao@openmoko.org, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd/pcf50633: terminate i2c_device_id list
has been removed from the -mm tree.  Its filename was
     mfd-pcf50633-terminate-i2c_device_id-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/pcf50633: terminate i2c_device_id list
From: Jean Delvare <khali@linux-fr.org>

The i2c_device_id list is supposed to be zero-terminated.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/pcf50633-core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/pcf50633-core.c~mfd-pcf50633-terminate-i2c_device_id-list drivers/mfd/pcf50633-core.c
--- a/drivers/mfd/pcf50633-core.c~mfd-pcf50633-terminate-i2c_device_id-list
+++ a/drivers/mfd/pcf50633-core.c
@@ -677,6 +677,7 @@ static int __devexit pcf50633_remove(str
 
 static struct i2c_device_id pcf50633_id_table[] = {
 	{"pcf50633", 0x73},
+	{/* end of list */}
 };
 
 static struct i2c_driver pcf50633_driver = {
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
dmi-let-dmi_walk-users-pass-private-data.patch
rtc-ds1307-true-smbus-compatibility.patch

