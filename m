From: akpm@linux-foundation.org
Subject: - drm-via-invalid-device-ids-removal.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:11 -0700
Message-ID: <200710150917.l9F9HB9e027253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120AbXJOJSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xavier@bachelot.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: VIA invalid device IDs removal
has been removed from the -mm tree.  Its filename was
     drm-via-invalid-device-ids-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drm: VIA invalid device IDs removal
From: Xavier Bachelot <xavier@bachelot.org>

0x1106, 0x7204 is unknown and thus is not an IGP/GPU.
0x1106, 0x3304 is K8M800 hostbridge, not an IGP/GPU.
None of them are in drm git tree.

Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_pciids.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/drm/drm_pciids.h~drm-via-invalid-device-ids-removal drivers/char/drm/drm_pciids.h
--- a/drivers/char/drm/drm_pciids.h~drm-via-invalid-device-ids-removal
+++ a/drivers/char/drm/drm_pciids.h
@@ -236,10 +236,8 @@
 	{0x1106, 0x3022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
 	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x7204, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x1106, 0x3304, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
_

Patches currently in -mm which might be from xavier@bachelot.org are

git-drm.patch
