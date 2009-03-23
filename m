From: akpm@linux-foundation.org
Subject: + hp_accel-add-two-more-axis-information.patch added to -mm tree
Date: Sun, 22 Mar 2009 17:12:38 -0700
Message-ID: <200903230016.n2N0Gtus024896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbZCWAUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 20:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, daniel@caiaq.de, eric.piel@tremplin-utc.net, mmarek@suse.cz, vbotka@suse.cz


The patch titled
     hp_accel: add two more axis information
has been added to the -mm tree.  Its filename is
     hp_accel-add-two-more-axis-information.patch

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
Subject: hp_accel: add two more axis information
From: Pavel Machek <pavel@ucw.cz>

Add two more laptops to whitelist.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Vladimir Botka <vbotka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-add-two-more-axis-information drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-add-two-more-axis-information
+++ a/drivers/hwmon/hp_accel.c
@@ -187,6 +187,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
 	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
 	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
 	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
@@ -201,6 +202,7 @@ static struct dmi_system_id lis3lv02d_dm
 			PRODUCT_NAME, "HP Pavilion dv5",
 			BOARD_NAME, "3600",
 			y_inverted),
+	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
hp_accel-small-documentation-updates.patch
hp_accel-adev-is-poor-name-of-exported-symbol.patch
hp_accel-add-two-more-axis-information.patch

