From: akpm@osdl.org
Subject: - acpi-removes-video-device-notify-message.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:52 -0800
Message-ID: <200701260751.l0Q7pq5T010768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030833AbXAZHxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.chua.linux@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove "video device notify" message
has been removed from the -mm tree.  Its filename was
     acpi-removes-video-device-notify-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: remove "video device notify" message
From: Jeff Chua <jeff.chua.linux@gmail.com>

Seems to be some left-over debug code.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/video.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/acpi/video.c~acpi-removes-video-device-notify-message drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-removes-video-device-notify-message
+++ a/drivers/acpi/video.c
@@ -1677,8 +1677,6 @@ static void acpi_video_device_notify(acp
 	struct acpi_video_device *video_device = data;
 	struct acpi_device *device = NULL;
 
-
-	printk("video device notify\n");
 	if (!video_device)
 		return;
 
_

Patches currently in -mm which might be from jeff.chua.linux@gmail.com are
