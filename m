Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5DFC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE5F23406
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgLPRJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgLPRJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:40 -0500
Date:   Wed, 16 Dec 2020 09:08:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138522;
        bh=5vftWPu6SNBW5uEgkRE+PCry+ATGnTPZdWP6lmNHPAU=;
        h=From:To:Subject:From;
        b=WHyXBqe30enayDXORxuMyUfrcRZWmJjx2v4elcVtQYPVD9BVBdCf8IuI9edS6R4gf
         5VC5TSO4NfCMX3M/pG9B1VT0HhF7SqxydrjDHeOjTYBFGRvmGbT+Bj/JAKUmTnEgO2
         6bwf9gilRxzTdMtBZBr5U+AtDJds0HQluExCijp8=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, jianpeng.ma@intel.com,
        mm-commits@vger.kernel.org, yury.norov@gmail.com
Subject:  [merged] bitmap-remove-unused-function-declaration.patch
 removed from -mm tree
Message-ID: <20201216170842.B5ZJ2CigQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: remove unused function declaration
has been removed from the -mm tree.  Its filename was
     bitmap-remove-unused-function-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Ma, Jianpeng" <jianpeng.ma@intel.com>
Subject: bitmap: remove unused function declaration

Link: https://lkml.kernel.org/r/BN7PR11MB26097166B6B46387D8A1ABA4FDE30@BN7PR11MB2609.namprd11.prod.outlook.com
Fixes: 2afe27c718b6 ("lib/bitmap.c: bitmap_[empty,full]: remove code duplication")
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/bitmap.h~bitmap-remove-unused-function-declaration
+++ a/include/linux/bitmap.h
@@ -126,8 +126,6 @@ extern void bitmap_free(const unsigned l
  * lib/bitmap.c provides these functions:
  */
 
-extern int __bitmap_empty(const unsigned long *bitmap, unsigned int nbits);
-extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern bool __pure __bitmap_or_equal(const unsigned long *src1,
_

Patches currently in -mm which might be from jianpeng.ma@intel.com are


