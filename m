From: akpm@linux-foundation.org
Subject: - fbdev-export-fb_destroy_modelist.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:19 -0700
Message-ID: <200710162043.l9GKhJfZ016033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761491AbXJPVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: export fb_destroy_modelist
has been removed from the -mm tree.  Its filename was
     fbdev-export-fb_destroy_modelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: export fb_destroy_modelist
From: Michal Januszewski <spock@gentoo.org>

Make fb_destroy_modelist an exported symbol for use in the uvesafb driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/modedb.c~fbdev-export-fb_destroy_modelist drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-export-fb_destroy_modelist
+++ a/drivers/video/modedb.c
@@ -938,6 +938,7 @@ void fb_destroy_modelist(struct list_hea
 		kfree(pos);
 	}
 }
+EXPORT_SYMBOL_GPL(fb_destroy_modelist);
 
 /**
  * fb_videomode_to_modelist: convert mode array to mode list
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
