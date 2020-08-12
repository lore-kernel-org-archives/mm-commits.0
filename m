Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E600BC433E4
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34B920774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266214;
	bh=Ssu+8FSQjrsgrpWX39lhG8cT63fyA1gnad3JNo50kCg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jGuAPR5e9qw3L/sRHjry7FtvFHMzaVUUCF+L9QLl8WkeV4PnzEeqfrnmMvaKz/7Q9
	 AwxhpcZhxylpWBnuifq5TW46QLRITKB7MdVLeTGM4aXHLcsNrFWkSF7GrA161EvLsO
	 pqrciYItOtHjgxk4gw9TfPuiCbYhrKDjixQCqmhI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHLVDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHLVDd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7810420B1F;
        Wed, 12 Aug 2020 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266213;
        bh=Ssu+8FSQjrsgrpWX39lhG8cT63fyA1gnad3JNo50kCg=;
        h=Date:From:To:Subject:From;
        b=CshTMXp3KflwDDIY8Rt1LDZHu49PqSjjup44vXXzypthJY5icM16w1iqwmfAjsvUD
         kQEbwuWsVRZ8qsNiuTNKyTARA2Q28zowHUrZ/gNM/dyrcvP/aKDR+x226EQTgh3tMc
         4VNkuRLa3kyPf463haIjyvN0jr1Mf/c38SrUCezE=
Date:   Wed, 12 Aug 2020 14:03:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        rdunlap@infradead.org
Subject:  [merged]
 clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch removed
 from -mm tree
Message-ID: <20200812210333.M768kQHbJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-clang.h: drop duplicated word in a comment
has been removed from the -mm tree.  Its filename was
     clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/compiler-clang.h: drop duplicated word in a comment

Drop the doubled word "the" in a comment.

Link: http://lkml.kernel.org/r/6a18c301-3505-742f-4dd7-0f38d0e537b9@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment
+++ a/include/linux/compiler-clang.h
@@ -40,7 +40,7 @@
 #endif
 
 /*
- * Not all versions of clang implement the the type-generic versions
+ * Not all versions of clang implement the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
  * __has_builtin allowing us to avoid awkward version
  * checks. Unfortunately, we don't know which version of gcc clang
_

Patches currently in -mm which might be from rdunlap@infradead.org are


