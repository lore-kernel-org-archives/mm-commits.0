Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572B3C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37ACC206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027242;
	bh=7fbx3EPVh4EORpHj2GHFLd6IKvw3ARhPPiIg6u2g6CA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bsrVlQTxPNT9EZlb/DGEp4elurd/X9rUJlAZhHqUnpauUxjcGuGaeWFuOXj7ltFOr
	 fVelUI5H+/7kDng5MHmRNosd3JYMId9k6Ow0kewO7bdsAHGeOQaSdhJqIIzRZshu9T
	 RmFrwVjq8AVB15xgVV1yqjQWFitY+68I8cJ8elWc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70AAE2065D;
        Mon, 10 Aug 2020 02:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027241;
        bh=7fbx3EPVh4EORpHj2GHFLd6IKvw3ARhPPiIg6u2g6CA=;
        h=Date:From:To:Subject:From;
        b=USdHJg+pUHEFtMldHrXSb8d7lOSGFuejst4qW0Xq3GCo2BM4ECDFKbVEwEtkzkilS
         RYvN6mDHBddyk89yZW22dlhjgmvCUymyvc5Fu2BKVYXuIL0lPgq2OXqQfawkpo53HC
         Xk+m+h08wfRNttE0Ce44nbyFn6rTi0b/1nHcIBJ4=
Date:   Sun, 09 Aug 2020 19:40:41 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        spacct.spacct@gmail.com
Subject:  [merged] mm-vmscanc-fixed-typo.patch removed from -mm
 tree
Message-ID: <20200810024041.vsT1Aey9Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix typo
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fixed-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: dylan-meiners <spacct.spacct@gmail.com>
Subject: mm/vmscan.c: fix typo

Change "optizimation" to "optimization".

Link: http://lkml.kernel.org/r/20200609185144.10049-1-spacct.spacct@gmail.com
Signed-off-by: dylan-meiners <spacct.spacct@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fixed-typo
+++ a/mm/vmscan.c
@@ -910,7 +910,7 @@ static int __remove_mapping(struct addre
 		 * order to detect refaults, thus thrashing, later on.
 		 *
 		 * But don't store shadows in an address space that is
-		 * already exiting.  This is not just an optizimation,
+		 * already exiting.  This is not just an optimization,
 		 * inode reclaim needs to empty out the radix tree or
 		 * the nodes are lost.  Don't plant shadows behind its
 		 * back.
_

Patches currently in -mm which might be from spacct.spacct@gmail.com are


