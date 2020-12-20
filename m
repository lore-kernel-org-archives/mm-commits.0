Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875B6C3527A
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B2523B5D
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgLTC66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgLTC65 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:57 -0500
Date:   Sat, 19 Dec 2020 18:58:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433082;
        bh=4csudZaDQ1CHi/JILpDnPXwEzDLpBF9Yr7AT0NI/cBk=;
        h=From:To:Subject:From;
        b=tel0paWcX5SRw+efiuk3B+jnmhsWWdv9Fep/l5PdUzJf6dqgvI8/0SCaZoQHixHIC
         1pSdubqtdMWwi0JZTjMCTlQpO1HdayVjRrOrDzGZZBf7uxgHAlQqaFYJeod/2CGh5X
         6tODqidJoCflBLtAfUVyQWV4yLJ9mQ7ook75oB88=
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-fix-spelling-mistake-in-kconfig-whats-whats.patch removed from -mm tree
Message-ID: <20201220025802.HjraDE9iX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: fix spelling mistake "whats" -> "what's"
has been removed from the -mm tree.  Its filename was
     mm-fix-spelling-mistake-in-kconfig-whats-whats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/Kconfig: fix spelling mistake "whats" -> "what's"

There is a spelling mistake in the Kconfig help text. Fix it.

Link: https://lkml.kernel.org/r/20201217172717.58203-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-fix-spelling-mistake-in-kconfig-whats-whats
+++ a/mm/Kconfig
@@ -713,7 +713,7 @@ config ZSMALLOC_STAT
 	select DEBUG_FS
 	help
 	  This option enables code in the zsmalloc to collect various
-	  statistics about whats happening in zsmalloc and exports that
+	  statistics about what's happening in zsmalloc and exports that
 	  information to userspace via debugfs.
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from colin.king@canonical.com are


