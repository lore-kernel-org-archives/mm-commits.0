Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D957C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61EF46135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhKKCyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhKKCym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783B56103C;
        Thu, 11 Nov 2021 02:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599114;
        bh=KYuLurvSf0+Mz2AWFoimkgU3PRqRGx1HJUtbg+sq2Hw=;
        h=Date:From:To:Subject:From;
        b=FT+dPQVVoklXTYKoy8yxTIKFLpVIMT9YcuAJtXaz3AMMMGUJR3xK8oQosaNg7RcAU
         jHAP2N6TY7x6zfmnJYdGCK1VJBhPHAqFHaxncPuy/TJyxJ4nmbxfwqOCOKuL4O8RY9
         3cKtXEmMqak7UdhxiQ43YhTLMGD2OVosYrOPd44A=
Date:   Wed, 10 Nov 2021 18:51:54 -0800
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 maintainers-add-exec-binfmt-section-with-myself-and-eric.patch removed from
 -mm tree
Message-ID: <20211111025154.5kduU1kXh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "exec & binfmt" section with myself and Eric
has been removed from the -mm tree.  Its filename was
     maintainers-add-exec-binfmt-section-with-myself-and-eric.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: MAINTAINERS: add "exec & binfmt" section with myself and Eric

I'd like more continuity of review for the exec and binfmt (and ELF)
stuff.  Eric and I have been the most active lately, so list us as
reviewers.

Link: https://lkml.kernel.org/r/20211006180200.1178142-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/MAINTAINERS~maintainers-add-exec-binfmt-section-with-myself-and-eric
+++ a/MAINTAINERS
@@ -7037,6 +7037,20 @@ F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 
+EXEC & BINFMT API
+R:	Eric Biederman <ebiederm@xmission.com>
+R:	Kees Cook <keescook@chromium.org>
+F:	arch/alpha/kernel/binfmt_loader.c
+F:	arch/x86/ia32/ia32_aout.c
+F:	fs/*binfmt_*.c
+F:	fs/exec.c
+F:	include/linux/binfmts.h
+F:	include/linux/elf.h
+F:	include/uapi/linux/binfmts.h
+F:	tools/testing/selftests/exec/
+N:	asm/elf.h
+N:	binfmt
+
 EXFAT FILE SYSTEM
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Sungjong Seo <sj1557.seo@samsung.com>
_

Patches currently in -mm which might be from keescook@chromium.org are

kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch

