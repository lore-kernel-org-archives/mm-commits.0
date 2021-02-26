Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6323AC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259F364F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZAvy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhBZAvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:51:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DCB664F21;
        Fri, 26 Feb 2021 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300672;
        bh=de47eTfYXQonWzF4f9krsfs/1D3Z1th6H7aO7HWZrjI=;
        h=Date:From:To:Subject:From;
        b=fji3t+olj5+PhH6S7Yts71ERLSx5tRE1H2WQpu5hTQ3eOJY1/+BildN1CH1mkTIjQ
         shnzxrSjbGXXSmh4Oxtf2aVGyFo0IzCr3DhGyVXuMmt0H7zy7wXn6xShTD/zfLv9hD
         CY5SdUzg1785LZ5XyElHWUlsef0jQqnw6PM+T+pc=
Date:   Thu, 25 Feb 2021 16:51:11 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        neilb@suse.de, willy@infradead.org
Subject:  [folded-merged]
 seq_file-document-how-per-entry-resources-are-managed-fix.patch removed
 from -mm tree
Message-ID: <20210226005111.jxmBJNpth%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file-document-how-per-entry-resources-are-managed-fix
has been removed from the -mm tree.  Its filename was
     seq_file-document-how-per-entry-resources-are-managed-fix.patch

This patch was dropped because it was folded into seq_file-document-how-per-entry-resources-are-managed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_file-document-how-per-entry-resources-are-managed-fix

fix typo, per Willy

Cc: NeilBrown <neilb@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/seq_file.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/seq_file.rst~seq_file-document-how-per-entry-resources-are-managed-fix
+++ a/Documentation/filesystems/seq_file.rst
@@ -218,7 +218,7 @@ is a reasonable thing to do. The seq_fil
 other locks while the iterator is active.
 
 The iterater value returned by start() or next() is guaranteed to be
-passed to a subsequenct next() or stop() call.  This allows resources
+passed to a subsequent next() or stop() call.  This allows resources
 such as locks that were taken to be reliably released.  There is *no*
 guarantee that the iterator will be passed to show(), though in practice
 it often will be.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

seq_file-document-how-per-entry-resources-are-managed.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

