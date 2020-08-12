Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684F5C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE022080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266168;
	bh=VYElj3uKVcQxVwfzX0HWPZthhIwpyI9ZhvRVzBYhotk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=t9+RBVGYfqRzh+TbfDQ95EZyin6R0yz4ORWz63fvNfPKNUU8U5nmxuK9qV3tEGPsr
	 7R2jdFaUP8AGVPlsnu9JW23lZXEMWwuFL8VXZmQIQ7Vec4QPUZSZu8VELJWsZO/1WG
	 rtrKNN6bT7UgJ/gT7cDwsJ7evaXZxDG5llsKj2ss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLVCs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7152520774;
        Wed, 12 Aug 2020 21:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266167;
        bh=VYElj3uKVcQxVwfzX0HWPZthhIwpyI9ZhvRVzBYhotk=;
        h=Date:From:To:Subject:From;
        b=CHyKBuos/DogRpBSveVo5RsV2QnAWq8eQPjg9OF/MkbaJLE5LBJ6oEIghj6EyWxSF
         EQb1hmzd63lz6wHQ5ecvFTs14m0X77IVxxEYcaelCTHbZirjASA7nG25Gv1lhAXFAb
         QI5IFX4XUTq0ydM8DpOrXnvYLO0c75d/IskGIYYo=
Date:   Wed, 12 Aug 2020 14:02:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-compactionc-delete-duplicated-word.patch
 removed from -mm tree
Message-ID: <20200812210247.jsdXWF0zT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-compactionc-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/compaction.c: delete duplicated word

Drop the repeated word "a".

Link: http://lkml.kernel.org/r/20200801173822.14973-2-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compactionc-delete-duplicated-word
+++ a/mm/compaction.c
@@ -1477,7 +1477,7 @@ static void isolate_freepages(struct com
 	 * this pfn aligned down to the pageblock boundary, because we do
 	 * block_start_pfn -= pageblock_nr_pages in the for loop.
 	 * For ending point, take care when isolating in last pageblock of a
-	 * a zone which ends in the middle of a pageblock.
+	 * zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
_

Patches currently in -mm which might be from rdunlap@infradead.org are


