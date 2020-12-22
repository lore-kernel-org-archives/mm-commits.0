Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BD8C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 18:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1777322AB9
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 18:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgLVSgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgLVSgh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 13:36:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F7722AB9;
        Tue, 22 Dec 2020 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608662156;
        bh=IKXfCs1nDaOibl840IsoDf3IDjzM7M1fhXyX3SigGgw=;
        h=Date:From:To:Subject:From;
        b=cw9gKJK7YmILseXdttPc64x2MET/No6Z/4APSEG/KZntU9gDMZnerapc0hGm2qHsC
         PTOyHTsNazggzrRVvrciY0mBm0yE4by1c8IMaOag+JbswCLArjgD40Vaa4S8zgYdtK
         9NuvSjVdx474hbJ41Z5FT3GdMTE492Mp98bjG3R4=
Date:   Tue, 22 Dec 2020 10:35:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix.patch added to
 -mm tree
Message-ID: <20201222183554.U_GDE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix
has been added to the -mm tree.  Its filename is
     arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/asm-generic/unistd.h~arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix
+++ a/include/uapi/asm-generic/unistd.h
@@ -869,7 +869,7 @@ __SYSCALL(__NR_memfd_secret, sys_memfd_s
 #endif
 
 #undef __NR_syscalls
-#define __NR_syscalls 443
+#define __NR_syscalls 444
 
 /*
  * 32 bit systems traditionally used different
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix-fix.patch

