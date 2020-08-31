Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BCCC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BD6206FA
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598899771;
	bh=d6se9hygOCg5ruPB2F4B3eJU5naNu/Vy5RVL0VWipag=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eyWU9yc0AOBgmv44erC+4w1JQ54tr0cM9jlcR3VVvJaXEn3uRPbWy1TNeRo9sN8yE
	 niOCq8phT5ujxY4o4mre9FTB+5Eu9uW0S+AheLAyXcrFk0V15HL9qbNt6gQWzcZ3Zs
	 6t6vWmqXEbhqF8Cghhy2eutu/h7Bjmc2mryUaTGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHaStb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 14:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgHaSt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 14:49:29 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C92206FA;
        Mon, 31 Aug 2020 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598899769;
        bh=d6se9hygOCg5ruPB2F4B3eJU5naNu/Vy5RVL0VWipag=;
        h=Date:From:To:Subject:From;
        b=vhtuEaZdBJElSejn0xDMmt7Op5J0ZTX1Q8JPS9LRegsyCdniJyZZ38R6t9RwLEndD
         LKJ7/1DtTU+MwKZvsdd1rVlSp7yTG2rh3vsrMeF0ow/+2IuDeBehid+e7BW5bpqxlY
         Tq6sM+edKkg67LyeI3BAsJ/dt0GHIJiOlgLh3b0I=
Date:   Mon, 31 Aug 2020 11:49:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        fenghua.yu@intel.com, rdunlap@infradead.org
Subject:  + maintainers-ia64-mark-status-as-odd-fixes-only.patch
 added to -mm tree
Message-ID: <20200831184928.o232M%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: IA64: mark Status as Odd Fixes only
has been added to the -mm tree.  Its filename is
     maintainers-ia64-mark-status-as-odd-fixes-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-ia64-mark-status-as-odd-fixes-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-ia64-mark-status-as-odd-fixes-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -8256,7 +8256,7 @@ IA64 (Itanium) PLATFORM
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

maintainers-ia64-mark-status-as-odd-fixes-only.patch
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

