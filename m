Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C6DC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B12864F2B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhBYTeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhBYTaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 974C664F29;
        Thu, 25 Feb 2021 19:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280623;
        bh=mHJS7mJ9tM1scdTshtoENjg48oC1Cc2J8vtt3vfLEdU=;
        h=Date:From:To:Subject:From;
        b=dg6NMDWix9TnRReUGsRZ3cA/Qr4pF9lxOITvZJb5zGpeGL2GSDZu36Mswz3D3Kbov
         o48RQWWaIfaUhyH56QZZWYJC3+7rbeo5fzqf/lYBDTLkfwpmVxIDwmXm8Zp3pkk0Zd
         c9ByJYKU1TJpy56iErprncNoYOH5BjyL5bMWPUWA=
Date:   Thu, 25 Feb 2021 11:17:03 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [merged] mm-hugetlbc-fix-typos-in-comments.patch removed
 from -mm tree
Message-ID: <20210225191703.qbjfayj3e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/hugetlb.c: fix typos in comments

Fix typo in comment.

Link: https://lkml.kernel.org/r/1612256106-9436-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-typos-in-comments
+++ a/mm/hugetlb.c
@@ -4028,7 +4028,7 @@ void unmap_hugepage_range(struct vm_area
 
 /*
  * This is called when the original mapper is failing to COW a MAP_PRIVATE
- * mappping it owns the reserve page for. The intention is to unmap the page
+ * mapping it owns the reserve page for. The intention is to unmap the page
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are


