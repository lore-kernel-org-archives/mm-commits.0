Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FFBC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B435464F37
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhCOVJw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhCOVJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCEA64E13;
        Mon, 15 Mar 2021 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615842580;
        bh=VedvKNO5OHLxUQq1sKq/kcvplhH9yZGrj3nTiIaghmk=;
        h=Date:From:To:Subject:From;
        b=GFV2YE+4kJWhqdfq7OyB17YtBGYAWU0oBLrBz9bwYRL/Uyu559PiT47s1Yr24IuWE
         9N3AZibYKYYEgvaZ2d4b1cvHQwrR8UVsbuCh0+1XFNLtze8pd37VcCWKoqrnb25AZ8
         AecFIH4b42TQjRAdvVX8IlrALwHBEcQ+2X/T5dTU=
Date:   Mon, 15 Mar 2021 14:09:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mrtoastcheng@gmail.com
Subject:  + lib-fix-typo-in-function-description.patch added to -mm
 tree
Message-ID: <20210315210939.wZne5bAnG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_sort.c: fix typo in function description
has been added to the -mm tree.  Its filename is
     lib-fix-typo-in-function-description.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-fix-typo-in-function-description.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-typo-in-function-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ToastC <mrtoastcheng@gmail.com>
Subject: lib/list_sort.c: fix typo in function description

Replace beautiully with beautifully

Link: https://lkml.kernel.org/r/20210315090633.9759-1-mrtoastcheng@gmail.com
Signed-off-by: ShihCheng Tu <mrtoastcheng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/list_sort.c~lib-fix-typo-in-function-description
+++ a/lib/list_sort.c
@@ -140,7 +140,7 @@ static void merge_final(void *priv, cmp_
  *
  *
  * The merging is controlled by "count", the number of elements in the
- * pending lists.  This is beautiully simple code, but rather subtle.
+ * pending lists.  This is beautifully simple code, but rather subtle.
  *
  * Each time we increment "count", we set one bit (bit k) and clear
  * bits k-1 .. 0.  Each time this happens (except the very first time
_

Patches currently in -mm which might be from mrtoastcheng@gmail.com are

lib-fix-typo-in-function-description.patch

