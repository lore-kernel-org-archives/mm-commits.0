Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7C8C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE7A64F21
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhB0CdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbhB0Ccm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7086A64F4B;
        Sat, 27 Feb 2021 02:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393132;
        bh=Lemc1XIsdGoftppBlBq0xP3R2hY1x/rqEq/J4bBnIyw=;
        h=Date:From:To:Subject:From;
        b=qcED39Hi8mH+Foey4FMVsL8tgeZktZc4azJHat3inZqfW2xva+4/D3MBeSdZJngvp
         8Jv1rkQ8tQFuFRNAHL8XWKMhLGSiMZV+JO3l2YPqA1shAnIf0UpcQq72F9V3TC62Cu
         qj3ga04ClnGKjrr+lyMkjrM29E+ts9Do67ZX8rIE=
Date:   Fri, 26 Feb 2021 18:32:12 -0800
From:   akpm@linux-foundation.org
To:     geert+renesas@glider.be, mm-commits@vger.kernel.org
Subject:  [merged] bitops-spelling-s-synomyn-synonym.patch removed
 from -mm tree
Message-ID: <20210227023212.k_FTevnmy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitops.h: spelling s/synomyn/synonym/
has been removed from the -mm tree.  Its filename was
     bitops-spelling-s-synomyn-synonym.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


