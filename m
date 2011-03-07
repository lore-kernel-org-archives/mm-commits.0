From: akpm@linux-foundation.org
Subject: [merged] misc-bmp085-add-module_device_table.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:02 -0800
Message-ID: <201103072131.p27LVjCD028060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab1CGVcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, christoph.mair@gmail.com, jic23@cam.ac.uk, shubhrajyoti@ti.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/bmp085.c: add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     misc-bmp085-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/bmp085.c: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: Christoph Mair <christoph.mair@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/bmp085.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/bmp085.c~misc-bmp085-add-module_device_table drivers/misc/bmp085.c
--- a/drivers/misc/bmp085.c~misc-bmp085-add-module_device_table
+++ a/drivers/misc/bmp085.c
@@ -449,6 +449,7 @@ static const struct i2c_device_id bmp085
 	{ "bmp085", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, bmp085_id);
 
 static struct i2c_driver bmp085_driver = {
 	.driver = {
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

