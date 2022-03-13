Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B20C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 13 Mar 2022 02:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiCMC0V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Mar 2022 21:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiCMC0V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Mar 2022 21:26:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE66A73057
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 18:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B3F960E1F
        for <mm-commits@vger.kernel.org>; Sun, 13 Mar 2022 02:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E387C340EB;
        Sun, 13 Mar 2022 02:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647138313;
        bh=xH+MZK/ZZ/n9F0GGClnBNU1MK8HAwwHSQlm+nSV2VGI=;
        h=Date:To:From:Subject:From;
        b=XLU9u3GCSNglVe//+32J3Am1PSlLdn1B2E1CV+J0u4S2C37c8EzisKSgw8oLee6CQ
         //fuc/AQWw7rUbmPb3cr2xn9jjDGh120mVLxo+xQ+aXDih8jcmPpvfo1flZKcnBUH8
         nv/pGHvlgEugB2JilAfrtCey2sNx0DfptzeO0nuk=
Date:   Sat, 12 Mar 2022 18:25:12 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] a.patch removed from -mm tree
Message-Id: <20220313022513.8E387C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     a.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/open.c~a
+++ a/fs/open.c
@@ -1429,3 +1429,4 @@ int stream_open(struct inode *inode, str
 }
 
 EXPORT_SYMBOL(stream_open);
+Sat Mar 12 06:24:32 PM PST 2022
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
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

