Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5027C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D33611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348035AbhIIVGI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348679AbhIIVFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C210611C3;
        Thu,  9 Sep 2021 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221448;
        bh=RijfI4W6KkA4V81IL05AEFdu6P00VYFg3ZtHqqe65MA=;
        h=Date:From:To:Subject:From;
        b=TJUWxeljUOafNSbUeQl1dRsznngEhMNpjoLFAyuCGi49fMuYkNOvAQVvjP50Nduft
         QwGvF1FPl4KNGPZmp4Et3qIBlDHeanLrOIy0/gBHWxAi6bNjBBDXj5a+wsUDSVCkWM
         PqvMErw8UpkJHpPIAG0U+ylpmNpnhT943qliNd4E=
Date:   Thu, 09 Sep 2021 14:04:08 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  [merged] documentation-llvm-update-mailing-list.patch
 removed from -mm tree
Message-ID: <20210909210408.S4V3o0lIN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/llvm: update mailing list
has been removed from the -mm tree.  Its filename was
     documentation-llvm-update-mailing-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from nathan@kernel.org are


