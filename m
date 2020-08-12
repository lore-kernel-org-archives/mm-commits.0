Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8ABC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2B6207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266160;
	bh=EXJwY3PrCjQrwGkqb3SKYpYuC+XjKjy+u1nZ07a+RWM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2dDwS37qCh6wmQaLJg41i4wNFMNtdCW6imeRC//O0HJBwOwsFuS5x7gMQzEMm5Os+
	 ji7JxP01+I3IyBBAX+SJjQ+PRKYXCQyT1rUKaADKWWWbcK7wlBmdhZzD6loEg5YLyV
	 ZGXVH7/Xw/v6bIoDMDRAR4z1XzHA68DB54zJwZAE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHLVCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C11320774;
        Wed, 12 Aug 2020 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266159;
        bh=EXJwY3PrCjQrwGkqb3SKYpYuC+XjKjy+u1nZ07a+RWM=;
        h=Date:From:To:Subject:From;
        b=YSIRIwTdmkg2MgkhW92x+WJhbD79+YxMgbD6KzxfE7y2bkxk7BrMV1V2xL81jDDcR
         SZvlVVyHGCGFJGjc0F2bAInBLl4oBCteEC1v10K6whCeHAZX5G3yaL+i5DF46x9hKS
         cdO1D9EC4GaKQ2O9PeBkElk2DoeFSUKAGp8lVmHk=
Date:   Wed, 12 Aug 2020 14:02:39 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch removed
 from -mm tree
Message-ID: <20200812210239.W-Rbi3am_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/frontswap.h:  drop duplicated word in a comment
has been removed from the -mm tree.  Its filename was
     frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/frontswap.h:  drop duplicated word in a comment

Drop the doubled word "in" in a comment.

Link: http://lkml.kernel.org/r/3af7ed91-ad62-8445-40a4-9e07a64b9523@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/frontswap.h~frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment
+++ a/include/linux/frontswap.h
@@ -10,7 +10,7 @@
 /*
  * Return code to denote that requested number of
  * frontswap pages are unused(moved to page cache).
- * Used in in shmem_unuse and try_to_unuse.
+ * Used in shmem_unuse and try_to_unuse.
  */
 #define FRONTSWAP_PAGES_UNUSED	2
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are


