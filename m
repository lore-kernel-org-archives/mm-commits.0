From: akpm@linux-foundation.org
Subject: + score-select-generic-atomic64_t-support.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:23:24 -0700
Message-ID: <20120822192324.985741E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:65359 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2HVTXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:23:25 -0400
Received: by ghbz15 with SMTP id z15so161207ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:23:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, lennox.wu@gmail.com


The patch titled
     Subject: score: select generic atomic64_t support
has been added to the -mm tree.  Its filename is
     score-select-generic-atomic64_t-support.patch

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
Subject: score: select generic atomic64_t support

It's required for the core fs/namespace.c and many other basic features.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/score/Kconfig~score-select-generic-atomic64_t-support arch/score/Kconfig
--- a/arch/score/Kconfig~score-select-generic-atomic64_t-support
+++ a/arch/score/Kconfig
@@ -6,12 +6,13 @@ config SCORE
        select GENERIC_IRQ_SHOW
        select GENERIC_IOMAP
        select HAVE_MEMBLOCK
+       select GENERIC_ATOMIC64
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
        select HAVE_MOD_ARCH_SPECIFIC
-	select MODULES_USE_ELF_REL
+       select MODULES_USE_ELF_REL
 
 choice
 	prompt "System type"
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
score-select-generic-atomic64_t-support.patch
h8300-select-generic-atomic64_t-support.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch

