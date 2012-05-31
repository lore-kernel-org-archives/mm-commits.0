From: akpm@linux-foundation.org
Subject: [merged] cris-select-generic_atomic64.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:32 -0700
Message-ID: <20120531191332.47C56A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65320 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2EaTNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:13:34 -0400
Received: by were53 with SMTP id e53so75779wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: select GENERIC_ATOMIC64
has been removed from the -mm tree.  Its filename was
     cris-select-generic_atomic64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: cris: select GENERIC_ATOMIC64

Cris doesn't implement atomic64 operations neither, should select
GENERIC_ATOMIC64.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/Kconfig~cris-select-generic_atomic64 arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-select-generic_atomic64
+++ a/arch/cris/Kconfig
@@ -40,6 +40,7 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
+	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
fs-move-file_remove_suid-to-fs-inodec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch

