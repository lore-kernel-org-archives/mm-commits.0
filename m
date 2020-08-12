Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8002EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D1E20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266176;
	bh=/dSze3CXCRTHzX0GpEHgPNo4HSS0PDl1rbZBf7zVUK8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=N0LMAt3OXeLt/hLwigyJLR1PB3pRhMokNiD+h11pSr9nAP2Ruz1y/E/q8aV6EjN5y
	 IA1ywCdO9NUhkQCevQZ1qOOiMnI9scrWktcT3N/dpfFyvOigbY6d6SFFlj7gcZGv2z
	 l/jPoGV6z6I86LBUoPKwf2ekK2wmzIVIm7XH4CKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVC4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721EF2078B;
        Wed, 12 Aug 2020 21:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266175;
        bh=/dSze3CXCRTHzX0GpEHgPNo4HSS0PDl1rbZBf7zVUK8=;
        h=Date:From:To:Subject:From;
        b=X72651P6S3rnBZKpocqQKT4REzgYGOW275bzJJY66btEfl1WAGCbT16nEHcYtTFey
         O80xWXi5aN96aUpQ6r8WRyvs93MIvRUVUyiaaM0eAqATulHvKhcGqyWWz0/IClvz3M
         hA64XTsOz7BzFF+LSDq4Ew5XNw/BdN8bIL0fTz7M=
Date:   Wed, 12 Aug 2020 14:02:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-memcontrolc-delete-duplicated-words.patch
 removed from -mm tree
Message-ID: <20200812210255.JBgfliU6t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: delete duplicated words
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memcontrol.c: delete duplicated words

Drop the repeated word "down".

Link: http://lkml.kernel.org/r/20200801173822.14973-6-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrolc-delete-duplicated-words
+++ a/mm/memcontrol.c
@@ -2422,7 +2422,7 @@ static void high_work_func(struct work_s
  *
  * - MEMCG_DELAY_PRECISION_SHIFT: Extra precision bits while translating the
  *   overage ratio to a delay.
- * - MEMCG_DELAY_SCALING_SHIFT: The number of bits to scale down down the
+ * - MEMCG_DELAY_SCALING_SHIFT: The number of bits to scale down the
  *   proposed penalty in order to reduce to a reasonable number of jiffies, and
  *   to produce a reasonable delay curve.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are


