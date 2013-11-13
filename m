From: akpm@linux-foundation.org
Subject: [merged]
 drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:42:16 -0800
Message-ID: <5283e428.3t8CBcxFhJdAGUbN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3KMUmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: [merged] drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch removed from -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com,maxime.ripard@free-electrons.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:42:16 -0800


The patch titled
     Subject: drivers/video/backlight/hx8357.c: remove redundant of_match_ptr
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/hx8357.c: remove redundant of_match_ptr

'hx8357_dt_ids' is always compiled in.  Hence of_match_ptr is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/hx8357.c~drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr
+++ a/drivers/video/backlight/hx8357.c
@@ -673,7 +673,7 @@ static struct spi_driver hx8357_driver =
 	.probe  = hx8357_probe,
 	.driver = {
 		.name = "hx8357",
-		.of_match_table = of_match_ptr(hx8357_dt_ids),
+		.of_match_table = hx8357_dt_ids,
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

