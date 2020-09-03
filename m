Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63607C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D40A20C09
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599159840;
	bh=/91ZT5xI7R5lmHRqLhofH1LPy1hDW0DCBOWY/lJABRY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FMkyeMBmEZunYarFiNgmbasoRf+BW7tI9aJ0l5qcpYU0Bu9J0K/Na5unTQA9wx1yO
	 xRODUoWvHAD/o8ovDHN4FTmbM3BtAH6ZR/tU07jeZkskZjjDI/HVOv1NXU/qzX6FD8
	 4/Xs3yqqFqPT0ouZIBzY/ea18+XebjqC0XzqsABw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgICTD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbgICTDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:03:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9806A2098B;
        Thu,  3 Sep 2020 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599159833;
        bh=/91ZT5xI7R5lmHRqLhofH1LPy1hDW0DCBOWY/lJABRY=;
        h=Date:From:To:Subject:From;
        b=QiEi7UIcEdvqET5IDPBhA/PJPA3cOsIiFgirsP4JaEpvQqDfo7wi/UzpEmQkhj+0H
         v7wFzo+X36OIh0qh9f0Jcja+JyB4/8iwmQyhXsPQNLeQ/8xU6V4NNfEgL2EGqs2V2H
         4WBifJvw4PSHkDPN8wPU3LSc3HlLB4pGD+A8Nsr4=
Date:   Thu, 03 Sep 2020 12:03:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        john.ogness@linutronix.de, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, pmladek@suse.com
Subject:  [merged]
 scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20200903190353.HXgulcIrf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes

WARNING: Possible repeated word: 'the'
#190: FILE: Documentation/admin-guide/kdump/gdbmacros.txt:292:
+	sequence number, the the second is optional and specifies the

total: 0 errors, 1 warnings, 357 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/scripts-gdb-update-for-lockless-printk-ringbuffer.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/gdbmacros.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/gdbmacros.txt~scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes
+++ a/Documentation/admin-guide/kdump/gdbmacros.txt
@@ -289,7 +289,7 @@ define dump_record
 end
 document dump_record
 	Dump a single record. The first parameter is the descriptor
-	sequence number, the the second is optional and specifies the
+	sequence number, the second is optional and specifies the
 	previous record's flags, used for properly formatting
 	continued lines.
 end
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

