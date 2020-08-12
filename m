Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D45C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5E2207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266159;
	bh=G2bzpOQFG51Rd+pXuO6y2CXUiNhPa3VlQ1Pxiqg8TXM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qjJ2nDHDzXowmTv2/bYkaiTjazj+ACTJFQDTDtmZhMC+7HaQ2CJbT+jjfqbBhXk1x
	 ZRsuVuqCAuv6DjEO8UjZiN9DMRDxe3lqwMNc0xUu/ibHgpKBzcVHZqrsXcnmdWcje1
	 DaZOLz2C4Vwyv0rf9RZvCdNVcWjW/gZJaFJpN5R8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHLVCj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 723F420774;
        Wed, 12 Aug 2020 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266157;
        bh=G2bzpOQFG51Rd+pXuO6y2CXUiNhPa3VlQ1Pxiqg8TXM=;
        h=Date:From:To:Subject:From;
        b=aelJ7ztfRlHw2I1QmU1Y4wURoEab74LjE/Fx2+lvnafto1jYTnCSwqO2byzNwVm1M
         HeLuy80OnDBEeYA53t0BP7xtlv8T+fQuLPdqgRnhhC/VogzbE+bHp3oMjS47Eh2rv1
         p56gBNrt7cWc0oWqUMsfTgAXhra09gQUhKBtsUGY=
Date:   Wed, 12 Aug 2020 14:02:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged]
 highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch removed from
 -mm tree
Message-ID: <20200812210237.i6hxLjEwI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/highmem.h: fix duplicated words in a comment
has been removed from the -mm tree.  Its filename was
     highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/highmem.h: fix duplicated words in a comment

Change the doubled word "is" in a comment to "it is".

Link: http://lkml.kernel.org/r/ad605959-0083-4794-8d31-6b073300dd6f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-linux-highmemh-fix-duplicated-words-in-a-comment
+++ a/include/linux/highmem.h
@@ -73,7 +73,7 @@ static inline void kunmap(struct page *p
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  *
  * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
_

Patches currently in -mm which might be from rdunlap@infradead.org are


