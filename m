Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F2FC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6CA6115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhIHC6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347404AbhIHC6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C34C6115A;
        Wed,  8 Sep 2021 02:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069859;
        bh=uHDrcBeKbYPDgYSHH0Ro2GKbcIYONG5FTKtGjEhQvgo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YXtXgEz82DwZeBr4Nqzokmnujk4RPoUXDqH+2sF5ZEdpnpGkbuvZya8Y35x5t71UF
         U4qHPixaBeJi1iURI19i1bkxw3/3yxpARbZmR/xJK1ZxCHW/Ex1uNIsNSIvpL34mIJ
         N1RurV1gh5UtmHm+z9sbeyPkWLLQR94Pm53zLM4A=
Date:   Tue, 07 Sep 2021 19:57:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 082/147] arch: Kconfig: fix spelling mistake
 "seperate" -> "separate"
Message-ID: <20210908025738.dAHyPzJNr%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: arch: Kconfig: fix spelling mistake "seperate" -> "separate"

Threre is a spelling mistake in the Kconfig text. Fix it.

Link: https://lkml.kernel.org/r/20210704095207.37342-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig~arch-kconfig-fix-spelling-mistake-seperate-separate
+++ a/arch/Kconfig
@@ -886,7 +886,7 @@ config HAVE_SOFTIRQ_ON_OWN_STACK
 	bool
 	help
 	  Architecture provides a function to run __do_softirq() on a
-	  seperate stack.
+	  separate stack.
 
 config PGTABLE_LEVELS
 	int
_
