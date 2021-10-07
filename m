Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54BCC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8578B6113E
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 01:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJGBDF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Oct 2021 21:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240114AbhJGBDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Oct 2021 21:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81A8861152;
        Thu,  7 Oct 2021 01:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633568471;
        bh=MTQaBEv84SuwALXF2633R4RcHrYsSAUNuWrFgYAxH1s=;
        h=Date:From:To:Subject:From;
        b=j1Ov1MejkiwfLBAcG82yigpldQ5IP/M19SPS5+DwWwhy8Xa2jsOdOHrCeXUbXVZbQ
         y83VRCEdNaTH+Ud/OOmEpRoYyazFupPNgzmpm75XTLLQitPbYSudm28yV3Xc9QXVSF
         LtyKyMZFcmRB07xz2INcNg8BIWBCPFEwTzFaDXH0=
Date:   Wed, 06 Oct 2021 18:01:11 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  +
 maintainers-add-exec-binfmt-section-with-myself-and-eric.patch added to -mm
 tree
Message-ID: <20211007010111.-tq8rNB8n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add "exec & binfmt" section with myself and Eric
has been added to the -mm tree.  Its filename is
     maintainers-add-exec-binfmt-section-with-myself-and-eric.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-exec-binfmt-section-with-myself-and-eric.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7020,6 +7020,20 @@ F:	include/trace/events/mdio.h
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

kasan-test-bypass-__alloc_size-checks.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

