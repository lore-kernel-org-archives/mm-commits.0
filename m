From: akpm@linux-foundation.org
Subject: [merged] console-vgaconc-mark-file-local-symbol-static.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:11 -0800
Message-ID: <201003091910.o29JABvE031581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab0CITWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfransosi@gmail.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     console/vgacon.c: mark file-local symbol static
has been removed from the -mm tree.  Its filename was
     console-vgaconc-mark-file-local-symbol-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: console/vgacon.c: mark file-local symbol static
From: Thiago Farina <tfransosi@gmail.com>

warning: symbol 'vgacon_text_mode_force' was not declared. Should it be static?

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~console-vgaconc-mark-file-local-symbol-static drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~console-vgaconc-mark-file-local-symbol-static
+++ a/drivers/video/console/vgacon.c
@@ -112,7 +112,7 @@ static int 		vga_video_font_height;
 static int 		vga_scan_lines		__read_mostly;
 static unsigned int 	vga_rolled_over;
 
-int vgacon_text_mode_force = 0;
+static int vgacon_text_mode_force;
 
 bool vgacon_text_force(void)
 {
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch

