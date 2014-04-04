From: akpm@linux-foundation.org
Subject: [merged] backlight-aat2870-remove-unnecessary-oom-messages.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:33:18 -0700
Message-ID: <533f08fe.e48LQTsvzoAt9wiu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDTdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jinyoungp@nvidia.com, jg1.han@samsung.com

Subject: [merged] backlight-aat2870-remove-unnecessary-oom-messages.patch removed from -mm tree
To: jg1.han@samsung.com,jinyoungp@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:18 -0700


The patch titled
     Subject: backlight: aat2870: remove unnecessary OOM messages
has been removed from the -mm tree.  Its filename was
     backlight-aat2870-remove-unnecessary-oom-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: aat2870: remove unnecessary OOM messages

The site-specific OOM messages are unnecessary, because they duplicate the
MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Jinyoung Park <jinyoungp@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~backlight-aat2870-remove-unnecessary-oom-messages drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~backlight-aat2870-remove-unnecessary-oom-messages
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -149,8 +149,6 @@ static int aat2870_bl_probe(struct platf
 				  sizeof(struct aat2870_bl_driver_data),
 				  GFP_KERNEL);
 	if (!aat2870_bl) {
-		dev_err(&pdev->dev,
-			"Failed to allocate memory for aat2870 backlight\n");
 		ret = -ENOMEM;
 		goto out;
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
maintainers-update-ibm-serveraid-raid-info.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch

