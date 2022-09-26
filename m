Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04D2C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 21:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiIZVCj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 17:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiIZVCh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 17:02:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CFB91D13
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 14:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 884A1B8111C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 21:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A96CC433C1;
        Mon, 26 Sep 2022 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664226150;
        bh=hJi/8rmcB2Uz2yPTnUQMOPXcw1MwF8OC7MjEbrzZjr8=;
        h=Date:To:From:Subject:From;
        b=JOs5V/BZKG4GoPd9Vi2oBEBDDYWaEe0rX06Q/OiRi5WB5xhMoQi6qUz7fzbtKg5cR
         pVDgx2bgLykCaViEK0iPrH9SsOpqgPOay+bIxZAWMsOD4w1eyss/rksw7w5dJemwe6
         rGV4gkivSVaEVXViNVvK61zZpXGSikK+RgQiIQB8=
Date:   Mon, 26 Sep 2022 14:02:29 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-the-vma-linked-list-fix.patch removed from -mm tree
Message-Id: <20220926210230.3A96CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix one kernel-doc comment
has been removed from the -mm tree.  Its filename was
     mm-remove-the-vma-linked-list-fix.patch

This patch was dropped because it was folded into mm-remove-the-vma-linked-list.patch

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: fix one kernel-doc comment
Date: Wed, 24 Aug 2022 10:19:18 +0800

Add the description for @mt.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1949
Link: https://lkml.kernel.org/r/20220824021918.94116-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-remove-the-vma-linked-list-fix
+++ a/mm/memory.c
@@ -1697,6 +1697,7 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
+ * @mt: the maple tree
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-remove-the-vma-linked-list.patch

