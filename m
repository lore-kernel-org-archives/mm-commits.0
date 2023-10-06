Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD98E9412F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjJFVrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbjJFVrT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05551110
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161D7C433C8;
        Fri,  6 Oct 2023 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628836;
        bh=wr0vpaHb82buk6eUNsBt4iiH7t2f3X3cu6V/5pTKuGQ=;
        h=Date:To:From:Subject:From;
        b=Imp14tSvUNPlGMZ4+GfJ1+Q/vygIVkjJ7Fj9U6JiAt0LpLjYa+/kFC5VJ9x4Y0Nfl
         czHJFrDf9NZkDkute755ya6V3Xkom3I2CgY9qvftrffAqHnBEzVFRfEGUxng1zdZ2g
         6XReHnezQ8bOAsT1TKwwLZO5WquhlVHGKWs5RUoI=
Date:   Fri, 06 Oct 2023 14:47:13 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-ksm-document-smart-scan-mode-fix.patch removed from -mm tree
Message-Id: <20231006214716.161D7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-ksm-document-smart-scan-mode-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-document-smart-scan-mode-fix.patch

This patch was dropped because it was folded into mm-ksm-document-smart-scan-mode.patch

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
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch

