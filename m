From: akpm@linux-foundation.org
Subject: - hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:46 -0700
Message-ID: <200805270726.m4R7QkIg014698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbYE0H1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: czigola@gmail.com, dtor@mail.ru, jikos@jikos.cz, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hdaps: invert the axes for HDAPS on Lenovo R61i ThinkPads
has been removed from the -mm tree.  Its filename was
     hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


