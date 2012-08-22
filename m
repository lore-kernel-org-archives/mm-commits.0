From: akpm@linux-foundation.org
Subject: + unicore32-select-generic-atomic64_t-support.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:24:24 -0700
Message-ID: <20120822192424.9AB7A1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38245 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2HVTYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:24:25 -0400
Received: by vbnl22 with SMTP id l22so159512vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:24:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ebiederm@xmission.com, gxt@mprc.pku.edu.cn


The patch titled
     Subject: unicore32: select generic atomic64_t support
has been added to the -mm tree.  Its filename is
     unicore32-select-generic-atomic64_t-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: unicore32: select generic atomic64_t support

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/unicore32/Kconfig~unicore32-select-generic-atomic64_t-support arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~unicore32-select-generic-atomic64_t-support
+++ a/arch/unicore32/Kconfig
@@ -6,6 +6,7 @@ config UNICORE32
 	select HAVE_DMA_ATTRS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
+	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
 	select ARCH_HAVE_CUSTOM_GPIO_H
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
unicore32-select-generic-atomic64_t-support.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
score-select-generic-atomic64_t-support.patch
rbtree-performance-and-correctness-test-fix.patch

