Return-Path: <SRS0=3Kjr=BA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039A8C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D292080D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jul 2020 00:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595291478;
	bh=Z8Z8KWi2t9Xn/wE98Eb7Nb+0eHY54+C51wE7vThVAHg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=x7YNPUgAgresMVtJ5H3ZqQUzbnr/G+QOYjv1XyLFAJWKICAo7A+bRKu1+/NbCAHq3
	 Qlsdz/bLReAicHmobnTrhZ5/ydrSSD+rXeWcOF6BY6gbd00pDxqionRGqcTAyxE1oO
	 Hi6+oxfttEohIXpHUoyMubCF+qMsbP3/CzRBv2Eg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgGUAbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGUAbS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 20:31:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E084207FC;
        Tue, 21 Jul 2020 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595291476;
        bh=Z8Z8KWi2t9Xn/wE98Eb7Nb+0eHY54+C51wE7vThVAHg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PB0tbFv6qg+Yql45NKOY5bxhpV87jMbUsHM6ea5z1fKlH8wDkJV782U60p9RxyaEO
         KmOAM2l97bGY9JHlqy9ZYY0gZvBos9mwWGZzccVj845mCryw+LZjdNU8oGGCLjF4p3
         d7ySSJOQPeo/Dpt6JNuJ8/o8H/OuUHBo/jao1KQs=
Date:   Mon, 20 Jul 2020 17:31:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch added to
 -mm tree
Message-ID: <20200721003116.2nMVuT3m-%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/frontswap.h:  drop duplicated word in a comment
has been added to the -mm tree.  Its filename is
     frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-suballoch-delete-a-duplicated-word.patch
linux-sched-mmh-drop-duplicated-words-in-comments.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
autofs-fix-doubled-word.patch

