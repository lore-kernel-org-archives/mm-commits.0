Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F79FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746DB611CC
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347995AbhIIVGI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348678AbhIIVFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D93611F0;
        Thu,  9 Sep 2021 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221445;
        bh=CofomM57qZIv7TBFQKB341s3RF6a9RBfD8w09VWIN60=;
        h=Date:From:To:Subject:From;
        b=SFCQdITJUIGYmeLUb0iCItGKXqkOTVlr711Dl8YNGI4TqaNwKsRMbOVmO2uqcw9z2
         l50ByZ9lE5nWvyZRM233nh0Y1raxgANTwuWWL0Sr8WKQ+t1ec8iLKnuZ6dVaI6PvRN
         ZDX00GmsoxX7IVUZplA9JdHZ2J7pJazy6woixXSM=
Date:   Thu, 09 Sep 2021 14:04:05 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  [merged]
 maintainers-update-clangbuiltlinux-mailing-list.patch removed from -mm tree
Message-ID: <20210909210405.foOFeGXrE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ClangBuiltLinux mailing list
has been removed from the -mm tree.  Its filename was
     maintainers-update-clangbuiltlinux-mailing-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


