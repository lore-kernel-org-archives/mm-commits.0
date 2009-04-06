From: akpm@linux-foundation.org
Subject: [merged] fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:14 -0700
Message-ID: <200904061932.n36JWEag010597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757210AbZDFTeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@mail.by, mm-commits@vger.kernel.org


The patch titled
     fb: nvidiafb recognizes geforcego 7300 chip as mobile
has been removed from the -mm tree.  Its filename was
     fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: nvidiafb recognizes geforcego 7300 chip as mobile
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

nvidiafb recognizes geforcego 7300 chip as mobile

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/nvidia/nv_setup.c~fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile
+++ a/drivers/video/nvidia/nv_setup.c
@@ -362,6 +362,7 @@ int NVCommonSetup(struct fb_info *info)
 	case 0x0186:
 	case 0x0187:
 	case 0x018D:
+	case 0x01D7:
 	case 0x0228:
 	case 0x0286:
 	case 0x028C:
_

Patches currently in -mm which might be from sergey.senozhatsky@mail.by are

origin.patch

