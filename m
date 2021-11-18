Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F457C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4CA61A81
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 21:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhKRVUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 16:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKRVUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 16:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A077615E3;
        Thu, 18 Nov 2021 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637270251;
        bh=VWeNKGfWelNJCpCJUgixpCVzv8Ybml/tyn+CwQLcz98=;
        h=Date:From:To:Subject:From;
        b=jkfvTBKPFmHee38CVe0ZfKpZoztUtlae2OSsvgj8gxk1tVARXdwB4MXw4KW1YIkGE
         qOd3U0TJYZlegRtAFH0aNUuKz2pdPGx1N13yUPfFUFMcYyJCmOj968p3Bg6iixfpiW
         c2Dpi0qbzmuf4hwLDygiAnZVYmoo2zpoRU/GdeRQ=
Date:   Thu, 18 Nov 2021 13:17:30 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20211118211730.9XnJx-wqO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/bpf/index.rst |    4 ----
 1 file changed, 4 deletions(-)

--- a/Documentation/bpf/index.rst~linux-next-git-rejects
+++ a/Documentation/bpf/index.rst
@@ -12,8 +12,6 @@ BPF instruction-set.
 The Cilium project also maintains a `BPF and XDP Reference Guide`_
 that goes into great technical depth about the BPF Architecture.
 
-<<<<<<< HEAD
-libbpf
 ======
 
 Documentation/bpf/libbpf/index.rst is a userspace library for loading and interacting with bpf programs.
@@ -21,8 +19,6 @@ Documentation/bpf/libbpf/index.rst is a
 BPF Type Format (BTF)
 =====================
 
-=======
->>>>>>> linux-next/akpm-base
 .. toctree::
    :maxdepth: 1
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

