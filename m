Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3047C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC094617E3
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348768AbhKPBGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245379AbhKOTU0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4FDE6346D;
        Mon, 15 Nov 2021 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637001217;
        bh=zwJcpM7oxlljILAux7oQN7jRHVzs93U7RIvu33aiRtc=;
        h=Date:From:To:Subject:From;
        b=DLh8M6dEjAYOV9x7RlZX4i+5zhTnWVCW+biiY+4zbL3+AL0N0V3TAim/s5k/jWcAv
         0XPTND764x8Yb3ObTXzJgUU0gzA4EsteIvC4AFhBjiBI/nnvlv8AgtuVMmeQmjZF2J
         /3MatNZ9rwnLE41D0ZQfLkJ6JUOGpck9U/nSjSm0=
Date:   Mon, 15 Nov 2021 10:33:37 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        elver@google.com, mm-commits@vger.kernel.org
Subject:  +
 panic-use-error_report_end-tracepoint-on-warnings-fix.patch added to -mm
 tree
Message-ID: <20211115183337.-JrkuEgrc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic-use-error_report_end-tracepoint-on-warnings-fix
has been added to the -mm tree.  Its filename is
     panic-use-error_report_end-tracepoint-on-warnings-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-use-error_report_end-tracepoint-on-warnings-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-use-error_report_end-tracepoint-on-warnings-fix.patch

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
Subject: panic-use-error_report_end-tracepoint-on-warnings-fix

add comma to enum list, per Andy.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/error_report.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/error_report.h~panic-use-error_report_end-tracepoint-on-warnings-fix
+++ a/include/trace/events/error_report.h
@@ -18,7 +18,7 @@
 enum error_detector {
 	ERROR_DETECTOR_KFENCE,
 	ERROR_DETECTOR_KASAN,
-	ERROR_DETECTOR_WARN
+	ERROR_DETECTOR_WARN,
 };
 
 #endif /* __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

