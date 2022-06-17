Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29538CCA47A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243043AbiFQCMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379685AbiFQCMU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D564BE6
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C6861C50
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E0BC34114;
        Fri, 17 Jun 2022 02:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431938;
        bh=4y8cuwFTgFC8+teHPle2UPtnaunSZsl/EtCiEJY3fhk=;
        h=Date:To:From:Subject:From;
        b=W2jF4W7tFC4GWX+6TSzt5T8bADSCJKrl9XgylQOUoD1lMysvM/m9Ij81RJAvZPYoJ
         DzirITtqZ04oTlDJGbx5PfwstARa301f4/eeoRAThp6P6G71yJ+YgQYKYKkERPRIaL
         l6JmqTnB9Lb8b0WoMyxINXnvjIpkN0FdeCA2m9L0=
Date:   Thu, 16 Jun 2022 19:12:18 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-a-memory-failure-reviewer.patch removed from -mm tree
Message-Id: <20220617021218.C6E0BC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add Miaohe Lin as a memory-failure reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-a-memory-failure-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: MAINTAINERS: add Miaohe Lin as a memory-failure reviewer
Date: Tue, 7 Jun 2022 22:51:35 +0800

I have been focusing on mm for the past two years.  e.g.  fixing bugs,
cleaning up the code and reviewing.  I would like to help maintainers and
people working on memory-failure by reviewing their work.

Let me be Cc'd on patches related to memory-failure.

Link: https://lkml.kernel.org/r/20220607145135.38670-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memory-failure-reviewer
+++ a/MAINTAINERS
@@ -9132,6 +9132,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Naoya Horiguchi <naoya.horiguchi@nec.com>
+R:	Miaohe Lin <linmiaohe@huawei.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

