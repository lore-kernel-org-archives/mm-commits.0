Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0134C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0BE061A10
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhCXXG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhCXXG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B137561A10;
        Wed, 24 Mar 2021 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616627185;
        bh=zQOBUaxyuKpmYxtDhQ9qvkVUTtep+j5hwHGBpUYZ34s=;
        h=Date:From:To:Subject:From;
        b=0KHsYP7503RPMeptyA8iUU+5ZNLT4v2Q0iriDfFjGkXbpXbHtXBrfCOUnIEKGPM6+
         qD9Dxpsi3YrRjzoTjDVnguwBZoWIXsRdmcIkFb/oyDmAqyJ8L9pK9veSlOOxaRA6Bz
         i7b6nE8xeBLhl0IOOvA2bYZz4HwZ2dZ6OGhQ0Ob0=
Date:   Wed, 24 Mar 2021 16:06:25 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhouchuangao@vivo.com
Subject:  + mm-page_alloc-duplicate-include-linux-vmalloch.patch
 added to -mm tree
Message-ID: <20210324230625.D5vw3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: duplicate include linux/vmalloc.h
has been added to the -mm tree.  Its filename is
     mm-page_alloc-duplicate-include-linux-vmalloch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-duplicate-include-linux-vmalloch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-duplicate-include-linux-vmalloch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhouchuangao <zhouchuangao@vivo.com>
Subject: mm/page_alloc: duplicate include linux/vmalloc.h

linux/vmalloc.h is repeatedly in the file page_alloc.c

Link: https://lkml.kernel.org/r/1616468751-80656-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-duplicate-include-linux-vmalloch
+++ a/mm/page_alloc.c
@@ -72,8 +72,6 @@
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
 #include <linux/buffer_head.h>
-#include <linux/vmalloc.h>
-
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are

mm-page_alloc-duplicate-include-linux-vmalloch.patch
proc-sysctl-fix-function-name-error-in-comments.patch
umh-fix-some-spelling-mistakes.patch

