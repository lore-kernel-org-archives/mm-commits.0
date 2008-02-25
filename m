From: akpm@linux-foundation.org
Subject: + hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch added to -mm tree
Date: Mon, 25 Feb 2008 14:45:17 -0800
Message-ID: <200802252246.m1PMk8jT023808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbYBYWrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 17:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: czigola@gmail.com, dtor@mail.ru, jikos@jikos.cz, mhoffman@lightlink.com


The patch titled
     hdaps: invert the axes for HDAPS on Lenovo R61i ThinkPads
has been added to the -mm tree.  Its filename is
     hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch

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
Subject: hdaps: invert the axes for HDAPS on Lenovo R61i ThinkPads
From: "Gabor Czigola" <czigola@gmail.com>

Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/hdaps.c~hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads
+++ a/drivers/hwmon/hdaps.c
@@ -515,6 +515,7 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
_

Patches currently in -mm which might be from czigola@gmail.com are

hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
