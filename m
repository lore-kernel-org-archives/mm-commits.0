Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AA7C6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 21:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2EC3217A0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 21:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgLBVi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 16:38:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgLBVi5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 16:38:57 -0500
Date:   Wed, 02 Dec 2020 13:38:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606945090;
        bh=fVmMzaaLH7oEYw7k8V/E4FhnbP5LoamBjq/PGr1gOV4=;
        h=From:To:Subject:From;
        b=q9fqYORhTm4urPjb0xa9SWVSXdhhU7QLmfkBPZmhhdcLmcmL5S250pYF9xOjEGIGN
         Btsy+AIntcfxOKZlUD/4p8Fakkd51YDUi/YG7alwWCLziNHrIX5LqcEXIf7sySpNTE
         lgTzFDvluVO3X8aUqiQfnf2aG1PaRGjkfooYi8Gc=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201202213809.0RWeIqdSD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/exception.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm64/include/asm/exception.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/exception.h
@@ -37,11 +37,7 @@ asmlinkage void enter_from_user_mode(voi
 asmlinkage void exit_to_user_mode(void);
 void arm64_enter_nmi(struct pt_regs *regs);
 void arm64_exit_nmi(struct pt_regs *regs);
-<<<<<<< HEAD
-void do_mem_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs);
-=======
 void do_mem_abort(unsigned long far, unsigned int esr, struct pt_regs *regs);
->>>>>>> linux-next/akpm-base
 void do_undefinstr(struct pt_regs *regs);
 void do_bti(struct pt_regs *regs);
 asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

