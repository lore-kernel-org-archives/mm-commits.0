Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6BCC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D11611B0
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhJMVlX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhJMVlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE6B611AE;
        Wed, 13 Oct 2021 21:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634161159;
        bh=n7QJ2Ht2Ntr/0A6eHmCYBWyhVi7oQHpoMR2Vxzcs96k=;
        h=Date:From:To:Subject:From;
        b=HVI762snAbOCTHhTSz/CYCPNzCH5AfA3ZxszF4tgoVVp4VaAMWfUbgaHHQP4by+ct
         IwWNYOF+MOtKhDydd/+heklGT2+tQ4SZEPaPzf+63cnwgIc0/rPT8ZDcj7f/kRtXNd
         FwDsPDStJt+HVHD5P39274ngBY71w2I0/eX779/A=
Date:   Wed, 13 Oct 2021 14:39:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de,
        mm-commits@vger.kernel.org
Subject:  +
 kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch added to
 -mm tree
Message-ID: <20211013213918.HApP8Ttry%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-test-use-underlying-string-helpers-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch

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
Subject: kasan-test-use-underlying-string-helpers-checkpatch-fixes

WARNING: Block comments use a trailing */ on a separate line
#49: FILE: lib/test_kasan.c:837:
+ * */

total: 0 errors, 1 warnings, 37 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/kasan-test-use-underlying-string-helpers.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-test-use-underlying-string-helpers-checkpatch-fixes
+++ a/lib/test_kasan.c
@@ -834,7 +834,7 @@ static void kmem_cache_invalid_free(stru
 /*
  * noinline wrappers to prevent the compiler from noticing the overflow
  * at compile time rather than having kasan catch it.
- * */
+ */
 static noinline void *__kasan_memchr(const void *s, int c, size_t n)
 {
 	return memchr(s, c, n);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch
elfcore-correct-reference-to-config_uml-fix.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

