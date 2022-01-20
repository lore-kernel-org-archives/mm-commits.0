Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A675FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377944AbiATVb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377936AbiATVb2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECE19B81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8246BC36AEB;
        Thu, 20 Jan 2022 21:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714285;
        bh=oyjSifs/ybXd76kPH27uhNbVuB8ueI4DwA6OojqRhFI=;
        h=Date:From:To:Subject:From;
        b=hROV/4MnrsEzVBem4eo7p21q5t2ZQPzefP8AgJcOP60/AdRAwazGABIE5l5AtxlGa
         Pmamu1kj71l0zTDA+Ij0QelMAL5tP2LGVwNSm+IAU3hqF1ti2g+VTrUQjmC9QPy8OO
         UMMFsFbz7EOBqAcd7i0XobcUfTtRrAQiO5jXnPcQ=
Date:   Thu, 20 Jan 2022 13:31:25 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        elver@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 panic-use-error_report_end-tracepoint-on-warnings-fix.patch removed from
 -mm tree
Message-ID: <20220120213125.GoXyX1znF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic-use-error_report_end-tracepoint-on-warnings-fix
has been removed from the -mm tree.  Its filename was
     panic-use-error_report_end-tracepoint-on-warnings-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

