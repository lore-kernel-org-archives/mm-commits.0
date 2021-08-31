Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D97CC4320A
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F64A60FF2
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhHaWtX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhHaWtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA04261041;
        Tue, 31 Aug 2021 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450107;
        bh=+uoNPhF6ED+v935MsQcS1f4zOvjMu1xhHFTG2CmKjV4=;
        h=Date:From:To:Subject:From;
        b=zKdT7JPya5CXSkGZPDqXRlgaEN4AK/bZ45MFpoyJd0bXbzYpd/xTqi/HlzmooL0/Q
         +BEnBYlcXE+8CX+3cMQE2R+p++F4gwEZ6lwrGegJnMk1ZQeBYiiAu1HGJDuTsjakVM
         XFyMlRswtIw0KlU4ds8bFEkbSVDsJX9rpPaeyTS0=
Date:   Tue, 31 Aug 2021 15:48:26 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  + documentation-llvm-update-mailing-list.patch added to
 -mm tree
Message-ID: <20210831224826.eKHc3bRlo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/llvm: update mailing list
has been added to the -mm tree.  Its filename is
     documentation-llvm-update-mailing-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-llvm-update-mailing-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-llvm-update-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch
maintainers-update-clangbuiltlinux-mailing-list.patch
documentation-llvm-update-mailing-list.patch
documentation-llvm-update-irc-location.patch

