Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDB9C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D5061469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhGAAuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236734AbhGAAuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9643661425;
        Thu,  1 Jul 2021 00:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100451;
        bh=F/9YIxYbLh0mFVVQ7sRvhvQ1RsO64EW+6waZhZLp5Eo=;
        h=Date:From:To:Subject:From;
        b=luKMAxdyMwGe6exOak0ApwJArIE96E+LciAlTR3jJ/ZUCxUgE20rTxGlDLMy9F0eh
         JbHjc6Eqj8tZ7H8fYiDXVrwsQ3vPckDgrB7jdkSK0jMNjR3IxuX+7NaH2nASNmpWQR
         KGg5oTkjxRUYWP3kTwI5D9lH9a5340N8gdzsTJaU=
Date:   Wed, 30 Jun 2021 17:47:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-huge?=
 =?US-ASCII?Q?tlb-page-fix-2.patch?= removed from -mm tree
Message-ID: <20210701004731.uS3HHJ0U4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix alloc_vmemmap_page_list documentation warning
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch

This patch was dropped because it was folded into mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix alloc_vmemmap_page_list documentation warning

This simple typo generates two warnings from kernel-doc.

Link: https://lkml.kernel.org/r/20210615200242.1716568-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2
+++ a/mm/sparse-vmemmap.c
@@ -272,7 +272,7 @@ out:
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
  * @reuse:	reuse address.
- * @gpf_mask:	GFP flag for allocating vmemmap pages.
+ * @gfp_mask:	GFP flag for allocating vmemmap pages.
  */
 int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			unsigned long reuse, gfp_t gfp_mask)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-thp-fix-strncpy-warning.patch
mm-mark-idle-page-tracking-as-broken.patch

