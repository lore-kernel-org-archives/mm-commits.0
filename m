Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24B3C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A743C20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266182;
	bh=nE9IcxOME+3y2hyHTgzGP+2AZivA5z1oAAHYJSV8IvM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ksPFFA7NnhbzIby2jFzCdhIiGR58Zv2zUqhzheKaXgp74MnBF+ggUJe79ToJhjymP
	 E02QdqFZj/yZ2M9E/9wDudRW0c85RJR++7e0ztx6+Yig+nYaf9+nGM+MlUD6Oi5kii
	 TJqkWp3sJpVA5M8Q0ZRJcb9pAr1f3kWHPDI/qFX8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVDC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgHLVDB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 736A22078B;
        Wed, 12 Aug 2020 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266181;
        bh=nE9IcxOME+3y2hyHTgzGP+2AZivA5z1oAAHYJSV8IvM=;
        h=Date:From:To:Subject:From;
        b=IfKwjoGjcKmXeYda/3+7IDyl4skK6jCZvyXGjglcxnO+yyQEw868LqVdZ+MuAifcG
         yyJVgk4QLImtSQqoR0FpxAQgLnKDQNhgj69Vt4GD81pl9EYSYJCXjq66lgAKpa/j7j
         76mgrqAVJ9J2VCVes4dDIbgJqQUpdA4R/kWBeQwE=
Date:   Wed, 12 Aug 2020 14:03:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-nommuc-delete-duplicated-words.patch removed
 from -mm tree
Message-ID: <20200812210301._B0d8Oid4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: delete duplicated words
has been removed from the -mm tree.  Its filename was
     mm-nommuc-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/nommu.c: delete duplicated words

Drop the repeated word "that" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-9-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~mm-nommuc-delete-duplicated-words
+++ a/mm/nommu.c
@@ -1762,8 +1762,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * @newsize: The proposed filesize of the inode
  *
  * Check the shared mappings on an inode on behalf of a shrinking truncate to
- * make sure that that any outstanding VMAs aren't broken and then shrink the
- * vm_regions that extend that beyond so that do_mmap() doesn't
+ * make sure that any outstanding VMAs aren't broken and then shrink the
+ * vm_regions that extend beyond so that do_mmap() doesn't
  * automatically grant mappings that are too large.
  */
 int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
_

Patches currently in -mm which might be from rdunlap@infradead.org are


