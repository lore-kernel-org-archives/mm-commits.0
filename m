Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DD0C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbiDHUL2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbiDHULX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DC420D538
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 13:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25FFD61E28
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876BC385A1;
        Fri,  8 Apr 2022 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448557;
        bh=Xj7cE8c6+xY8r3iB8wRucoyiEjHGn6UoRMQ8ZHjC4qU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Xb1qjYWWe2cWTbQOm/+KmsTDPsYPP49AlY6kiJh7y5QdJoAgeYb672TzoEV9SxN1p
         d9OZxHL6SH6KIXvxAEgTV6ekvTDQnUk+fjwcmEWPc/F2VQwc8Xjjkjjy/SVUFxSq17
         2vzGSg1XwxWO9D60yHKARhteXIAkuyssVZ1fy+Z4=
Date:   Fri, 08 Apr 2022 13:09:16 -0700
To:     ndesaulniers@google.com, nathan@kernel.org, trix@redhat.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 9/9] MAINTAINERS: add Tom as clang reviewer
Message-Id: <20220408200917.7876BC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
