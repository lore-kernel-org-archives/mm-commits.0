From: akpm@linux-foundation.org
Subject: [merged]
 rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch removed from
 -mm tree
Date: Tue, 27 Jan 2015 12:22:37 -0800
Message-ID: <54c7f38d.fvLNH9aPPkApLHrf%akpm__41115.8571755097$1422390169$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbA0UWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, k.kozlowski@samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: terminate s5m_rtc_id array with empty element
has been removed from the -mm tree.  Its filename was
     rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: terminate s5m_rtc_id array with empty element

Array of platform_device_id elements should be terminated with empty
element.

Fixes: 5bccae6ec458 ("rtc: s5m-rtc: add real-time clock driver for s5m8767")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element
+++ a/drivers/rtc/rtc-s5m.c
@@ -832,6 +832,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops,
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc",		S5M8767X },
 	{ "s2mps14-rtc",	S2MPS14X },
+	{ },
 };
 
 static struct platform_driver s5m_rtc_driver = {
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
linux-next.patch

