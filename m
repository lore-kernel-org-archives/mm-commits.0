Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FEDC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 558AF61132
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhDBA1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBA1b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D179B61139;
        Fri,  2 Apr 2021 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617323248;
        bh=bxR50pr9t3JleUcxBz0N5h4h6WQdQltlkMN6/qtXR/4=;
        h=Date:From:To:Subject:From;
        b=Mqd2DKv3mQqRQKLbPA4Q7VS128qrpcx1uW6IHUGFxp3TUQjALKWKqLpOCJKVgF/2T
         nl1ntcYIqVjaBtbp+HF3forJm6v2bIdN/J2dLp0Obv+fl8BzUfOV1MjB+/9ZOi7eii
         CUa09KEloDduOsTlD8kFKFAFqjQfq8qV+GtC65Yc=
Date:   Thu, 01 Apr 2021 17:27:27 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joe@perches.com, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, wanjiabing@vivo.com
Subject:  +
 scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
 added to -mm tree
Message-ID: <20210402002727.2KMXRZnHL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-a-new-script-for-checking-duplicate-struct-declaration-fix
has been added to the -mm tree.  Its filename is
     scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch

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
Subject: scripts-a-new-script-for-checking-duplicate-struct-declaration-fix

fix usage message, grammar

Cc: Joe Perches <joe@perches.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkdeclares.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkdeclares.pl~scripts-a-new-script-for-checking-duplicate-struct-declaration-fix
+++ a/scripts/checkdeclares.pl
@@ -15,8 +15,8 @@
 use strict;
 
 sub usage {
-	print "Usage: checkdeclares.pl \n";
-	print "We just warn of struct declaration duplicates\n";
+	print "Usage: checkdeclares.pl file1.h ...\n";
+	print "Warns of struct declaration duplicates\n";
 	exit 1;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

