Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60CBE7F150
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 02:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjI0CwD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 22:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjI0CuD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 22:50:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE40170F
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 17:51:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A45C433C7;
        Wed, 27 Sep 2023 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695775865;
        bh=iZzFGKsunHValES/QbotZ18tpQTZSMhXhmg3uVF/P/c=;
        h=Date:To:From:Subject:From;
        b=z2p70PiXVs931+Pbw+LFXezkUxxTLWqlIeS2rp6bguODpZCFQjRvMKH1doIgsCpN+
         PAORLu/hGctCZyOBL9G0ibs01oOwDnpHnpfdCVhgU1KlP926xiRiIoE500Gi8MSKM4
         V7DnrD/XtV7wsLugCpLb4u/GMDwtpxiykCLTWkD8=
Date:   Tue, 26 Sep 2023 17:51:04 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-document-smart-scan-mode-fix.patch added to mm-unstable branch
Message-Id: <20230927005105.88A45C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-document-smart-scan-mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-document-smart-scan-mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-document-smart-scan-mode-fix.patch

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
Subject: mm-ksm-document-smart-scan-mode-fix
Date: Tue Sep 26 05:49:41 PM PDT 2023

fix typo

Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-smart-scan-mode-fix
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -162,7 +162,7 @@ smart_scan
         skipped. How often these pages are skipped depends on how often
         de-duplication has already been tried and failed. By default this
         optimization is disabled. The ``pages_skipped`` metric shows how
-        effetive the setting is.
+        effective the setting is.
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
kthread-add-kthread_stop_put-v2-fix.patch

