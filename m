From: akpm@linux-foundation.org
Subject: + hp_accel-add-hp-mini-510x-family-support.patch added to -mm tree
Date: Fri, 24 Sep 2010 14:07:41 -0700
Message-ID: <201009242107.o8OL7fVX025348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab0IXVHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 17:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: standby24x7@gmail.com, eric.piel@tremplin-utc.net, guenter.roeck@ericsson.com, tiwai@suse.de


The patch titled
     hp_accel: add HP Mini 510x family support
has been added to the -mm tree.  Its filename is
     hp_accel-add-hp-mini-510x-family-support.patch

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
Subject: hp_accel: add HP Mini 510x family support
From: Masanari Iida <standby24x7@gmail.com>

An enhanced version of Takashi Iwai's [PATCH] hp_accel: Add quirks for HP
ProBook 532x and HP Mini 5102 My HP Mini 5101 works fine with this patch. 
Confirmed with Tux Racer.

Signed-off by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-add-hp-mini-510x-family-support drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-add-hp-mini-510x-family-support
+++ a/drivers/hwmon/hp_accel.c
@@ -225,7 +225,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
-	AXIS_DMI_MATCH("Mini5102", "HP Mini 5102", xy_rotated_left_usd),
+	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from standby24x7@gmail.com are

hp_accel-add-hp-mini-510x-family-support.patch

