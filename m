From: akpm@linux-foundation.org
Subject: + kfifo-fix-kernel-doc-notation.patch added to -mm tree
Date: Tue, 26 Jan 2010 14:29:26 -0800
Message-ID: <201001262229.o0QMTQmx024656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167Ab0AZWaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 17:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, stefani@seibold.net


The patch titled
     kfifo: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     kfifo-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kfifo kernel-doc warnings:

Warning(kernel/kfifo.c:361): No description found for parameter 'total'
Warning(kernel/kfifo.c:402): bad line:  @ @lenout: pointer to output variable with copied data
Warning(kernel/kfifo.c:412): No description found for parameter 'lenout'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kfifo.c~kfifo-fix-kernel-doc-notation kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-fix-kernel-doc-notation
+++ a/kernel/kfifo.c
@@ -349,6 +349,7 @@ EXPORT_SYMBOL(__kfifo_from_user_n);
  * @fifo: the fifo to be used.
  * @from: pointer to the data to be added.
  * @len: the length of the data to be added.
+ * @total: the actual returned data length.
  *
  * This function copies at most @len bytes from the @from into the
  * FIFO depending and returns -EFAULT/0.
@@ -399,7 +400,7 @@ EXPORT_SYMBOL(__kfifo_to_user_n);
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
- @ @lenout: pointer to output variable with copied data
+ * @lenout: pointer to output variable with copied data
  *
  * This function copies at most @len bytes from the FIFO into the
  * @to buffer and 0 or -EFAULT.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kfifo-fix-kernel-doc-notation.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

