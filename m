From: akpm@linux-foundation.org
Subject: - media-tuner-xc2028-depends-on-fw_loader.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:28 -0500
Message-ID: <200802150226.m1F2QljC015251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760115AbYBOC2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:28:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     media: tuner-xc2028 depends on FW_LOADER
has been removed from the -mm tree.  Its filename was
     media-tuner-xc2028-depends-on-fw_loader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media: tuner-xc2028 depends on FW_LOADER
From: Paul Mundt <lethal@linux-sh.org>

ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!
ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/Kconfig~media-tuner-xc2028-depends-on-fw_loader drivers/media/Kconfig
--- a/drivers/media/Kconfig~media-tuner-xc2028-depends-on-fw_loader
+++ a/drivers/media/Kconfig
@@ -102,7 +102,7 @@ if VIDEO_TUNER_CUSTOMIZE
 
 config TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-	depends on I2C
+	depends on I2C && FW_LOADER
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
fix-module_update_markers-compile-error.patch
git-dvb.patch
git-sh.patch
net-xfrm-statistics-depend-on-inet.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
asm-futexh-should-include-linux-uaccessh.patch
