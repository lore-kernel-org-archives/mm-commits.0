Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2EAC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFEAE224B2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgLWUmR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgLWUmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:42:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB5E0223DB;
        Wed, 23 Dec 2020 20:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608756096;
        bh=muq88Bbv0oODDwyGvWxK5+dcN7hZKseLqiVpoXTDkNg=;
        h=Date:From:To:Subject:From;
        b=ckszhW42cCdw8BRj9rewAC/eMIYBX1g2y6Hbowj8L5SlEphmr1COpqXUfywsOdLI6
         d/x/tC4j9jJh/ob5JTHocJkpdmRu8z6hd7ORRirplv04TEPlhvEPJU6JXrPph90hbk
         NX00bAnaRm/bLTF2YxBhDpbVA69cM5Gi/X/D8iDA=
Date:   Wed, 23 Dec 2020 12:41:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        alex.shi@linux.alibaba.com, akpm@linux-foundation.org
Subject:  [obsolete]
 mm-add-prototype-for-__add_to_page_cache_locked-fix.patch removed from -mm
 tree
Message-ID: <20201223204136.5AZoJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-prototype-for-__add_to_page_cache_locked-fix
has been removed from the -mm tree.  Its filename was
     mm-add-prototype-for-__add_to_page_cache_locked-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-prototype-for-__add_to_page_cache_locked-fix

tweak comment grammar

Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-add-prototype-for-__add_to_page_cache_locked-fix
+++ a/include/linux/mm.h
@@ -217,8 +217,8 @@ int overcommit_kbytes_handler(struct ctl
 int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 /*
- * Any attempt to mark this function as static leads to build failure
- * for few architectures. Adding a prototype to silence gcc warning.
+ * Marking this function as static leads to build failures for a few
+ * architectures.  The prototype silences a gcc warning.
  */
 int __add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp, void **shadowp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

