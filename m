Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57021C43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E7B064F27
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhBZBXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhBZBWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3711964F3F;
        Fri, 26 Feb 2021 01:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302498;
        bh=o7RZoYl4MsKFnkBMgMl6UyxRQsLI5RyaqpNlKKD92p8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CRHuLs/0jlhAxVW2ZzDVapPLebiiDHGMObyso5T/kgpKQSEKSLBBmw/Gy0rzsnTAK
         FmE5qCU2vKNjWvJVaj4sn3wXa0zPiD8CYSy1tG88/ZsL8KsTAudmW3MChhzo0b04EE
         qfR2Twd8S2ypb1XyTw5ew1xludlrGGnW+iPXJuCs=
Date:   Thu, 25 Feb 2021 17:21:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, geert+renesas@glider.be,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 098/118] include/linux/bitops.h: spelling
 s/synomyn/synonym/
Message-ID: <20210226012137.TP8MGTliP%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: include/linux/bitops.h: spelling s/synomyn/synonym/

Fix a misspelling of "synonym".

Link: https://lkml.kernel.org/r/20210108105305.2028120-1-geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/bitops.h~bitops-spelling-s-synomyn-synonym
+++ a/include/linux/bitops.h
@@ -214,7 +214,7 @@ static inline int get_count_order_long(u
  * __ffs64 - find first set bit in a 64 bit word
  * @word: The 64 bit word
  *
- * On 64 bit arches this is a synomyn for __ffs
+ * On 64 bit arches this is a synonym for __ffs
  * The result is not defined if no bits are set, so check that @word
  * is non-zero before calling this.
  */
_
