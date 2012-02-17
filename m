From: akpm@linux-foundation.org
Subject: + cris-select-generic_atomic64.patch added to -mm tree
Date: Fri, 17 Feb 2012 14:23:28 -0800
Message-ID: <20120217222328.99802A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:59214 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2BQWX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 17:23:29 -0500
Received: by qadb12 with SMTP id b12so516361qad.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 14:23:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     Subject: cris: select GENERIC_ATOMIC64
has been added to the -mm tree.  Its filename is
     cris-select-generic_atomic64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -49,6 +49,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_ATOMIC64
 
 config HZ
 	int
_
Subject: Subject: cris: select GENERIC_ATOMIC64

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
cris-select-generic_atomic64.patch
nmi-watchdog-do-not-use-cpp-symbol-in-kconfig.patch
kcore-make-get_sparsemem_vmemmap_info-static.patch
proc-clean-up-proc-pid-environ-handling.patch

