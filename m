Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63595C10DAA
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 204562087C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927889;
	bh=c0ltLMTXtbecnLN0Jg5bLBtD/kqF1kF1e/u27YQU4RE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yzSPDVZ8Ba6L8oZ7khUUs1hhgk5M6TtsTTmHfNJIWODBgRZh+uYmdCfWotacCZtFf
	 3MzcCRuuUT754zfPwRV8B7z8UQJ8P8OdVvxLJ4FDo/DAw8NZCQe50NLc25CMW+A+qe
	 qA35LAuGwZA6ovD/i4EkqDRUSGfTHDEnwfI7BatE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgILQY1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgILQXp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 725CA21655;
        Sat, 12 Sep 2020 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927824;
        bh=c0ltLMTXtbecnLN0Jg5bLBtD/kqF1kF1e/u27YQU4RE=;
        h=Date:From:To:Subject:From;
        b=J+6vG1pj5zgRWk8w1JKBIhrCPuKq5VednLIvJhmXI5rZWrJ5a9FvevVNEykHLwFiQ
         V12HijIyD86ro4zbjRxtl1Ckz6rMYwmwKt605eJCCGsKhqMe5SN7Fk4RklRgE1ADui
         CtZ0H4gebsCH9Ke5K4aJ4dQ7ApBj0ESgyqFSMrxA=
Date:   Sat, 12 Sep 2020 09:23:44 -0700
From:   akpm@linux-foundation.org
To:     fenghua.yu@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, tony.luck@intel.com
Subject:  [merged]
 maintainers-ia64-mark-status-as-odd-fixes-only.patch removed from -mm tree
Message-ID: <20200912162344.Ajw4h0UXu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: IA64: mark Status as Odd Fixes only
has been removed from the -mm tree.  Its filename was
     maintainers-ia64-mark-status-as-odd-fixes-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: IA64: mark Status as Odd Fixes only

IA64 isn't really being maintained, so mark it as Odd Fixes only.

Link: http://lkml.kernel.org/r/7e719139-450f-52c2-59a2-7964a34eda1f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-ia64-mark-status-as-odd-fixes-only
+++ a/MAINTAINERS
@@ -8272,7 +8272,7 @@ IA64 (Itanium) PLATFORM
 M:	Tony Luck <tony.luck@intel.com>
 M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	linux-ia64@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 F:	Documentation/ia64/
 F:	arch/ia64/
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option-fix.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

