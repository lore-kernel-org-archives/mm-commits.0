From: akpm@linux-foundation.org
Subject: + lis3-add-missing-constants-for-8bit-device.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:20:13 -0700
Message-ID: <201004072120.o37LKDxt007934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab0DGVVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add missing constants for 8bit device
has been added to the -mm tree.  Its filename is
     lis3-add-missing-constants-for-8bit-device.patch

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
Subject: lis3: add missing constants for 8bit device
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Definitions for click were missing.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Tested-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-missing-constants-for-8bit-device drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-missing-constants-for-8bit-device
+++ a/drivers/hwmon/lis3lv02d.h
@@ -196,6 +196,16 @@ enum lis3lv02d_dd_src {
 	DD_SRC_IA	= 0x40,
 };
 
+enum lis3lv02d_click_src_8b {
+	CLICK_SINGLE_X	= 0x01,
+	CLICK_DOUBLE_X	= 0x02,
+	CLICK_SINGLE_Y	= 0x04,
+	CLICK_DOUBLE_Y	= 0x08,
+	CLICK_SINGLE_Z	= 0x10,
+	CLICK_DOUBLE_Z	= 0x20,
+	CLICK_IA	= 0x40,
+};
+
 struct axis_conversion {
 	s8	x;
 	s8	y;
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch

