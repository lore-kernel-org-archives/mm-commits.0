Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18AEC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F0564E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhBXUIa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhBXUH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1BE364F25;
        Wed, 24 Feb 2021 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197247;
        bh=sVHLziYvhxSq2bqIqKaw8dnFYh7i8OV7YiwoHz6hNdA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vfDx4b9OmUiupH/wE5E9hHFafDYavzRcZoWdYsPYneqp3cOCZ/lKHbdcrxyJsEoHc
         B07AbLGTa0Gm+Ej+PMSdAEgY35kvwcF6vSdP2nIiqxFcZ4Vh24K1Ny1feFw0W/tDeY
         s87wVsF2F40TjWgnIKzSXsa/gwQv5wkE/dRDPFHI=
Date:   Wed, 24 Feb 2021 12:07:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 123/173] mm/hugetlb.c: fix typos in comments
Message-ID: <20210224200726.aZkBl9bAn%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
