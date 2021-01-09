Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7380C4332D
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9617023A75
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbhAIAzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbhAIAzZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 19:55:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9296E23A75;
        Sat,  9 Jan 2021 00:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610153684;
        bh=QpkrZuj01BsXv0AyVA3A4fquEqfICh10c51Tqp8UpIw=;
        h=Date:From:To:Subject:From;
        b=I+AtTflwWzmgqa+XvdVMv2KC9khXhxJaKdrozEildvECkJmU60zNpsqLM9kuv1vEQ
         YIZbGPyBSSEczjQEg9viLEolzMoL5mWDVeaZjGGd/TH2dIUQX8hCuOL5VkwzHwV0e+
         lQ6vrTulBVBPDFG130VcAUwptCdWlHUTH/Bu54UA=
Date:   Fri, 08 Jan 2021 16:54:44 -0800
From:   akpm@linux-foundation.org
To:     geert+renesas@glider.be, mm-commits@vger.kernel.org
Subject:  + bitops-spelling-s-synomyn-synonym.patch added to -mm
 tree
Message-ID: <20210109005444.54aqHfKeO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitops.h: spelling s/synomyn/synonym/
has been added to the -mm tree.  Its filename is
     bitops-spelling-s-synomyn-synonym.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitops-spelling-s-synomyn-synonym.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitops-spelling-s-synomyn-synonym.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from geert+renesas@glider.be are

bitops-spelling-s-synomyn-synonym.patch

