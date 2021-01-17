Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CCDC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A4120770
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbhAQWDo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 17:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQWDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 17:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BEF520770;
        Sun, 17 Jan 2021 22:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610920983;
        bh=MfMYzZoudLJ/VarXMrqP3i71gnYlrBhZXtXV9u0mt4A=;
        h=Date:From:To:Subject:From;
        b=zUtVMW42PuOvIsiLWzA43l2F73j9FyC6b81MGeDlC9WXTzZ9Sz+VlZi5AAN6tcHVs
         4yNQR/E/Q8YepMoN25io0q0Q3KYl8B4tF1ypeUhtEemfjRO4dVrdht1L5kt7RbQjlb
         xUqOZMmvdDtIBHFl6DYlynDVMaQnx+OJ42zHxB5k=
Date:   Sun, 17 Jan 2021 14:03:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com
Subject:  +
 maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch added
 to -mm tree
Message-ID: <20210117220302.vd8D08AK6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add a couple more files to the Clang/LLVM section
has been added to the -mm tree.  Its filename is
     maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from natechancellor@gmail.com are

maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch

