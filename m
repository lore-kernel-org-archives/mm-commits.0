Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F42EC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0416103D
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhHaWtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhHaWtV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FE360FE6;
        Tue, 31 Aug 2021 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450105;
        bh=Hl/WfPkbasP01ORmDG1xJWi3RjSQ6O43uNkoB0RWkE8=;
        h=Date:From:To:Subject:From;
        b=mXaqQgZ+Fa3iXBkRt9Yp7JyWE/Q4/xC0NN22irCufU/aSbc0gqelSfqk9tNmzvRxS
         f7+BG4BcLLxISLtLICoeUOvk/TGyLOWyoneKRtALtZttYdWxikWdieVm6t7JM9NWur
         HyMZb2nNfhQ2fNtHrSLuJENgnKUaOt0wgKNfL9vQ=
Date:   Tue, 31 Aug 2021 15:48:24 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  + maintainers-update-clangbuiltlinux-mailing-list.patch
 added to -mm tree
Message-ID: <20210831224824.lNdQyhmGG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ClangBuiltLinux mailing list
has been added to the -mm tree.  Its filename is
     maintainers-update-clangbuiltlinux-mailing-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-clangbuiltlinux-mailing-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-clangbuiltlinux-mailing-list.patch

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
Subject: MAINTAINERS: update ClangBuiltLinux mailing list

We are now at llvm@lists.linux.dev.

Link: https://lkml.kernel.org/r/20210825211823.6406-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-clangbuiltlinux-mailing-list
+++ a/MAINTAINERS
@@ -4504,7 +4504,7 @@ F:	.clang-format
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
-L:	clang-built-linux@googlegroups.com
+L:	llvm@lists.linux.dev
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
 B:	https://github.com/ClangBuiltLinux/linux/issues
@@ -4519,7 +4519,7 @@ M:	Sami Tolvanen <samitolvanen@google.co
 M:	Kees Cook <keescook@chromium.org>
 R:	Nathan Chancellor <nathan@kernel.org>
 R:	Nick Desaulniers <ndesaulniers@google.com>
-L:	clang-built-linux@googlegroups.com
+L:	llvm@lists.linux.dev
 S:	Supported
 B:	https://github.com/ClangBuiltLinux/linux/issues
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/clang/features
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch
maintainers-update-clangbuiltlinux-mailing-list.patch
documentation-llvm-update-mailing-list.patch
documentation-llvm-update-irc-location.patch

