Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E86C4361B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 23:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0C82250F
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 23:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgLNXbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 18:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgLNXbf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 18:31:35 -0500
Date:   Mon, 14 Dec 2020 15:30:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607988654;
        bh=T6taWbcdU8EpE9wiAMF4VPbKnEox2zqeSRDWtPSQtn0=;
        h=From:To:Subject:From;
        b=c4cXRPTb7ww1fSbTYAEPyeTQAI6Dl72F4JntS6n+m+ZCcB39sIb3XG1pb7cAeIaLM
         sEmWTzat/hUE8fvD9rZ8NntSTuEmcgB8wERR0MbWwkkFLUTvoY1XjirqAQZbtpvs7r
         QzIOx+CY6Y2y2ylzzyhqnTPoa/aJy53ZPAFBZTKM=
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, sfr@canb.auug.org.au
Subject:  +
 secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch added to -mm
 tree
Message-ID: <20201214233054.jj4o_opls%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem-test-add-basic-selftest-for-memfd_secret2-fix
has been added to the -mm tree.  Its filename is
     secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: secretmem-test-add-basic-selftest-for-memfd_secret2-fix

fix build

Link: https://lkml.kernel.org/r/248f928b-1383-48ea-8584-ec10146e60c9@nvidia.com
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/memfd_secret.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/vm/memfd_secret.c~secretmem-test-add-basic-selftest-for-memfd_secret2-fix
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -29,8 +29,6 @@
 
 #ifdef __NR_memfd_secret
 
-#include <linux/secretmem.h>
-
 #define PATTERN	0x55
 
 static const int prot = PROT_READ | PROT_WRITE;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestssh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-2x-speedup-for-run_vmtestssh.patch
mm-cleanup-remove-unused-tsk-arg-from-__access_remote_vm.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

