From: akpm@linux-foundation.org
Subject: [merged] lis3-fix-documentation-to-fit-into-80-columns.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:54 -0800
Message-ID: <200901161917.n0GJHsBs026453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936887AbZAPTSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, eric.piel@tremplin-utc.net, mm-commits@vger.kernel.org


The patch titled
     lis3: fix documentation to fit into 80 columns
has been removed from the -mm tree.  Its filename was
     lis3-fix-documentation-to-fit-into-80-columns.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: fix documentation to fit into 80 columns
=46rom: Pavel Machek <pavel@suse.cz>

=46ix lis3 documentation to fit into 80 columns.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/lis3lv02d |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN Documentation/hwmon/lis3lv02d~lis3-fix-documentation-to-fit-i=
nto-80-columns Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~lis3-fix-documentation-to-fit-into-=
80-columns
+++ a/Documentation/hwmon/lis3lv02d
@@ -13,18 +13,21 @@ Author:
 Description
 -----------
=20
-This driver provides support for the accelerometer found in various HP=
 laptops
-sporting the feature officially called "HP Mobile Data Protection Syst=
em 3D" or
-"HP 3D DriveGuard". It detect automatically laptops with this sensor. =
Known models
-(for now the HP 2133, nc6420, nc2510, nc8510, nc84x0, nw9440 and nx942=
0) will
-have their axis automatically oriented on standard way (eg: you can di=
rectly
-play neverball).  The accelerometer data is readable via
+This driver provides support for the accelerometer found in various HP
+laptops sporting the feature officially called "HP Mobile Data
+Protection System 3D" or "HP 3D DriveGuard". It detect automatically
+laptops with this sensor. Known models (for now the HP 2133, nc6420,
+nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
+automatically oriented on standard way (eg: you can directly play
+neverball).  The accelerometer data is readable via
 /sys/devices/platform/lis3lv02d.
=20
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
 position - 3D position that the accelerometer reports. Format: "(x,y,z=
)"
-calibrate - read: values (x, y, z) that are used as the base for input=
 class device operation.
-            write: forces the base to be recalibrated with the current=
 position.
+calibrate - read: values (x, y, z) that are used as the base for input
+		  class device operation.
+            write: forces the base to be recalibrated with the current
+		  position.
 rate - reports the sampling rate of the accelerometer device in HZ
=20
 This driver also provides an absolute input class device, allowing
@@ -39,11 +42,12 @@ the accelerometer are converted into a "
  * When the laptop is horizontal the position reported is about 0 for =
X and Y
 and a positive value for Z
  * If the left side is elevated, X increases (becomes positive)
- * If the front side (where the touchpad is) is elevated, Y decreases =
(becomes negative)
+ * If the front side (where the touchpad is) is elevated, Y decreases
+	(becomes negative)
  * If the laptop is put upside-down, Z becomes negative
=20
-If your laptop model is not recognized (cf "dmesg"), you can send an e=
mail to the
-authors to add it to the database.  When reporting a new laptop, pleas=
e include
-the output of "dmidecode" plus the value of /sys/devices/platform/lis3=
lv02d/position
-in these four cases.
+If your laptop model is not recognized (cf "dmesg"), you can send an
+email to the authors to add it to the database.  When reporting a new
+laptop, please include the output of "dmidecode" plus the value of
+/sys/devices/platform/lis3lv02d/position in these four cases.
=20
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
resume-wait-for-device-probing-to-finish.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
nbd-trivial-cleanups.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
