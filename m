Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB85C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7425633BE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhKORtk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238780AbhKORrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B14EE6329E;
        Mon, 15 Nov 2021 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997388;
        bh=cmSJs4J9elEyXAcZYN7O1eMtbQ7cB83plyYaze/bkog=;
        h=Date:From:To:Subject:From;
        b=E95bfSzp9FC45n66rB9nzrvfuvnPIzJzUgQHPyibSxvcKLZkpLXbQia15wQJ2UTBv
         7daYHTkpvFsAguyiVFVl50M3cMic9VkZ9BamLGVNgiKqAoQI/jp7QfgZ0qiigxA/N2
         DKaWvlbT+bVZU2pWjHaIZQza7nz8ljgND68P4cnA=
Date:   Mon, 15 Nov 2021 09:29:48 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de,
        mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch removed
 from -mm tree
Message-ID: <20211115172948.FpmyZaqFu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-test-use-underlying-string-helpers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

