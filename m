From: akpm@linux-foundation.org
Subject: - vt-add-color-support-to-the-underline-and-italic-attributes-fix-2.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:07 -0700
Message-ID: <200705090300.l49307eB010526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032773AbXEIDAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adaplas@pol.net, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     SIS USB2VGA Warning fix
has been removed from the -mm tree.  Its filename was
     vt-add-color-support-to-the-underline-and-italic-attributes-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SIS USB2VGA Warning fix
From: WANG Cong <xiyou.wangcong@gmail.com>

drivers/usb/misc/sisusbvga/sisusb_con.c:1436: warning: initialization from incompatible pointer type

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb_con.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/misc/sisusbvga/sisusb_con.c~vt-add-color-support-to-the-underline-and-italic-attributes-fix-2 drivers/usb/misc/sisusbvga/sisusb_con.c
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c~vt-add-color-support-to-the-underline-and-italic-attributes-fix-2
+++ a/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -321,7 +321,7 @@ sisusbcon_deinit(struct vc_data *c)
 /* interface routine */
 static u8
 sisusbcon_build_attr(struct vc_data *c, u8 color, u8 intensity,
-			    u8 blink, u8 underline, u8 reverse)
+			    u8 blink, u8 underline, u8 reverse, u8 unused)
 {
 	u8 attr = color;
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
