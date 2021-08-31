Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04838C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CF661056
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHaWtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhHaWtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:49:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB58360FF2;
        Tue, 31 Aug 2021 22:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630450109;
        bh=PtQaV0JQJlQVgmA3UuXbkVhACF0hwN6e0+w/S3nmNI4=;
        h=Date:From:To:Subject:From;
        b=LNL18OX4cu1wPXjp0efkGfl5Ejo23trBhJPl/LLbrDYARJE7CJ3P+OrEUgG1yIHh8
         vD8Et8mIKnx4RFVMoZAy27WeICcxS/btAvrmePYiS66AGLZSifLXi9GMEd/PCl5Vd2
         54o7DQqfaYQ+Wb46RikVn3GDFTCeAOFT6c/5pLA8=
Date:   Tue, 31 Aug 2021 15:48:28 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  + documentation-llvm-update-irc-location.patch added to
 -mm tree
Message-ID: <20210831224828.VJvsbkIdF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/llvm: update IRC location
has been added to the -mm tree.  Its filename is
     documentation-llvm-update-irc-location.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/documentation-llvm-update-irc-location.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/documentation-llvm-update-irc-location.patch

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
Subject: Documentation/llvm: update IRC location

This should have been done with commit 91ed3ed0f798 ("MAINTAINERS: update
ClangBuiltLinux IRC chat") but I did not realize it was in two separate
spots.

Link: https://lkml.kernel.org/r/20210825211823.6406-3-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/llvm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/kbuild/llvm.rst~documentation-llvm-update-irc-location
+++ a/Documentation/kbuild/llvm.rst
@@ -114,7 +114,7 @@ Getting Help
 - `Mailing List <https://lore.kernel.org/llvm/>`_: <llvm@lists.linux.dev>
 - `Old Mailing List Archives <https://groups.google.com/g/clang-built-linux>`_
 - `Issue Tracker <https://github.com/ClangBuiltLinux/linux/issues>`_
-- IRC: #clangbuiltlinux on chat.freenode.net
+- IRC: #clangbuiltlinux on irc.libera.chat
 - `Telegram <https://t.me/ClangBuiltLinux>`_: @ClangBuiltLinux
 - `Wiki <https://github.com/ClangBuiltLinux/linux/wiki>`_
 - `Beginner Bugs <https://github.com/ClangBuiltLinux/linux/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22>`_
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch
maintainers-update-clangbuiltlinux-mailing-list.patch
documentation-llvm-update-mailing-list.patch
documentation-llvm-update-irc-location.patch

