Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E270C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 291FC22CB2
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbhAXFCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbhAXFCn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D9522D49;
        Sun, 24 Jan 2021 05:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464542;
        bh=43FMcw2joV7XpmY/Y4d6N7xUPJ5S6LqZyTn8vL/asZs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yYsxEqUCWz1Exh24a9vLClja/VRarj3avYazm6gsxDQUF5eFWYvGzxlgdFoZ9ugUd
         0f5KesNXUYecEo2YNXvDRivFDRGib7QurIM8bDaLFGRskqd+WkkuGfmcnNLQu+Y6G1
         Tm3ER+8xI4ojiGL7O3wISsdDzmt7cv7nyE8TIuAA=
Date:   Sat, 23 Jan 2021 21:02:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 19/19] MAINTAINERS: add a couple more files to the
 Clang/LLVM section
Message-ID: <20210124050221.gQPny1Yxo%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Subject: MAINTAINERS: add a couple more files to the Clang/LLVM section

The K: entry should ensure that Nick and I always get CC'd on patches that
touch these files but it is better to be explicit rather than implicit.

Link: https://lkml.kernel.org/r/20210114004059.2129921-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-a-couple-more-files-to-the-clang-llvm-section
+++ a/MAINTAINERS
@@ -4311,7 +4311,9 @@ W:	https://clangbuiltlinux.github.io/
 B:	https://github.com/ClangBuiltLinux/linux/issues
 C:	irc://chat.freenode.net/clangbuiltlinux
 F:	Documentation/kbuild/llvm.rst
+F:	include/linux/compiler-clang.h
 F:	scripts/clang-tools/
+F:	scripts/clang-version.sh
 F:	scripts/lld-version.sh
 K:	\b(?i:clang|llvm)\b
 
_
