Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6E0C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 245242065C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgLOCNM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbgLOCNF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:13:05 -0500
Date:   Mon, 14 Dec 2020 18:12:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998344;
        bh=B1ercEv6VnRV592JZyzw90hl2DiFzCpV/7zDDMCIDnM=;
        h=From:To:Subject:From;
        b=WjfGUmRaG0ZFkll0iFws4kAqXjgJH/iCUVj+QHkcJMgY+kGVAMseRoCSIgDfLWY6f
         Sd0kvrWfC5k4GCz7HCoyxtWT9hFI56zP4dA7UQCM5HtGLI+RZxZiC1T1lm3o2Cff5D
         B/7DJE2+eXLQTPT7ppHLifIlxYomxq2Sy/6jfyGs=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, georgi.djakov@linaro.org, lmark@codeaurora.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-page_owner-record-timestamp-and-pid-v3.patch removed from -mm tree
Message-ID: <20201215021224.d01ILvql6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-record-timestamp-and-pid-v3
has been removed from the -mm tree.  Its filename was
     mm-page_owner-record-timestamp-and-pid-v3.patch

This patch was dropped because it was folded into mm-page_owner-record-timestamp-and-pid.patch

------------------------------------------------------
From: Liam Mark <lmark@codeaurora.org>
Subject: mm-page_owner-record-timestamp-and-pid-v3

- Fix the warnings in the documentation (reported in linux-next) and make
  Sphinx happy:
  Documentation/vm/page_owner.rst:44: WARNING: Literal block ends without a blank line; unexpected unindent.
  Documentation/vm/page_owner.rst:49: WARNING: Literal block ends without a blank line; unexpected unindent.

Link: https://lkml.kernel.org/r/20201210160357.27779-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~mm-page_owner-record-timestamp-and-pid-v3
+++ a/Documentation/vm/page_owner.rst
@@ -41,12 +41,12 @@ size change due to this facility.
 - Without page owner::
 
    text    data     bss     dec     hex filename
-  48392    2333     644   51369    c8a9 mm/page_alloc.o
+   48392   2333     644   51369    c8a9 mm/page_alloc.o
 
 - With page owner::
 
    text    data     bss     dec     hex filename
-  48800    2445     644   51889    cab1 mm/page_alloc.o
+   48800   2445     644   51889    cab1 mm/page_alloc.o
    6574     108      29    6711    1a37 mm/page_owner.o
    1025       8       8    1041     411 mm/page_ext.o
 
_

Patches currently in -mm which might be from lmark@codeaurora.org are

mm-page_owner-record-timestamp-and-pid.patch

