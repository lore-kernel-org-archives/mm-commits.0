Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FE3C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFB22074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598298341;
	bh=FtRT0J1MhFGewRDYDO7Sgx0YkmNItzxs53AOw6uEKzQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qBEtgoUSLzjmxW5KSbIbWfYcAJ2qXt9SJs7AyvhReiVCrPAp/0vImS/SnkutyLeh9
	 MeyO083jPsQQL98Pgyq6o3tSgxxm6GpG2XDxaxwcRy9Rv6jQWkE/egvHJCkKEIu82R
	 IYIbkFz/TP+JVlxpAxzpFfCZ9CsMJClxOpQ+lClc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgHXTpk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXTpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 15:45:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590CA20706;
        Mon, 24 Aug 2020 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598298339;
        bh=FtRT0J1MhFGewRDYDO7Sgx0YkmNItzxs53AOw6uEKzQ=;
        h=Date:From:To:Subject:From;
        b=CLXw855HyFsYMHdZXXXJvtCQUXivfg7J7fTNXeudYuggjycna+NsKanLqhLxXzJot
         1iSSLuyC8MNOwIX5s1DmsU65HgZ6jf99MpiNph3xPrtCArajv4/hdmEMu9tJSNdx3x
         ZW1BmxV0rRK3qFsFK7H8l4oIKETMwFFigvttZHvc=
Date:   Mon, 24 Aug 2020 12:45:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        john.ogness@linutronix.de, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, pmladek@suse.com
Subject:  +
 scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <20200824194538.eeR5z75XE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch

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
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

