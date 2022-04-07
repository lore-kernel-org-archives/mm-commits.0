Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58450C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 20:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiDGUzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 16:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiDGUzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 16:55:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9B8972E2
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 13:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE36A61F3C
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 20:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A33C385A9;
        Thu,  7 Apr 2022 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649364709;
        bh=IrY+laePgclmDUTc5Ny8M+oVle03r6ooESKvUkznB+I=;
        h=Date:To:From:Subject:From;
        b=zpmzMbC3FvQw0P63vy3PrjvyZhzyaEuag7r6xZONGr6Y1OOr97pm5WQUID/4NLQJs
         JaUac6p42xdfM8Xy8gSTQKzABrw3qZEXbtPFmNEp//QcaHSBR5WvrBcVHXgffi2+A2
         uqNpV1VB30Bc16x7EcKFcGenlwv+ZxqX1KH/7QIk=
Date:   Thu, 07 Apr 2022 13:51:48 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-self-as-clang-reviewer.patch added to -mm tree
Message-Id: <20220407205149.41A33C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Tom as clang reviewer
has been added to the -mm tree.  Its filename is
     maintainers-add-self-as-clang-reviewer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-self-as-clang-reviewer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-self-as-clang-reviewer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: MAINTAINERS: add Tom as clang reviewer

I have been helping with build breaks and other clang things and would
like to help with the reviews.

Link: https://lkml.kernel.org/r/20220407175715.3378998-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-self-as-clang-reviewer
+++ a/MAINTAINERS
@@ -4791,6 +4791,7 @@ F:	.clang-format
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
+R:	Tom Rix <trix@redhat.com>
 L:	llvm@lists.linux.dev
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_

Patches currently in -mm which might be from trix@redhat.com are

maintainers-add-self-as-clang-reviewer.patch
lib-remove-back_str-initialization.patch

