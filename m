Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C29FC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0847061152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbhIHC7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHC7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA48B60E52;
        Wed,  8 Sep 2021 02:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069908;
        bh=Jk9WDHGpTuzWPDfVrOgVxNHikqxq49ybpYmH8k7mZdw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X24OYmvqNrgBPxvWXLYCPzWdQT1mFKMdb6Nm/G94810Sv3+Mfo+pkBi3EA0Hysb7a
         Rp+4j+3ZN/Bu5QmJIegsCqHQ7RHzX6fQ6vrtVfq0IIWVy9f3eTAVHD+7Kz3tQjiNx9
         x2+4V6Nm7NhgSLugqsKoY9o9OnDTR5vZZKtXye70=
Date:   Tue, 07 Sep 2021 19:58:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 097/147] Documentation/llvm: update mailing list
Message-ID: <20210908025827.eqRmlTlte%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Subject: Documentation/llvm: update mailing list

We are now at llvm@lists.linux.dev.

Link: https://lkml.kernel.org/r/20210825211823.6406-2-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/llvm.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/kbuild/llvm.rst~documentation-llvm-update-mailing-list
+++ a/Documentation/kbuild/llvm.rst
@@ -111,7 +111,8 @@ Getting Help
 ------------
 
 - `Website <https://clangbuiltlinux.github.io/>`_
-- `Mailing List <https://groups.google.com/forum/#!forum/clang-built-linux>`_: <clang-built-linux@googlegroups.com>
+- `Mailing List <https://lore.kernel.org/llvm/>`_: <llvm@lists.linux.dev>
+- `Old Mailing List Archives <https://groups.google.com/g/clang-built-linux>`_
 - `Issue Tracker <https://github.com/ClangBuiltLinux/linux/issues>`_
 - IRC: #clangbuiltlinux on chat.freenode.net
 - `Telegram <https://t.me/ClangBuiltLinux>`_: @ClangBuiltLinux
_
