Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73345C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200DB64F22
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhB0Cam (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhB0CaO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 781F564F29;
        Sat, 27 Feb 2021 02:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392992;
        bh=mZO1YWNBG5uJhJ5UKxoBf30+TwqACTnNnuGqgtuk2oU=;
        h=Date:From:To:Subject:From;
        b=xxOi11k6eKfLoqGLvsVFabFqe/Af6gLbVxe2Uda+tdOzJythgnL2lJtWqUtApkBln
         dOypByUXo+cky5ReLUe1fdFXzxA4VkFnaNKAnWJeC4s3W0n4ex/hFXqdl9cuc/RWOP
         nIJv+sSQZRW0ZlD8nMGK7Gv7ZI/2Bkf5YeWOCwwQ=
Date:   Fri, 26 Feb 2021 18:29:52 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch removed from -mm
 tree
Message-ID: <20210227022952.Mh5rtlLHC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: remove unneeded semicolon in page_not_mapped()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: remove unneeded semicolon in page_not_mapped()

Remove extra semicolon without any functional change intended.

Link: https://lkml.kernel.org/r/20210127093425.39640-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-remove-unneeded-semicolon-in-page_not_mapped
+++ a/mm/rmap.c
@@ -1784,7 +1784,7 @@ bool try_to_unmap(struct page *page, enu
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


