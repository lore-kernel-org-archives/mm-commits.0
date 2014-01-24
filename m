From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:02:54 -0800
Message-ID: <52e2b8de.kOJp3fimLkzUN7Eo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaAXTCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:54 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper

'ds1742_rtc_of_match' is always compiled in.  Hence the helper macro is
not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper
+++ a/drivers/rtc/rtc-ds1742.c
@@ -228,7 +228,7 @@ static struct platform_driver ds1742_rtc
 	.driver		= {
 		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ds1742_rtc_of_match),
+		.of_match_table = ds1742_rtc_of_match,
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

