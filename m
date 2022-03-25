Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA77CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244446AbiCYAac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244440AbiCYAac (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:30:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DC152E16
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F27B826B9
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78356C340EC;
        Fri, 25 Mar 2022 00:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168136;
        bh=NMjgY7MMRE5OKIzGPhqg8YSkc9r/5PuljWtKH/cld6M=;
        h=Date:To:From:Subject:From;
        b=i2/7oXCuvwR4a/Y1ZZRrKth7zSTujyduf0zftQw2eAOWmjN52WCULg8+uGlXn7FaA
         0X9btYwNjDOh9TL57t9kH+AJXxU9t8J5qj3C+nu1YokK9ojApZBAPYeXRluQPggnyc
         vVwtKlIVIJENRXebLY8NKX6xEWpH71JgGcUBgNE0=
Date:   Thu, 24 Mar 2022 17:28:55 -0700
To:     mm-commits@vger.kernel.org, zhangshengju@cmss.chinamobile.com,
        weizhenliang@huawei.com, vbabka@suse.cz,
        tangbin@cmss.chinamobile.com, nixiaoming@huawei.com,
        lmark@codeaurora.org, hanshenghong2019@email.szu.edu.cn,
        georgi.djakov@linaro.org, corbet@lwn.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-vm-page_ownerrst-update-the-documentation-fix.patch removed from -mm tree
Message-Id: <20220325002856.78356C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation-vm-page_ownerrst-update-the-documentation-fix
has been removed from the -mm tree.  Its filename was
     documentation-vm-page_ownerrst-update-the-documentation-fix.patch

This patch was dropped because it was folded into documentation-vm-page_ownerrst-update-the-documentation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: documentation-vm-page_ownerrst-update-the-documentation-fix

small grammatical tweaks

Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/vm/page_owner.rst~documentation-vm-page_ownerrst-update-the-documentation-fix
+++ a/Documentation/vm/page_owner.rst
@@ -107,17 +107,17 @@ Usage
 	 // Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
-   If you want to sort by the pages nums of buf, use the ``-m`` parameter.
-   The detail parameters are shown as follows:
+   If you want to sort by the page nums of buf, use the ``-m`` parameter.
+   The detailed parameters are:
 
    fundamental function:
 
 	Sort:
-		-a		Sort by memory allocate time.
+		-a		Sort by memory allocation time.
 		-m		Sort by total memory.
 		-p		Sort by pid.
 		-r		Sort by memory release time.
-		-s		Sort by the stack trace.
+		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
    additional function:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

documentation-vm-page_ownerrst-update-the-documentation.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

