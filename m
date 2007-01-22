From: akpm@osdl.org
Subject: + acpi-removes-video-device-notify-message.patch added to -mm tree
Date: Mon, 22 Jan 2007 13:52:44 -0800
Message-ID: <200701222152.l0MLqi6t003082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXAVVyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.chua.linux@gmail.com, lenb@kernel.org


The patch titled
     acpi: remove "video device notify" message
has been added to the -mm tree.  Its filename is
     acpi-removes-video-device-notify-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: remove "video device notify" message
From: Jeff Chua <jeff.chua.linux@gmail.com>

Seems to be some left-over debug code.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/video.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/acpi/video.c~acpi-removes-video-device-notify-message drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-removes-video-device-notify-message
+++ a/drivers/acpi/video.c
@@ -1770,8 +1770,6 @@ static void acpi_video_device_notify(acp
 	struct acpi_video_device *video_device = data;
 	struct acpi_device *device = NULL;
 
-
-	printk("video device notify\n");
 	if (!video_device)
 		return;
 
_

Patches currently in -mm which might be from jeff.chua.linux@gmail.com are

acpi-removes-video-device-notify-message.patch
