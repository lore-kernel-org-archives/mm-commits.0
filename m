Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBEFC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D577207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266189;
	bh=GKPSqqIutsiZkFinGN+vdvYtK0arOOcs/wVkTYfrhU4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VzkkTDXAC4UCeLCiddBkxYnJZCWX/6/FOuhc8Ljjl+HcB2XU2eGFhs7qRw/jwv9+W
	 Z74E+x71sN59t3Hbyi1Hsv/iicAHiekz0j6FxaerJWHKjB2mMDt6NAQagkNivlVvRO
	 NHlrJjEyEj8juOazJZh8OpyZkBXtIMmtOJk7Bslg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHLVDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD5620774;
        Wed, 12 Aug 2020 21:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266187;
        bh=GKPSqqIutsiZkFinGN+vdvYtK0arOOcs/wVkTYfrhU4=;
        h=Date:From:To:Subject:From;
        b=fUHjGix4VGHWu6i/fNXM5SGMA5mmVE98CsDUU/eofstR4bgUBz/4Hlbn0f3WJh5Zw
         JqqoGEDeFtZc4OUuH5sdK7wyeTS2GV4NrmeJrnrxiZOCsxLTuImkkuAhpEAk5IZ2ck
         iUEof4uLDDAehj2PXiy+Hby16YLwBqA0oN1PxBDE=
Date:   Wed, 12 Aug 2020 14:03:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-slab_commonc-delete-duplicated-word.patch
 removed from -mm tree
Message-ID: <20200812210307.Zi28m0YEW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-slab_commonc-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/slab_common.c: delete duplicated word

Drop the repeated word "and".

Link: http://lkml.kernel.org/r/20200801173822.14973-12-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c~mm-slab_commonc-delete-duplicated-word
+++ a/mm/slab_common.c
@@ -419,7 +419,7 @@ static void slab_caches_to_rcu_destroy_w
 	/*
 	 * On destruction, SLAB_TYPESAFE_BY_RCU kmem_caches are put on the
 	 * @slab_caches_to_rcu_destroy list.  The slab pages are freed
-	 * through RCU and and the associated kmem_cache are dereferenced
+	 * through RCU and the associated kmem_cache are dereferenced
 	 * while freeing the pages, so the kmem_caches should be freed only
 	 * after the pending RCU operations are finished.  As rcu_barrier()
 	 * is a pretty slow operation, we batch all pending destructions
_

Patches currently in -mm which might be from rdunlap@infradead.org are


