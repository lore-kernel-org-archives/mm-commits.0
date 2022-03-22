Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38338C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiCVTRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiCVTRO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:17:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4A3BF6F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C378EB81D59
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64640C340EC;
        Tue, 22 Mar 2022 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976543;
        bh=CbSkLmQWSxlFm2Ke2+20sRvP+fLYmMaSZ9562Q6fcx4=;
        h=Date:To:From:Subject:From;
        b=bBIeZZJKd0TZ/+Plkk2bAOOdo1WkmfocN5cvMvzMaSoflj/uoag6I1N0qk0Tebhod
         p6cvZ/rEmj2p11w33+Gz0EQeE8VdmZWeNsve/q3lpD8S8l9X6Pmj4Ubpt9hV5hL5XK
         aHJrkWBRDtgz+H/7DBkRqaFLwSAtjjD1+R38+2W0=
Date:   Tue, 22 Mar 2022 12:15:42 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch removed from -mm tree
Message-Id: <20220322191543.64640C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix

remove the comment altogether, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix
+++ a/mm/memory_hotplug.c
@@ -295,9 +295,6 @@ struct page *pfn_to_online_page(unsigned
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
-/*
- * Reasonably generic function for adding memory.
- */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

