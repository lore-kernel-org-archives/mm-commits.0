From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:58 -0800
Message-ID: <52e2b8e2.h0FQTHZ48OGfBnS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaAXTC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:58 -0800


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: staticize local symbol
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-hym8563.c: staticize local symbol

'hym8563_clkout_ops' is used only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-staticize-local-symbol drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-staticize-local-symbol
+++ a/drivers/rtc/rtc-hym8563.c
@@ -389,7 +389,7 @@ static int hym8563_clkout_is_prepared(st
 	return !(ret & HYM8563_CLKOUT_DISABLE);
 }
 
-const struct clk_ops hym8563_clkout_ops = {
+static const struct clk_ops hym8563_clkout_ops = {
 	.prepare = hym8563_clkout_prepare,
 	.unprepare = hym8563_clkout_unprepare,
 	.is_prepared = hym8563_clkout_is_prepared,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

