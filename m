Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5229C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722D561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWxz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhEHWxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3F961402;
        Sat,  8 May 2021 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514373;
        bh=qT+jWOzV6vk+/NTOaWCEOSxnj7lzLaHqnT0/DSOjQO8=;
        h=Date:From:To:Subject:From;
        b=SODfHWh2ylxGdSGloHOiWVvWDVBl13WPu3n0iH2nCHvPpyospgWZGAvZB9YUG4KC/
         Seo1A8JcU/ofTBDBj39r+Ep+HMaE0ouv+DZx0JF6Jefb6RlOXhQktb9TPfaSgX5M5l
         L0qwkNXz39wPY83ZWAVHquYIeHd3FmONbObEQ470=
Date:   Sat, 08 May 2021 15:52:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mrtoastcheng@gmail.com
Subject:  [merged] lib-fix-typo-in-function-description.patch
 removed from -mm tree
Message-ID: <20210508225253.Zv4DfGRVy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_sort.c: fix typo in function description
has been removed from the -mm tree.  Its filename was
     lib-fix-typo-in-function-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -137,7 +137,7 @@ static void merge_final(void *priv, list
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


