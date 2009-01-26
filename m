From: akpm@linux-foundation.org
Subject: + mfd-pcf50633-terminate-i2c_device_id-list.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:45:48 -0800
Message-ID: <200901262145.n0QLjmHZ031339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZAZVrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, balajirrao@openmoko.org, sameo@openedhand.com


The patch titled
     mfd/pcf50633: terminate i2c_device_id list
has been added to the -mm tree.  Its filename is
     mfd-pcf50633-terminate-i2c_device_id-list.patch

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
@@ -678,6 +678,7 @@ static int __devexit pcf50633_remove(str
 
 static struct i2c_device_id pcf50633_id_table[] = {
 	{"pcf50633", 0x73},
+	{/* end of list */}
 };
 
 static struct i2c_driver pcf50633_driver = {
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
i2c-fix-i2c-mpc-driver-for-multi-master-i2c-busses.patch
mfd-pcf50633-terminate-i2c_device_id-list.patch

