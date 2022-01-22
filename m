Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C98C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiAVB2c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:28:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiAVB2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:28:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA52DB8215E
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F1EC340E3;
        Sat, 22 Jan 2022 01:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814909;
        bh=dOAdnqhApkgQwsq/uvA2Zd5xMYEPzKbrcmjYqk+b+oM=;
        h=Date:From:To:Subject:From;
        b=oXMf4TnU0N4F9cssKNq9lGai25jALY04IEAFbJlHnh/e0myKvoGGZSGKpMTAraabT
         tJNWPKDouDw/my0kVqC6IVwOFaBzN6ZkIM8YaJNCtTw8wH1/aLKCjeH+wyR+naFjFH
         UpIKvUEvgRby6jZuiHGP2PFaJMlogBydwXwvMhDM=
Date:   Fri, 21 Jan 2022 17:28:28 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, sfr@canb.auug.org.au,
        willy@infradead.org
Subject:  [folded-merged] mm-simplify-try_to_unuse-fix.patch
 removed from -mm tree
Message-ID: <20220122012828.qlmW5sCRD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-try_to_unuse-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-try_to_unuse-fix.patch

This patch was dropped because it was folded into mm-simplify-try_to_unuse.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-try_to_unuse-fix

fix shmem_unuse() stub, per Matthew

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-simplify-try_to_unuse-fix
+++ a/mm/shmem.c
@@ -3995,7 +3995,7 @@ int __init shmem_init(void)
 	return 0;
 }
 
-int shmem_unuse(unsigned int type, unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-simplify-try_to_unuse.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

