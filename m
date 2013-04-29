From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:42:34 -0700
Message-ID: <20130429214235.47B0731C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:52769 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab3D2Vmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:42:36 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so108337vbe.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:42:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haiyangz@microsoft.com, fengguang.wu@intel.com, kys@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: fix a type warning in hyperv_fb.c
has been removed from the -mm tree.  Its filename was
     drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch

This patch was dropped because it was folded into drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver.patch

------------------------------------------------------
From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: video: fix a type warning in hyperv_fb.c

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hyperv_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/hyperv_fb.c~drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix drivers/video/hyperv_fb.c
--- a/drivers/video/hyperv_fb.c~drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix
+++ a/drivers/video/hyperv_fb.c
@@ -624,7 +624,7 @@ static int hvfb_getmem(struct fb_info *i
 {
 	struct pci_dev *pdev;
 	ulong fb_phys;
-	void *fb_virt;
+	void __iomem *fb_virt;
 
 	pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
 			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
_

Patches currently in -mm which might be from haiyangz@microsoft.com are

origin.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver.patch

