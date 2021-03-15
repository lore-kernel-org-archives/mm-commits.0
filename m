Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4849DC4332B
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E5664F56
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 21:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCOVtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhCOVtN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 17:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6D4B64DE2;
        Mon, 15 Mar 2021 21:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615844953;
        bh=G6Uhx3iXbojjcVxxYrhrpA33vzHwjdt4n75q9pu9bmA=;
        h=Date:From:To:Subject:From;
        b=u/aNDsIWPSVU2C4b5e40P8nGH0/vLv4dKP5KzR9kV5aMcD3XgSvTZ6Z6hs4NMNYif
         VHO6KWThEXLedb/gyS2P+ko6Eannp31psTQF/njqxe2QaqABKrt68ATIySqKMR/maH
         Ecr8tEpqM10KHzcy6cE1kyr4+FrKJPb1fYUzvBVY=
Date:   Mon, 15 Mar 2021 14:49:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  +
 ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch added to -mm
 tree
Message-ID: <20210315214912.46qJ6J27C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/include/asm/pgtable.h: minor typo fixes
has been added to the -mm tree.  Its filename is
     ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
lib-fix-a-typo-in-the-file-bchc.patch

