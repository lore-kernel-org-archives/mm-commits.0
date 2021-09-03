Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA205C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F93A610FD
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350270AbhICVBD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350144AbhICVA5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941D26112F;
        Fri,  3 Sep 2021 20:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702796;
        bh=JcX1nJ4lLehllv1tXRsd1amEMvMzt2u+sgHU4ptRvog=;
        h=Date:From:To:Subject:From;
        b=wzg5e2iX0yGENv7ANAQcPJVb41Zq2mru/XIwY8L55N8vC4HLPoshUWgCXLBTHdEcj
         YFpZLT/iLiM2/qMa3AH7f3Pw5e6U2Ed7EzbM2WrJFqseukJCIZaco06kcrsyy9kws9
         tc1SPpcAu9ZAYMxV28cC2x2/Zjdm7hrBP1PIIhSM=
Date:   Fri, 03 Sep 2021 13:59:56 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        tdmackey@twitter.com, willy@infradead.org
Subject:  [merged]
 doc-hwpoison-correct-the-support-for-hugepage.patch removed from -mm tree
Message-ID: <20210903205956.8_ZdZ6Mii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: hwpoison: correct the support for hugepage
has been removed from the -mm tree.  Its filename was
     doc-hwpoison-correct-the-support-for-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: doc: hwpoison: correct the support for hugepage

The hwpoison support for huge page, both hugetlb and THP, has been in
kernel for a while, the statement in document is obsolete, correct it.

Link: https://lkml.kernel.org/r/20210819054116.266126-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Mackey <tdmackey@twitter.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hwpoison.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/hwpoison.rst~doc-hwpoison-correct-the-support-for-hugepage
+++ a/Documentation/vm/hwpoison.rst
@@ -180,7 +180,6 @@ Limitations
 ===========
 - Not all page types are supported and never will. Most kernel internal
   objects cannot be recovered, only LRU pages for now.
-- Right now hugepage support is missing.
 
 ---
 Andi Kleen, Oct 2009
_

Patches currently in -mm which might be from shy828301@gmail.com are


