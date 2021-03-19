Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E75AC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A556197B
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCSWuJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhCSWuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 18:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B910A61970;
        Fri, 19 Mar 2021 22:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616194206;
        bh=4JPayAoMna5fbW5hhfp56oBH/C8DJ9vFAN+p6izXfRA=;
        h=Date:From:To:Subject:From;
        b=jxm8Ua7T7jsjtmjJ2sqk7l//6nDwKMS+WO4tgtpAovcFBQSLDKttel/7Enk5rB1tb
         4KRiLAQ9/bFmPW2xr5oYE3Sc/GnNq+xvNRGl7Mu9YvzG3k+FenFXSDUe42QLod0/V5
         UvQlQe6EtwVjCHphoUnKJQZpcbZLs+Cstm+crFSA=
Date:   Fri, 19 Mar 2021 15:50:06 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, mm-commits@vger.kernel.org
Subject:  + mailmap-update-andrey-konovalovs-email-address.patch
 added to -mm tree
Message-ID: <20210319225006.VmTbQRwft%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Andrey Konovalov's email address
has been added to the -mm tree.  Its filename is
     mailmap-update-andrey-konovalovs-email-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-andrey-konovalovs-email-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-andrey-konovalovs-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mailmap: update Andrey Konovalov's email address

Use my personal email, the @google.com one will stop functioning soon.

Link: https://lkml.kernel.org/r/ead0e9c32a2f70e0bde6f63b3b9470e0ef13d2ee.1616107969.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-andrey-konovalovs-email-address
+++ a/.mailmap
@@ -36,6 +36,7 @@ Andrew Morton <akpm@linux-foundation.org
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andrey Konovalov <andreyknvl@gmail.com> <andreyknvl@google.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <aryabinin@virtuozzo.com>
 Andy Adamson <andros@citi.umich.edu>
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
mailmap-update-andrey-konovalovs-email-address.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

