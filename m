Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2053C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 06:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BA4613F2
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 06:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhDVGDo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhDVGDo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 02:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB90F61417;
        Thu, 22 Apr 2021 06:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619071390;
        bh=VOP49FI+wQCmzVPuIfenSc2yv5eRJyBAl72zKt7jjb8=;
        h=Date:From:To:Subject:From;
        b=Xv+xrR49APTCqhHaGcHClOAANqRKKT1EWf81eHWdl1vJZ2jHFsB/2nXyfhGux1XXD
         w5/A/+dJY3j6BU3Tgh7Wgkgyrssgi8HydIfuHaQ3SwSVDITsF0X6pclevwHdgswOls
         O5I+nSUJ0s/EK7dtnytWfssxZ9IU8MQC2QYyPvXg=
Date:   Wed, 21 Apr 2021 23:03:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + cifsd-is-broken.patch added to -mm tree
Message-ID: <20210422060309.XDqWjvzZS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cifsd-is-broken
has been added to the -mm tree.  Its filename is
     cifsd-is-broken.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cifsd-is-broken.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cifsd-is-broken.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cifsd-is-broken

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifsd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifsd/Kconfig~cifsd-is-broken
+++ a/fs/cifsd/Kconfig
@@ -3,6 +3,7 @@ config SMB_SERVER
 	depends on INET
 	depends on MULTIUSER
 	depends on FILE_LOCKING
+	depends on BROKEN
 	select NLS
 	select NLS_UTF8
 	select CRYPTO
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

