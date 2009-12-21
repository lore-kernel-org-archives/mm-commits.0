From: akpm@linux-foundation.org
Subject: [obsolete] drm-via-add-pci-id-for-via-vx800-chipset.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:56:31 -0800
Message-ID: <200912212356.nBLNuVIh003694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbZLUX4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:56:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.schlichter@web.de, airlied@redhat.com, alexdeucher@gmail.com, eric@anholt.net, mm-commits@vger.kernel.org


The patch titled
     drm/via: add pci id for VIA VX800 chipset
has been removed from the -mm tree.  Its filename was
     drm-via-add-pci-id-for-via-vx800-chipset.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/via: add pci id for VIA VX800 chipset
From: Thomas Schlichter <thomas.schlichter@web.de>

The VIA DRM module is able to accelerate 2D video on the VX800 chipset,
thus add the corresponding PCI ID.  Accelerated 3D video is not
implemented.

The modified VIA DRM module was tested with X.Org openchrome driver on a
Samsung NC20 netbook.  Video playback with xine requires nearly 30% less
CPU cycles.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm_pciids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/drm/drm_pciids.h~drm-via-add-pci-id-for-via-vx800-chipset include/drm/drm_pciids.h
--- a/include/drm/drm_pciids.h~drm-via-add-pci-id-for-via-vx800-chipset
+++ a/include/drm/drm_pciids.h
@@ -477,6 +477,7 @@
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0x1106, 0x3157, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
+	{0x1106, 0x1122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0, 0, 0}
 
 #define i810_PCI_IDS \
_

Patches currently in -mm which might be from thomas.schlichter@web.de are

drm-via-add-pci-id-for-via-vx800-chipset.patch

