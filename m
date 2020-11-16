Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E332C4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A8A20781
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfcFJ1tF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732256AbgKPUXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgKPUXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:23:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D0F20781;
        Mon, 16 Nov 2020 20:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605558181;
        bh=fz4tCg2EzADj5PzWqWEtYvq1uU51RxpoSZM1RBJZPnE=;
        h=Date:From:To:Subject:From;
        b=TfcFJ1tFntyYDt3Lt/XTJGJ+w/KbnDm+jjaq3FMpK5/cHaNRD21HEs7ml0fhhmlhc
         dLKbPvg9AysSKen7vq1tZL/d8Cfp37gCJhZFU+0qkRX/Q89B4rnP6FvEKV/Pygzs1H
         ygr5Fu0mruOQBAc+RDMedNzLtbW/5J4AWZJ0wqaU=
Date:   Mon, 16 Nov 2020 12:23:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, corbet@lwn.net,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org
Subject:  + resource-fix-kernel-doc-markups-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <20201116202300.BmG8IEbOY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: resource-fix-kernel-doc-markups-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     resource-fix-kernel-doc-markups-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/resource-fix-kernel-doc-markups-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/resource-fix-kernel-doc-markups-checkpatch-fixes.patch

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

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
secretmem-add-memcg-accounting-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

