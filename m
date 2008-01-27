From: akpm@linux-foundation.org
Subject: + hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:08:40 -0800
Message-ID: <200801270508.m0R58bMh030753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYA0FJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@linuxrealtime.co.uk, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     hwmon-new-chip-driver-for-ti-ads7828-a-d update 2
has been added to the -mm tree.  Its filename is
     hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-new-chip-driver-for-ti-ads7828-a-d update 2
From: Steve Hardy <steve@linuxrealtime.co.uk>

Fix minor final issues identified by Jean Delarve which I mis-interpreted
in the third revision

Signed-off-by: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/ads7828 |    4 ++--
 drivers/hwmon/ads7828.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/hwmon/ads7828~hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2 Documentation/hwmon/ads7828
--- a/Documentation/hwmon/ads7828~hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2
+++ a/Documentation/hwmon/ads7828
@@ -5,7 +5,7 @@ Supported chips:
   * Texas Instruments/Burr-Brown ADS7828
     Prefix: 'ads7828'
     Addresses scanned: I2C 0x48, 0x49, 0x4a, 0x4b
-    Datasheet : Publicly available at the Texas Instruments website :
+    Datasheet: Publicly available at the Texas Instruments website :
                http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
 Authors:
@@ -18,7 +18,7 @@ Module Parameters
   Single ended operation - set to N for differential mode
 * int_vref: bool (default Y)
   Operate with the internal 2.5V reference - set to N for external reference
-* vref_mV: int (default 2500)
+* vref_mv: int (default 2500)
   If using an external reference, set this to the reference voltage in mV
 
 Description
diff -puN drivers/hwmon/ads7828.c~hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2 drivers/hwmon/ads7828.c
--- a/drivers/hwmon/ads7828.c~hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2
+++ a/drivers/hwmon/ads7828.c
@@ -6,7 +6,7 @@
 
 	Written by Steve Hardy <steve@linuxrealtime.co.uk>
 
-	Datasheet available at : http://focus.ti.com/lit/ds/symlink/ads7828.pdf
+	Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
 	This program is free software; you can redistribute it and/or modify
 	it under the terms of the GNU General Public License as published by
_

Patches currently in -mm which might be from steve@linuxrealtime.co.uk are

hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch
