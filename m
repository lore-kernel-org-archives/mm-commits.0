From: akpm@linux-foundation.org
Subject: - config_scsi_fd_8xx-no-longer-exists.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:26 -0700
Message-ID: <200707162100.l6GL0Q3i002604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbXGPVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     CONFIG_SCSI_FD_8xx no longer exists
has been removed from the -mm tree.  Its filename was
     config_scsi_fd_8xx-no-longer-exists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CONFIG_SCSI_FD_8xx no longer exists
From: Geert Uytterhoeven <geert@linux-m68k.org>

CONFIG_SCSI_FD_8xx no longer exists.

Apparently it was renamed to CONFIG_SCSI_SEAGATE, but the Makefile was
not correctly updated.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Makefile |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/scsi/Makefile~config_scsi_fd_8xx-no-longer-exists drivers/scsi/Makefile
--- a/drivers/scsi/Makefile~config_scsi_fd_8xx-no-longer-exists
+++ a/drivers/scsi/Makefile
@@ -90,7 +90,6 @@ obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_SEAGATE)	+= seagate.o
-obj-$(CONFIG_SCSI_FD_8xx)	+= seagate.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_DTC3280)	+= dtc.o
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
pm2fb-white-spaces-clean-up.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
fm2fb-the-pseudo_palette-is-only-16-elements-long.patch
offb-the-pseudo_palette-is-only-16-elements-long.patch
