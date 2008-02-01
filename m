From: akpm@linux-foundation.org
Subject: - hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:24 -0800
Message-ID: <200802012229.m11MTOln001804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbYBAWo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@linuxrealtime.co.uk, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon-new-chip-driver-for-ti-ads7828-a-d update 2
has been removed from the -mm tree.  Its filename was
     hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hwmon.patch
