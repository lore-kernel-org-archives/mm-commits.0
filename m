From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:29 -0700
Message-ID: <20130430185129.71D975A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:42528 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Sva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:30 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so76999ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/omap1_bl.c: use dev_info() instead of pr_info()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/omap1_bl.c: use dev_info() instead of pr_info()

dev_info() is preferred to pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info
+++ a/drivers/video/backlight/omap1_bl.c
@@ -18,8 +18,6 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
