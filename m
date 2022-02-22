Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFBDC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbiBVChR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:37:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiBVChP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:37:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D9025C66
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF9BBB81754
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA385C340E9;
        Tue, 22 Feb 2022 02:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645497408;
        bh=y+1ui4VN3qfwqImJrCXNUW0lvYFBWIXsDmXwfruSj4k=;
        h=Date:To:From:Subject:From;
        b=oY44kisQel21/hHhxKDwSlSdAFk7UGt8L3YgQTnQ/LaKSivlHEw0QQ/nl3IL3QzhK
         3TGLJmAENcstrn/k+Guh0LI4R00HEFrjDjk0mNp4CBF0zYX93DvjppJhS3wmj2YWRt
         EfgM1t1w32UOS/JmSEio3emMhHeeQantD6r3xzLg=
Date:   Mon, 21 Feb 2022 18:36:48 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rdunlap@infradead.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch removed from -mm tree
Message-Id: <20220222023648.AA385C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix
has been removed from the -mm tree.  Its filename was
     numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch

This patch was dropped because it was folded into numa-balancing-optimize-page-placement-for-memory-tiering-system.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix

s/,/::/ per Randy

Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -597,7 +597,7 @@ numa_balancing
 
 Enables/disables and configures automatic page fault based NUMA memory
 balancing.  Memory is moved automatically to nodes that access it often. 
-The value to set can be the result of ORing the following,
+The value to set can be the result of ORing the following::
 
 = =================================
 0 NUMA_BALANCING_DISABLED
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

