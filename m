Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCA5C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 17:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiHQRnS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbiHQRnR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 13:43:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CED4ED
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 10:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED17561312
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 17:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4555DC433D6;
        Wed, 17 Aug 2022 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660758187;
        bh=4f0TDSWOv5HKtwcgK7T71IJHPKiwvlo3o9i5F8Bl7sI=;
        h=Date:To:From:Subject:From;
        b=ORbZG2pNb+tA75zaTijhlw4pp4B8uqBd/SCBKft9UnDs8Sms9Y/RePZyQUTQQ28H3
         Y2j+OWJTkvd6Ik6xxpayh1ir6OBuLMSmkW1KFZXBokuba5fUDh7nc12nb+qWcjJUdo
         ulfXRS2Aqggk0Pz3H/gXfjJ+BCmFSIyvfwuxyStU=
Date:   Wed, 17 Aug 2022 10:43:06 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20220817174307.4555DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
Date: Wed Aug 17 10:42:29 AM PDT 2022


ERROR: code indent should use tabs where possible
#26: FILE: mm/zsmalloc.c:1562:
+         * kunmap_atomic(d_addr). For more details see$

ERROR: code indent should use tabs where possible
#27: FILE: mm/zsmalloc.c:1563:
+         * Documentation/mm/highmem$

total: 2 errors, 0 warnings, 10 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/zsmalloc-zs_object_copy-replace-email-link-to-doc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes
+++ a/mm/zsmalloc.c
@@ -1559,8 +1559,8 @@ static void zs_object_copy(struct size_c
 		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
 		 * calls must occurs in reverse order of calls to kmap_atomic().
 		 * So, to call kunmap_atomic(s_addr) we should first call
-         * kunmap_atomic(d_addr). For more details see
-         * Documentation/mm/highmem
+		 * kunmap_atomic(d_addr). For more details see
+		 * Documentation/mm/highmem.
 		 */
 		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch

