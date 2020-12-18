Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32650C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F3423B88
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgLRWFs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgLRWFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:48 -0500
Date:   Fri, 18 Dec 2020 14:05:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329132;
        bh=u3y600jJ/ZseY1CtgA2tFCx7R9Smf+pM46eTlF7Qd4Q=;
        h=From:To:Subject:In-Reply-To:From;
        b=v9VpoY5+qmSl5nW7V5YHQLX26Wwdh6XzyMfZcyQGuRJ8QWikzXBGviYhVHrOQD3g4
         UFtJI5FYrP6uAtHoJrz4GsHCaocrT9N0ETIH2Arf2WwgHiIvvYjCqvW8tOxx9GosaV
         qkc10Nz9KP/bP9OTP+VCV/tlxQQNfapKgskn+HJo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 74/78] mm/Kconfig: fix spelling mistake "whats" ->
 "what's"
Message-ID: <20201218220532.m4psI7_CA%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
