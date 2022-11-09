Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D741FC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKIBa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiKIBa0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4848661749
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF21BB81C38
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEC4C433D6;
        Wed,  9 Nov 2022 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957421;
        bh=KZ7IK6BxpI4YbfjgRCBdPQRTjbebtn1dP9a60Pmw0O8=;
        h=Date:To:From:Subject:From;
        b=T1GKoD2PXoZoIDIh7cvxgkuOukqFtSFRrM/LOWxaRZHlwmmuLUSCW/LbslCh5n0HR
         MkNM7XEd6PUnSfs3fpIjEr2nnNKGqfaAJVcwxJKRq7QI7eeiYbQJvNOxU7RIAdWj+R
         wGRsfGrguHTOgsVo4Nxbp43m2TQBb1FkKyHeryJc=
Date:   Tue, 08 Nov 2022 17:30:21 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20221109013021.8AEC4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch

This patch was dropped because it was folded into vmalloc-add-reviewers-for-vmalloc-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
Date: Tue Oct 18 03:17:35 PM PDT 2022


WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#39: FILE: MAINTAINERS:13300:
+F:	mm/vmalloc.c
+F:	include/linux/vmalloc.h

total: 0 errors, 1 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/vmalloc-add-reviewers-for-vmalloc-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
+++ a/MAINTAINERS
@@ -13305,8 +13305,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/vmalloc.c
 F:	include/linux/vmalloc.h
+F:	mm/vmalloc.c
 
 MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vmalloc-add-reviewers-for-vmalloc-code.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

