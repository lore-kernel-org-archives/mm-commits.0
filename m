Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC31C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B245C23118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgLPEPC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPEPC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:15:02 -0500
Date:   Tue, 15 Dec 2020 20:14:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092061;
        bh=R8EJ9iLNQc/xLZSzu4YlCJR+8KP8Yp0ClBjN2xUrbFc=;
        h=From:To:Subject:From;
        b=SNq7wpBeRmQ2nwpmxER2FNkQqn4SraI5VxhIk89LI/CXpvij2GIIcgWIcKZvT8irf
         kI5q1HoWAYFyXFiFG5cf4kcy4JUTl/lfFUEoK97+Y1lUXlbeZd8qrLekmXbx4OFarF
         cIn8h9Ix4jiMdTgHDlj6WykClgAhwpvIElWxeoUc=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, corbet@lwn.net,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 resource-fix-kernel-doc-markups-checkpatch-fixes.patch removed from -mm
 tree
Message-ID: <20201216041421.mhc8XvPqw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: resource-fix-kernel-doc-markups-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     resource-fix-kernel-doc-markups-checkpatch-fixes.patch

This patch was dropped because it was folded into resource-fix-kernel-doc-markups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: resource-fix-kernel-doc-markups-checkpatch-fixes

WARNING: please, no space before tabs
#78: FILE: kernel/resource.c:1381:
+ * ^Imerge it with adjacent, mergeable resources$

total: 0 errors, 1 warnings, 55 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/resource-fix-kernel-doc-markups.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Jonathan Corbet" <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-fix-kernel-doc-markups-checkpatch-fixes
+++ a/kernel/resource.c
@@ -1378,7 +1378,7 @@ static bool system_ram_resources_mergeab
 
 /**
  * merge_system_ram_resource - mark the System RAM resource mergeable and try to
- * 	merge it with adjacent, mergeable resources
+ *	merge it with adjacent, mergeable resources
  * @res: resource descriptor
  *
  * This interface is intended for memory hotplug, whereby lots of contiguous
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

resource-fix-kernel-doc-markups.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

