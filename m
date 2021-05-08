Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C67C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D866D613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWkB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8582E613E8;
        Sat,  8 May 2021 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513538;
        bh=9sXkWvSsJ62bPMtuHXic8peQrVqPExMBtR0ExodlP9Q=;
        h=Date:From:To:Subject:From;
        b=o1qUmZjf6OKpEFHKQxj4aGxrYMc9ePBV8T+67LmDd9bHg8nH0G6XZo6ptI7ubtvlF
         k69qpMFLQafIFFkZjisMM+Fa7SvlG3cUlLEYlCLPM/BTlN/Wf8VftMH+AMEvgGZq9J
         s7WvQS5tctcwfvq++6ALgRl8KmVRmlx/zLESe8jk=
Date:   Sat, 08 May 2021 15:38:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  [merged]
 ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch removed from
 -mm tree
Message-ID: <20210508223858.bti4Z-Tbr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/include/asm/pgtable.h: minor typo fixes
has been removed from the -mm tree.  Its filename was
     ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: arch/ia64/include/asm/pgtable.h: minor typo fixes

s/migraton/migration/

Link: https://lkml.kernel.org/r/20210313045519.9310-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/include/asm/pgtable.h~ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh
+++ a/arch/ia64/include/asm/pgtable.h
@@ -328,7 +328,7 @@ extern void __ia64_sync_icache_dcache(pt
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
 	/* page is present && page is user  && page is executable
-	 * && (page swapin or new page or page migraton
+	 * && (page swapin or new page or page migration
 	 *	|| copy_on_write with page copying.)
 	 */
 	if (pte_present_exec_user(pteval) &&
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are


