Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68407C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7B764D99
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhA1AMN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:12:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhA1ALg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C8B964DD5;
        Thu, 28 Jan 2021 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792616;
        bh=YCFB5bwF317DguSZ/Sq2m0ji24e+18U3C+GMYmoufs8=;
        h=Date:From:To:Subject:From;
        b=jJYc75Sdoo+ZvShxV4NYo2mGYe18vTQ06nwEZMs9CtaVmFhhh85mWD6et05Ubv59t
         BF8O8cso6urgugjvRUIAMBsaP9fOzskVf2wA11H+fN+yeClIV6lGsmMIvg+NNkfHO6
         qwXYfep2zgpNWDYByVyMaLCJ2ZZCnlIQG0ublIoE=
Date:   Wed, 27 Jan 2021 16:10:16 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch added to -mm
 tree
Message-ID: <20210128001016.di0zA_hQI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: remove unneeded semicolon in page_not_mapped()
has been added to the -mm tree.  Its filename is
     mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/rmap: remove unneeded semicolon in page_not_mapped()

Remove extra semicolon without any functional change intended.

Link: https://lkml.kernel.org/r/20210127093425.39640-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-remove-unneeded-semicolon-in-page_not_mapped
+++ a/mm/rmap.c
@@ -1784,7 +1784,7 @@ bool try_to_unmap(struct page *page, enu
 static int page_not_mapped(struct page *page)
 {
 	return !page_mapped(page);
-};
+}
 
 /**
  * try_to_munlock - try to munlock a page
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

